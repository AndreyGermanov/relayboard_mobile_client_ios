//
//  Sensor.swift
//  Relayboard Mobile Client
//
//  Created by user on 13.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit

enum SensorTypes {
    case RELAY
    case TEMPERATURE
    case WATER_PUMP
}

public class Sensor: NSObject {
    
    private var id: String
    private var type: SensorTypes?
    private var title: String?
    private var send_live_data: Bool?
    private var save_to_db_period: Int?
    private var send_to_portal_period: Int?
    private var relayboard: Relayboard
    
    init(_ id: String, relayboard: Relayboard) {
        self.id = id
        self.relayboard = relayboard
    }
    
    public func setConfig(_ config: AnyObject) {
        if let settings = config as? [String:String] {
            if settings["type"] != nil {
                switch settings["type"] {
                case "relay"?:
                    self.type = .RELAY
                case "temperature"?:
                    self.type = .TEMPERATURE
                case "water_pump"?:
                    self.type = .WATER_PUMP
                default:
                    break
                }
            }
            if settings["title"] != nil {
                self.title = settings["title"]!
            }
            if settings["send_live_data"] == "1" {
                self.send_live_data = true
            } else {
                self.send_live_data = false
            }
            if let save_to_db_period = Int(settings["save_to_db_period"]!) {
                self.save_to_db_period = save_to_db_period
            }
            if let send_to_portal_period = Int(settings["send_to_portal_period"]!) {
                self.send_to_portal_period = send_to_portal_period
            }
            print("INITIALIZED SENSOR \(self.id) OF Relayboard \(self.relayboard.id)")
            print("Title: \(self.title!)")
            print("Type: \(self.type!)")
            print("Send live data: \(self.send_live_data!)")
            print("Save to DB period: \(self.save_to_db_period!)")
            print("Send to portal period: \(self.send_to_portal_period!)")
        }
    }
}
