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
        NotificationCenter.default.addObserver(self, selector: #selector(initMap), name: Notification.Name(rawValue:"INIT_COMPLETE"), object: nil)
    }

    @objc func initMap() {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SitesMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        relayboardsTable.reloadData()
    }
}

extension SitesMapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let relayboards = RelayboardApplication.shared.relayboards {
            return relayboards.values.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RelayboardCell", for: indexPath) as! RelayboardTableViewCell
        if let relayboard = RelayboardApplication.shared.getRelayboardByIndex(indexPath.row) {
            cell.label.isHidden = false
            cell.button.isHidden = false
            cell.relayboard = relayboard
            if let title = relayboard.title {
                cell.label.text = title
            }
           cell.backgroundColor = UIColor.white
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
            cell.label.isHidden = true
            cell.button.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let relayboard = RelayboardApplication.shared.getRelayboardByIndex(indexPath.row) {
            mapView.selectAnnotation(relayboard, animated: true)
            mapView.setCenter(relayboard.coordinate, animated: true)
        }
    }
}
