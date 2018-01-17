//
//  UIUtils.swift
//  Relayboard Mobile Client
//
//  Created by user on 14.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import MapKit

class UIUtils: NSObject {
    static func findControlByTag(controls: [UIControl], tag: Int) -> UIControl? {
        for control in controls {
            if control.tag == tag {
                return control
            }
        }
        return nil
    }
    
    static func getCenterOfPins(pins:[CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        func rad2degr(_ rad: Double) -> Double {
            return rad*180/Double.pi
        }
        func degr2rad(_ degr: Double) -> Double {
            return degr * Double.pi/180
        }
        
        var result = CLLocationCoordinate2D()
        var sumX=0.0,sumY=0.0,sumZ=0.0
        
        for coordinate in pins {
            let lat = degr2rad(coordinate.latitude)
            let lng = degr2rad(coordinate.longitude)
            sumX = sumX + cos(lat) * cos(lng)
            sumY = sumY + cos(lat) * sin(lng)
            sumZ = sumZ + sin(lat)
        }
        
        let avgX = sumX / Double(pins.count)
        let avgY = sumY / Double(pins.count)
        let avgZ = sumZ / Double(pins.count)
        
        let lng = atan2(avgY,avgX)
        let hyp = sqrt(pow(avgX,2.0)+pow(avgY,2.0))
        let lat = atan2(avgZ,hyp)
        
        result.latitude = rad2degr(lat)
        result.longitude = rad2degr(lng)
        
        return result
    }
}
