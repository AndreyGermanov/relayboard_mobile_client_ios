//
//  RelayboardTableViewCell.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 18.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// Custom view for a table cell of table on "Relayboards Map" list. Contains controls, related to each relayboard
// in this table

import UIKit

class RelayboardTableViewCell: UITableViewCell {

    // Label with title of relayboard
    @IBOutlet weak var label: UILabel!
    
    // "View" button
    @IBOutlet weak var button: UIButton!
    
    // Image shows eiter "Online" or "Offline" depending on relayboard status
    @IBOutlet weak var statusImageView: UIImageView!
    
    // Link to relayboard object, associated with this cell
    var relayboard: Relayboard?
    
    // Current status of relayboard (online/offline)
    var isOnline: Bool = false
    
    // Link to parent view controller
    var viewController: SitesMapViewController?
    
    // Handler for "View" button. Sets current relayboard as active relayboard and opens "Relayboard" screen
    @IBAction func viewRelayboard(_ sender: Any) {
        if let relayboard = self.relayboard {
            RelayboardApplication.shared.selectedRelayboard = relayboard
            viewController?.performSegue(withIdentifier: "relayViewSegue", sender: self.viewController)
        }
    }
}
