//
//  SitesMapViewController.swift
//  Relayboard Mobile Client
//
//  Created by user on 17.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import MapKit

class SitesMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var relayboardsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        relayboardsTable.delegate = self
        relayboardsTable.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(initView), name: Notification.Name(rawValue:"INIT_COMPLETE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name(rawValue:"RELAYBOARDS_STATUS_UPDATED"), object: nil)
        
        let settingsBtn = UIBarButtonItem()
        settingsBtn.target = self
        settingsBtn.title = "Settings"
        settingsBtn.action = #selector(self.showSettings)
        self.navigationItem.rightBarButtonItem = settingsBtn
        self.initView()
    }

    @objc func showSettings() {
        self.performSegue(withIdentifier: "portalConnectionSettingsSegue", sender: self)
    }
    
    // Add data to map and to table after it loaded from portal server
    @objc func initView() {
        if let relayboards = RelayboardApplication.shared.relayboards {
            var coordinatesArray = [CLLocationCoordinate2D]()
            for (_,board) in relayboards {
                    mapView.addAnnotation(board)
                    coordinatesArray.append(board.coordinate)
                
            }
            let center = UIUtils.getCenterOfPins(pins: coordinatesArray)
            mapView.setCenter(center, animated: true)
        }
        relayboardsTable.reloadData()
    }
    
    @objc func refreshView() {
        relayboardsTable.reloadData()
    }
}

extension SitesMapViewController: MKMapViewDelegate {
    
    // When user selects pin on map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // redraw table, using info about currently selected pin
        relayboardsTable.reloadData()
    }
}

extension SitesMapViewController: UITableViewDelegate, UITableViewDataSource {
    // Set number of items in section of Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let relayboards = RelayboardApplication.shared.relayboards {
            // it equals to number of discovered relayboards
            return relayboards.values.count
        } else {
            return 0
        }
    }
    
    // Set number of sections in a Table
    func numberOfSections(in tableView: UITableView) -> Int {
        // Just one section for now
        return 1
    }
    
    // Init row cells of table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell template
        let cell = tableView.dequeueReusableCell(withIdentifier: "RelayboardCell", for: indexPath) as! RelayboardTableViewCell
        
        // Get relayboard with the same index as index of current cell
        if let relayboard = RelayboardApplication.shared.getRelayboardByIndex(indexPath.row) {
            // Fill options for label and button inside cell
            cell.label.isHidden = false
            cell.button.isHidden = false
            cell.relayboard = relayboard
            cell.viewController = self
            if let title = relayboard.title {
                cell.label.text = title
            }
           cell.backgroundColor = UIColor.white
            // Set background of cell, depending on selected relayboard on map
            if mapView.selectedAnnotations.count>0 {
                for annotation in mapView.selectedAnnotations {
                    if let annotated_relayboard = annotation as? Relayboard {
                        if annotated_relayboard.id == relayboard.id {
                            cell.backgroundColor = UIColor.lightGray
                        }
                    }
                }
            }
        } else {
            // if no relayboards (data still did not load from server, hide content of cell)
            cell.label.isHidden = true
            cell.button.isHidden = true
        }
        return cell
    }
    
    // Respond to cell highlight event
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let relayboard = RelayboardApplication.shared.getRelayboardByIndex(indexPath.row) {
            // Select Pin of corresponding relayboard on map
            mapView.selectAnnotation(relayboard, animated: true)
            // Move map center to a center of selected pin
            mapView.setCenter(relayboard.coordinate, animated: true)
        }
    }
}
