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
}
