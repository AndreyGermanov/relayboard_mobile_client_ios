//
//  Relayboard.swift
//  Relayboard Mobile Client
//
//  Created by user on 13.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import MapKit

public class Relayboard: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    
    
    public var id: String
    public var title: String?
    public var port: String?
    public var baudrate: Int?
    public var data_cache_granularity: Int?
    public var db_save_period: Int?
    public var sensors: [Sensor]?
    
    public var status: (connected: Bool, online: Bool, timestamp: Int) = (connected: false, online: false, timestamp: 0)
    
    init(_ id: String, title: String?) {
        self.id = id
        self.coordinate = CLLocationCoordinate2D()
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
        
        if let lat = config["lat"] as? CLLocationDegrees {
            self.coordinate.latitude = lat
        }
        if let lng = config["lng"] as? CLLocationDegrees {
            self.coordinate.longitude = lng
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
    
    public func setStatus(_ status: Dictionary<String,Any>) {
        if let connected = status["connected"] as? Int {
            self.status.connected = connected == 0 ? false : true
        }
        if let online = status["online"] as? Int {
            self.status.online = online == 0 ? false : true
        }
        if let timestamp = status["timestamp"] as? Int {
            self.status.timestamp = timestamp
        }
        if let sensor_status = status["status"] as? Dictionary<String,String> {
            for (key,value) in sensor_status {
                if let sensor = self.findSensorById(key) {
                    sensor.setStatus(value)
                }
            }
        }
        let notification = Notification.init(name: Notification.Name(rawValue: "RELAYBOARDS_STATUS_UPDATED"))
        NotificationCenter.default.post(notification)
    }
    
    public func findSensorById(_ id: String) -> Sensor? {
        var result: Sensor?
        if let sensors = self.sensors {
            for var sensor in sensors {
                if (sensor.id == id) {
                    result = sensor
                }
            }
        }
        return result
    }
    
}
