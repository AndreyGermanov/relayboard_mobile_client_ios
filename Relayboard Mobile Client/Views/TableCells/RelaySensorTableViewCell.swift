//
//  RelaySensorTableViewCell.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 19.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// Custom view for Sensor of type "Relay" in table on "Relayboard" screen

import UIKit

class RelaySensorTableViewCell: SensorTableViewCell {

    // Relay button, used to turn relay on or off
    @IBOutlet weak var relayButton: UIButton!
    
    // Action, which used to turn relay on or off
    @IBAction func relayButtonClick(_ sender: UIButton) {
        
    }
}
