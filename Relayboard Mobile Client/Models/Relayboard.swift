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
    public var location: MKMapPoint?
    public var sensors: [Sensor]?
    
    init(_ id: String, title: String?) {
        self.id = id
        if title  != nil {
            self.title = title
        } else {
            self.title = id
        }
    }
}
