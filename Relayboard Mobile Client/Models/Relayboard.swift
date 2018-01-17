//
//  Relayboard.swift
//  Relayboard Mobile Client
//
//  Created by user on 13.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import MapKit

public class Relayboard: NSObject {
    
    public var id: String
    public var title: String?
    public var location: CLLocationCoordinate2D?
    public var port: String?
    public var baudrate: Int?
    public var data_cache_granularity: Int?
    public var db_save_period: Int?
    public var sensors: [Sensor]?
    
    init(_ id: String, title: String?) {
        self.id = id
        if title  != nil {
            self.title = title
        } else {
            self.title = id
        }
    }
    
    public func setConfig(_ config: Dictionary<String,AnyObject>) {

        if let port = config["port"] as? String {
            self.port = port
        }
        if let baudrate = config["baudrate"] as? Int {
            self.baudrate = baudrate
        }
        if let data_cache_granularity = config["data_cache_granularity"] as? Int {
            self.data_cache_granularity = data_cache_granularity
        }
        if let db_save_period = config["db_save_period"] as? Int {
            self.db_save_period = db_save_period
        }
        self.location = CLLocationCoordinate2D()

        if let lat = config["lat"] as? CLLocationDegrees {
            self.location?.latitude = lat
        }
        if let lng = config["lng"] as? CLLocationDegrees {
            self.location?.longitude = lng
        }
        if let sensorsObj = config["pins"] as? NSArray {
            self.sensors = []
            
            for sensorData in sensorsObj {
                if let sensorDictionary = sensorData as? [String:Any] {
                    for (key,value) in sensorDictionary {
                        if key == "number" {
                            let number = String(describing: value)
                                let sensor = Sensor(number,relayboard:self)
                                sensor.setConfig(sensorDictionary)
                                self.sensors?.append(sensor)
                        }
                    }
                }
            }
        }
    }
}
