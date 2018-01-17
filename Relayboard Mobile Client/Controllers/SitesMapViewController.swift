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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(initMap), name: Notification.Name(rawValue:"INIT_COMPLETE"), object: nil)
    }

    @objc func initMap() {
        if let relayboards = RelayboardApplication.shared.relayboards {
            var coordinatesArray = [CLLocationCoordinate2D]()
            for (_,board) in relayboards {
                if let location = board.location {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = board.title
                    annotation.subtitle = board.title
                    mapView.addAnnotation(annotation)
                    coordinatesArray.append(location)
                }
            }
            let center = UIUtils.getCenterOfPins(pins: coordinatesArray)
            //print(center);
            //let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            //let region = MKCoordinateRegion(center: center, span: span)
            mapView.setCenter(center, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
