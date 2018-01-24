//
//  Sensor.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 13.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// Data model which contains information about sensor and it current status

import UIKit

// Possible sensor types
public enum SensorTypes {
    case RELAY
    case TEMPERATURE
    case WATER_PUMP
}

public class Sensor: NSObject {
    
    // ID of sensor
    public var id: String
    // Type of sensor
    public var type: SensorTypes?
    // Title of sensor
    public var title: String?
    // How often to send updated data values from portal (seconds)
    public var send_live_data: Bool?
    // How often to save data values to databases (seconds)
    public var save_to_db_period: Int?
    //How often to send data to portal for saving in portal database (seconds)
    public var send_to_portal_period: Int?
    // Link to parent relayboard object
    public var relayboard: Relayboard
    // Dictionary with last data values, read from sensor (current status)
    public var status: [String:Any]?
    
    // Class constructor. Initiates sensor with provided ID inside provided relayboard
    init(_ id: String, relayboard: Relayboard) {
        self.id = id
        self.relayboard = relayboard
    }
    
    // Fills all data about sensor from provided dictionary
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
    
    // Fills current status sensor from provided dictionary, depending on sensor type
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
