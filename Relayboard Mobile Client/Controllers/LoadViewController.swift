//
//  LoadViewController.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 20.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// View controller of initial screen, which implements connection to portal and filling data models
// with fetched data

import UIKit

class LoadViewController: UIViewController {

    @IBOutlet weak var loadingLabel: UILabel!
    
    // Status of connection
    var isConnected = false
    
    // Status of data
    var isLoaded = false
    
    // Timer object, used for connection attempts
    var connectionTimer: Timer?
    
    // Timestamp of beginning of current connection attempt
    var beginConnectionTimestamp = 0
    
    // Function initiates connection attempt, then in case of success, logins to portal and fetches
    // data about relayboards. In case of success, it creates Relayboard and Sensor models for each
    // relayboard and sensor
    func initConnection() {
        
        self.beginConnectionTimestamp = Int(NSDate().timeIntervalSince1970)
        RelayboardApplication.shared.connectToPortal({(error) in
            if error != nil {
                OperationQueue.main.addOperation {
                    self.loadingLabel.text = "Portal connection failure"
                    self.loadingLabel.textColor = UIColor.red
                    self.performSegue(withIdentifier: "navControllerSegue", sender: self)
                }
            } else {
                self.isConnected = true
                self.connectionTimer?.invalidate()
                OperationQueue.main.addOperation {
                    self.loadingLabel.text = "Loading configuration ..."
                    self.loadingLabel.textColor = UIColor.white
                }
                
                RelayboardApplication.shared.getRelayboardsConfig({ (error) in
                    if error != nil {
                        OperationQueue.main.addOperation {
                            self.loadingLabel.text = "Error loading configuration"
                            self.performSegue(withIdentifier: "navControllerSegue", sender: self)
                        }
                    } else {
                        self.isLoaded = true
                        OperationQueue.main.addOperation {
                            let notification = Notification.init(name: Notification.Name(rawValue: "INIT_COMPLETE"))
                            NotificationCenter.default.post(notification)
                            RelayboardApplication.shared.statusTimer = Timer.scheduledTimer(timeInterval: 1.0, target: RelayboardApplication.shared, selector: #selector(RelayboardApplication.shared.getRelayboardsStatus), userInfo: nil, repeats: true)
                            RelayboardApplication.shared.statusTimer.fire()
                            self.performSegue(withIdentifier: "navControllerSegue", sender: self)
                        }
                    }
                })
            }
        })
    }
    
    // Function runs when screen should move to new screen. Depending on success of connection it
    // either moves to "Relays Map" screen, or to "Reconnect" screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? RootNavigationController
        
        destination?.popViewController(animated:false)
        if (!self.isConnected) {
            destination?.performSegue(withIdentifier: "retryConnectionSegue", sender: self)
        } else {
            destination?.performSegue(withIdentifier: "sitesMapSegue", sender: self)
        }
    }
    
    // Function runs every time when screen appears. Initiates timer object, which runs connection attempts
    // every second. If is not able to connect during 10 seconds, moves to "Reconnect" screen, where user
    // can check and update connection settings and try again
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.connectionTimer != nil) {
            self.connectionTimer?.invalidate()
        }
        self.connectionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if !self.isConnected && self.beginConnectionTimestamp>0 {
                let currentTimestamp = Int(NSDate().timeIntervalSince1970)
                if (currentTimestamp - self.beginConnectionTimestamp>20) {
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "navControllerSegue", sender: self)
                    }
                }
            }
        })
        if let timer = self.connectionTimer {
            timer.fire()
        }
        self.initConnection()
    }
    
    
}
