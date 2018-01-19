//
//  Sensor.swift
//  Relayboard Mobile Client
//
//  Created by user on 13.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit

public enum SensorTypes {
    case RELAY
    case TEMPERATURE
    case WATER_PUMP
}

public class Sensor: NSObject {
    
    public var id: String
    public var type: SensorTypes?
    public var title: String?
    public var send_live_data: Bool?
    public var save_to_db_period: Int?
    public var send_to_portal_period: Int?
    public var relayboard: Relayboard
    public var status: [String:Any]?
    
    init(_ id: String, relayboard: Relayboard) {
        self.id = id
        self.relayboard = relayboard
    }
    
    public func setConfig(_ config: [String:Any]) {
        for (key,value) in config {
            if key == "type" {
                if value != nil {
                    switch String(describing:value) {
                    case "relay":
                        self.type = .RELAY
                    case "temperature":
                        self.type = .TEMPERATURE
                    case "water_pump":
                        self.type = .WATER_PUMP
                    default:
                        break
                    }
                }
            }
            if key == "title" {
                self.title = String(describing:value)
            }
            if key == "send_live_data" {
                if (String(describing:value) == "1") {
                    self.send_live_data = true
                } else {
                    self.send_live_data = false
                }
            }
            if key == "save_to_db_period" {
                self.save_to_db_period = value as? Int
            }
            if key == "send_to_portal_period" {
                self.send_to_portal_period = value as? Int
            }
        }
    }
    
    public func setStatus(_ status: String) {
        if self.status == nil {
            self.status = [String:Any]()
        }
        if let type = self.type {
            if type == SensorTypes.RELAY {
                self.status?["active"] = status == "0" ? false : true
            } else if type == SensorTypes.TEMPERATURE {
                let parts = status.split(separator: "|")
                if parts.count>1 {
                    self.status?["temperature"] = parts[0]
                    self.status?["humidity"] = parts[1]
                }
            }
        }
    }
}
