//
//  Application.swift
//  Relayboard Mobile Client
//
//  Created by user on 13.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import Foundation
import UIKit
import Meteor

public class RelayboardApplication {
    static let shared = RelayboardApplication()
    
    public var statusTimer: Timer!
    public var relayboards : [String:Relayboard]? = nil
    public var selectedRelayboard: Relayboard?
    public var controllers: [String:UIViewController] = [String:UIViewController]()
    
    private var Meteor : METDDPClient?
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
            }
        } else {
            completion("Incorrect connection options")
        }
    }
    
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
                                        relayboard.setStatus(relayboard_status)
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
    
    public func isDataLoaded() -> Bool {
        return relayboards != nil
    }
    
    private init() {
    }
}

