//
//  Application.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 13.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// Core Application class, implemented as singleton. Aggregates information about
// Connection to portal, list of Relayboards. Contains methods to connect to portal
// and fetch infomation from it and construct Relayboards and Sensors data models using
// received data and status.

import Foundation
import UIKit
import Meteor

public class RelayboardApplication: NSObject {
    
    // Singleton pointer
    static let shared = RelayboardApplication()
    
    // Timer, used to get current status of relayboards every second
    public var statusTimer: Timer!
    // Timer, used to connect/reconnect to portal if needed
    public var connectionTimer: Timer!
    // Dictionary with list of relayboards
    public var relayboards : [String:Relayboard]? = nil
    // Pointer to selected relayboard
    public var selectedRelayboard: Relayboard?
    
    // Portal connection pointer
    private var Meteor : METDDPClient?
    
    // Function initiates connection to portal, using settings from User Defaults
    public func connectToPortal(_ completion:@escaping (_ error:Any?)->Void) {
        var host = "",port="80",login="",password=""
        
        if let inputHost = UserDefaults.standard.object(forKey: "host") as? String {
            host = inputHost
        }
        
        if let inputPort = UserDefaults.standard.object(forKey: "port") as? String {
            port = inputPort
        }
        
        if let inputLogin = UserDefaults.standard.object(forKey: "login") as? String {
            login = inputLogin
        }
        
        if let inputPassword = UserDefaults.standard.object(forKey: "password") as? String {
            password = inputPassword
        }
        
        if (host.count != 0 && port.count != 0 && login.count != 0) {
            self.Meteor = METCoreDataDDPClient.init(serverURL: URL(string: "ws://"+host+":"+port+"/websocket")!)
            if let Meteor = self.Meteor {
               
                Meteor.connect()
                Meteor.login(withEmail: login, password: password) { (error) in
                    completion(error)
                }
            } else {
                completion("Connection error")
            }
        } else {
            completion("Incorrect connection options")
        }
    }
    
    // Function fetches relayboard data from portal as a JSON object, parses it and constructs Relayboards and Sensors
    // objects, using fetched data
    public func getRelayboardsConfig(_ completion:@escaping (_ error: Any?)->Void)  {
        self.relayboards = [String:Relayboard]()
        self.Meteor?.callMethod(withName: "getConfig", parameters: nil, completionHandler: { (result, err) in
            if (err != nil) {
                completion(err)
            } else {
                let data = result as? String
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: (data?.data(using: String.Encoding.utf8))!, options: .mutableContainers) as? Dictionary<String, Any>
                    if let items = jsonData!["relayboards"] as? NSArray {
                        for item  in items {
                            if let relayboard = item as? Dictionary<String,Any> {
                                if let id = relayboard["id"] as? String {
                                    if let config = relayboard["config"] as? Dictionary<String,AnyObject> {
                                        if let title = config["title"] as? String {
                                            self.relayboards?[id] = Relayboard(id,title:title)
                                            self.relayboards?[id]?.setConfig(config)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    completion(nil)
                } catch {
                    completion("Config parse error")
                }
            }
        })
    }

    // Function fetches current status of relayboards and their sensors from portal as a JSON object
    // and passes this status to appropriate Relayboard objects, which then set new data and notify User interface
    // controllers to update interface with new data
    @objc func getRelayboardsStatus() {
        self.Meteor?.callMethod(withName: "getStatus", parameters: nil, completionHandler: { (result, err) in
            if (err != nil) {
               print(err)
            } else {
                let data = result as? String
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: (data?.data(using: String.Encoding.utf8))!, options: .mutableContainers) as? Dictionary<String, Any>
                    
                    if let items = jsonData!["statuses"] as? NSArray {
                        for item  in items {
                            if let relayboard_status = item as? Dictionary<String,Any> {
                                if let id = relayboard_status["id"] as? String {
                                    if let relayboard = self.relayboards?[id] {
                                        OperationQueue.main.addOperation {
                                            relayboard.setStatus(relayboard_status)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error parsing status")
                }
                
            }
        })
    }
    
    // Function which frist connects to portal and then fetches data from it
    public func initConfig(_ completion:@escaping (_ error: Any?) -> Void) {
        
        connectToPortal({(error) in
            if let errorMsg = error {
                completion(errorMsg)
            } else {
                self.getRelayboardsConfig({ (error) in
                    if let errorMsg = error {
                        completion(errorMsg)
                    } else {
                       
                        completion(nil)
                        
                    }
                })
            }
        })
    }
    
    // Utility function used to get relayboard by positional integer index from named dictionary
    public func getRelayboardByIndex(_ index: Int) -> Relayboard? {
        var result: Relayboard?
        if let relayboards = self.relayboards {
            var counter = 0;
            for (_,relayboard) in relayboards {
                if counter == index {
                    result = relayboard
                }
                counter = counter + 1
            }
        }
        return result
    }
    
    // Constructor which ensures that only single RelayboardApplication object can exist (singleton pattern)
    private override init() {
    }
    
}
