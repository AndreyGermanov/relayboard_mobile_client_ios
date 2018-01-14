//
//  Application.swift
//  Relayboard Mobile Client
//
//  Created by user on 13.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import Meteor

public class RelayboardApplication {
    static let shared = RelayboardApplication()
    var dataController: DataController!
    
    var relayboards : [String:Relayboard]? = nil
    private var Meteor : METDDPClient?
    public func loadData() {
        var host = "",port="80",login="",password=""
        
       
        self.relayboards = [String:Relayboard]()
        
        
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
                    if let errorMsg = error {
                        print(errorMsg)
                    } else {
                        Meteor.callMethod(withName: "getConfig", parameters: nil, completionHandler: { (result, err) in
                            if (err != nil) {
                                print(err)
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
                                } catch {
                                    print("Error parsing relayboards settings")
                                }
                            }
                        })
                       
                    }
                }
            }
        } else {
            print("Incorrect connection settings")
        }
    }
    
    public func isDataLoaded() -> Bool {
        return relayboards != nil
    }
    
    private init() {
    }
}

