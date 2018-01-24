//
//  Relayboard.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 13.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// Data model which contain information about Relayboard entity and it current status.
// Also has one-to-many relationship with Sensor model

import MapKit

public class Relayboard: NSObject, MKAnnotation {
    
    // Latitude and Longitude of place, in which this relayboard installed
    public var coordinate: CLLocationCoordinate2D
    
    // ID of relayboard
    public var id: String
    
    // title of relayboard
    public var title: String?
    
    // Serial port number of path
    public var port: String?
    
    // Serial port baudrate
    public var baudrate: Int?
    
    // Detail of data cache (how often to aggregate data in cache)
    public var data_cache_granularity: Int?
    
    // How often to save data from sensors to database (seconds)
    public var db_save_period: Int?
    
    // Array of sensor pointers
    public var sensors: [Sensor]?
    
    // Current status of relayboard
    public var status: (connected: Bool, online: Bool, timestamp: Int) = (connected: false, online: false, timestamp: 0)
    
    // Class constructor. Initializes relayboard with provided ID and title
    init(_ id: String, title: String?) {
        self.id = id
        self.coordinate = CLLocationCoordinate2D()
        if title  != nil {
            self.title = title
        } else {
            self.title = id
        }
    }
    
    // Fills all fields of model using provided data dictionary. Also create Sensor objects for each sensor data row in
    // dictionary
    public func setConfig(_ config: Dictionary<String,AnyObject>) {
        for (key,value) in config {

            if key == "port" {
                if let port = value as? String {
                    self.port = port
                }
            }
            if key == "baudrate" {
                if let baudrate = value as? Int {
                    self.baudrate = baudrate
                }
            }
            if key == "data_cache_granularity" {
                if let data_cache_granularity = value as? Int {
                    self.data_cache_granularity = data_cache_granularity
                }
            }
            if key == "db_save_period" {
                if let db_save_period = value as? Int {
                    self.db_save_period = db_save_period
                }
            }

            if key == "lat" {
                if let lat = value as? CLLocationDegrees {
                    self.coordinate.latitude = lat
                }
            }
            if key == "lng" {
                if let lng = value as? CLLocationDegrees {
                    self.coordinate.longitude = lng
                }
            }
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
    
    // Fills current status information, returned from portal and fires "RELAYBOARDS_STATUS_UPDATED" notification,
    // which allows to all listeners to update UI with new data
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
    
    // Utility function whic returns sensor index by provided UID
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
