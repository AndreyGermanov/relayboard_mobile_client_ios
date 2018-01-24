//
//  RelayboardViewController.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 19.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// View controller for Relay Sensors Screen

import UIKit

class RelayboardViewController: UIViewController {

    // Outlet for navigation bar
    @IBOutlet weak var navBar: UINavigationBar!
    
    // Outlet for table
    @IBOutlet weak var tableView: UITableView!
    
    // Outlet for label with last status update timestamp
    @IBOutlet weak var timestampLabel: UILabel!
    
    // Runs when screen appears for the first time. Setup required observers, delegates and fills selected relayboard data
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            self.title = relayboard.title! + " - " + relayboard.id
        }
        timestampLabel.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name(rawValue:"RELAYBOARDS_STATUS_UPDATED"), object: nil)
    }
    
    // Runs every time when screen appears. Update data in header and in table with newest data of selected relayboard
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            self.title = relayboard.title! + " - " + relayboard.id
        }
        tableView.reloadData()
    }
    
    // Handler of "RELAYBOARDS_STATUS_UPDATE" notification. Updated status timestamp and information about sensors in the table
    @objc func refreshView() {
        
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            if (relayboard.status.timestamp > 0) {
                let date = Date(timeIntervalSince1970: Double(relayboard.status.timestamp))
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
                timestampLabel.text = formatter.string(from: date)
            } else {
                timestampLabel.text = ""
            }
        }
        tableView.reloadData()
    }

}

// MARK: Table View event handlers

extension RelayboardViewController : UITableViewDelegate, UITableViewDataSource {

    // Setup number of rows in section of table. It equals to a count of sensors of current relayboard
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            if let sensors = relayboard.sensors {
                result = sensors.count
            }
        }
        return result
    }
    
    // Table cell display handler. Fills a cell with information about sensor, depending on it type and returns
    // cell object
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SensorTableViewCell()
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            if let sensors = relayboard.sensors {
                if indexPath.row < sensors.count  {
                    let sensor = sensors[indexPath.row]
                    cell.sensor = sensor
                    switch sensor.type! {
                    case SensorTypes.TEMPERATURE:
                            if let tableCell = tableView.dequeueReusableCell(withIdentifier: "TemperatureTableViewCell", for: indexPath) as? TemperatureSensorTableViewCell {
                                tableCell.temperatureLabel.text = ""
                                tableCell.humidityLabel.text = ""
                                if let status = sensor.status {
                                    tableCell.temperatureLabel.text = String(describing:status["temperature"]!)+" °C"
                                    tableCell.humidityLabel.text = String(describing:status["humidity"]!)+" %"
                                }
                                tableCell.titleLabel.text = sensor.title
                                cell = tableCell
                            }
                    case SensorTypes.RELAY:
                        if let tableCell = tableView.dequeueReusableCell(withIdentifier: "RelayTableViewCell", for: indexPath) as? RelaySensorTableViewCell {
                            tableCell.relayButton.setTitle(sensor.title, for: .normal)
                            cell = tableCell
                        }
                    default: break
                    }
                }
            }
        }
        return cell
    }
    
    // Setup height of table row, depending on current sensor type
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var result = tableView.rowHeight
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            if let sensors = relayboard.sensors {
                if indexPath.row < sensors.count {
                    let sensor = sensors[indexPath.row]
                    switch sensor.type! {
                    case SensorTypes.TEMPERATURE:
                        result = 105.0
                    default:
                        result = tableView.rowHeight
                    }
                }
            }
        }
        return result
    }
}
