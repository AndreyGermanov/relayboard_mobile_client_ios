//
//  TemperatureSensorTableViewCell.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 19.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// Custom view for a cell of "Temperature and Humidity" sensor for a table on "Relayboard" screen

import UIKit

class TemperatureSensorTableViewCell: SensorTableViewCell {

    // Label with title of sensor
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // Label with current temperature data from sensor
    @IBOutlet weak var humidityLabel: UILabel!
    
    // Label with current humidity data from sensor
    @IBOutlet weak var titleLabel: UILabel!
}
