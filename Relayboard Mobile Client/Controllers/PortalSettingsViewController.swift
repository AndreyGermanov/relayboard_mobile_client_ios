//
//  PortalSettingsViewController.swift
//  Relayboard Mobile Client
//
//  Created by user on 14.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import CoreData

class PortalSettingsViewController: UIViewController {

    @IBOutlet var settingsFields: [UITextField]!
    
    // Load portal connection settings from UserDefaults storage and set to input fields
    override func viewDidLoad() {
        super.viewDidLoad()
        for textField in settingsFields {
            switch textField.tag {
            case 1:
                if let host = UserDefaults.standard.object(forKey: "host") as? String {
                    textField.text = host
                }
            case 2:
                if let port = UserDefaults.standard.object(forKey: "port") as? String {
                    textField.text = port
                }
                
            case 3:
                if let login = UserDefaults.standard.object(forKey: "login") as? String {
                    textField.text = login
                }
            case 4:
                if let password = UserDefaults.standard.object(forKey: "password") as? String {
                    textField.text = password
                }
            default:
                break
            }
        }
    }

    // When user presses "Save" button, this handler saves  portal connection settings from input fields
    // to UserDefaults storage after validation of data
    @IBAction func saveBtnClick(_ sender: Any) {
        var inputHost = ""
        var inputPort = ""
        var inputLogin = ""
        var inputPassword = ""
        var validationErrors = [String]()
        
        // Fetch and validate input
        for textField in settingsFields {
            switch textField.tag {
                case 1:
                    if (textField.text!.count>0) {
                        textField.backgroundColor = UIColor.white
                        textField.alpha = 1.0
                        inputHost = textField.text!
                    } else {
                        textField.backgroundColor = UIColor.red
                        textField.alpha = 0.5
                        validationErrors.append("Host is required")
                    }
                
                case 2:
                    if let val = textField.text {
                        inputPort = val
                    } else {
                        validationErrors.append("Port is required")
                }
                case 3:
                    if (textField.text!.count>0) {
                        inputLogin = textField.text!
                    } else {
                        validationErrors.append("Login is required")
                    }
                case 4:
                    inputPassword = textField.text!
                default:
                    break
            }
        }

        // If no validation errors, store fetched values to UserDefaults storage
        if (validationErrors.count==0) {
            UserDefaults.standard.set(inputHost,forKey:"host")
            UserDefaults.standard.set(inputPort,forKey:"port")
            UserDefaults.standard.set(inputLogin,forKey:"login")
            UserDefaults.standard.set(inputPassword,forKey:"password")
        }

    }
 
}
