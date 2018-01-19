//
//  RelayboardViewController.swift
//  Relayboard Mobile Client
//
//  Created by user on 19.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit

class RelayboardViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            self.title = relayboard.title! + " - " + relayboard.id
        }
        tableView.reloadData()
    }
    
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

extension RelayboardViewController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            if let sensors = relayboard.sensors {
                result = sensors.count
            }
        }
        return result
    }
    
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
                                    tableCell.temperatureLabel.text = String(describing:status["temperature"]!)
                                    tableCell.humidityLabel.text = String(describing:status["humidity"]!)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var result = tableView.rowHeight
        if let relayboard = RelayboardApplication.shared.selectedRelayboard {
            if let sensors = relayboard.sensors {
                if indexPath.row < sensors.count {
                    let sensor = sensors[indexPath.row]
                    switch sensor.type! {
                    case SensorTypes.TEMPERATURE:
                        result = 71.0
                    default:
                        result = tableView.rowHeight
                    }
                }
            }
        }
        return result
    }
}
