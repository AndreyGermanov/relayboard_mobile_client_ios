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
        if let lat = config["lat"] as? CLLocationDegrees {
            self.location?.latitude = lat
        }
        if let lng = config["lng"] as? CLLocationDegrees {
            self.location?.longitude = lng
        }
        if let sensors = config["pins"] as? NSArray {
            self.sensors = []
            for sensorData in sensors {
                if let sensorDictionary = sensorData as? Dictionary<String,String> {
                    if let number = sensorDictionary["number"] as String? {
                        print(number)
                        let sensor = Sensor(number,relayboard: self)
                        sensor.setConfig(sensorDictionary as AnyObject)
                        self.sensors?.append(sensor)
                    }
                }
            }
        }
        print("INITIALIZED RELAYBOARD "+self.id)
        print("TItle: \(self.title!)")
        if (self.location != nil) {
            print("Location: \(self.location!.latitude),\(self.location!.longitude)")
        }
        print("Port: \(self.port)")
        print("Baud rate: \(self.baudrate)")
        print("Data cache granularity: \(self.data_cache_granularity)")
        print("DB save period: \(self.db_save_period)")
    }
    
}
