//
//  RelayboardTableViewCell.swift
//  Relayboard Mobile Client
//
//  Created by user on 18.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit

class RelayboardTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var relayboard: Relayboard?
    
    var isOnline: Bool = false
    var viewController: SitesMapViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func viewRelayboard(_ sender: Any) {
        if let relayboard = self.relayboard {
            RelayboardApplication.shared.selectedRelayboard = relayboard
            viewController?.performSegue(withIdentifier: "relayViewSegue", sender: self.viewController)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
