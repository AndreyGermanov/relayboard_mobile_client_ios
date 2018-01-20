//
//  LoadViewController.swift
//  Relayboard Mobile Client
//
//  Created by user on 20.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    @IBOutlet weak var loadingLabel: UILabel!
    
    var isConnected = false
    var isLoaded = false
    
    func initConnection() {
        
        RelayboardApplication.shared.connectToPortal({(error) in
            if error != nil {
                self.loadingLabel.text = "Portal connection failure"
                self.loadingLabel.textColor = UIColor.red
                self.performSegue(withIdentifier: "navControllerSegue", sender: self)
            } else {
                    self.isConnected = true
                    self.loadingLabel.text = "Loading configuration ..."
                    self.loadingLabel.textColor = UIColor.white

                RelayboardApplication.shared.getRelayboardsConfig({ (error) in
                    if error != nil {
                        self.loadingLabel.text = "Error loading configuration"
                        self.performSegue(withIdentifier: "navControllerSegue", sender: self)
                    } else {
                        self.isLoaded = true
                         let notification = Notification.init(name: Notification.Name(rawValue: "INIT_COMPLETE"))
                        NotificationCenter.default.post(notification)
                        RelayboardApplication.shared.statusTimer = Timer.scheduledTimer(timeInterval: 1.0, target: RelayboardApplication.shared, selector: #selector(RelayboardApplication.shared.getRelayboardsStatus), userInfo: nil, repeats: true)
                        RelayboardApplication.shared.statusTimer.fire()
                        self.performSegue(withIdentifier: "navControllerSegue", sender: self)
                    }
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? RootNavigationController
        
        destination?.popViewController(animated:false)
        if (!self.isConnected) {
            destination?.performSegue(withIdentifier: "retryConnectionSegue", sender: self)
        } else {
            destination?.performSegue(withIdentifier: "sitesMapSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initConnection()
    }
}
