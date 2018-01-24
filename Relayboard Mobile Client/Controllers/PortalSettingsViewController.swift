//
//  PortalSettingsViewController.swift
//  Relayboard Mobile Client
//
//  Created by Andrey Germanov on 14.01.2018.
//  Copyright © 2018 Andrey Germanov. All rights reserved.
//

// View controller for "Connection settings" screen

import UIKit
import CoreData

class PortalSettingsViewController: UIViewController {

    // Collection of outlets for connection settings fields: "host", "port", "login" and "password"
    @IBOutlet var settingsFields: [UITextField]!
    
    // Pointer to current focused field
    var activeTextField: UITextField?
    
    // Function starts when viewappears for the first time
    // It loads portal connection settings from UserDefaults storage and set to input fields,
    // also adds observers for keyboard show and hide events and event listener for "Save" button
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
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveBtnClick))
        self.navigationItem.rightBarButtonItem = saveButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Function used by other functions to validate and save connection settings to User Defaults
    func saveSettings() -> Bool {
        var inputHost = ""
        var inputPort = ""
        var inputLogin = ""
        var inputPassword = ""
        var validationErrors = [String]()
        
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
        
        if (validationErrors.count==0) {
            UserDefaults.standard.set(inputHost,forKey:"host")
            UserDefaults.standard.set(inputPort,forKey:"port")
            UserDefaults.standard.set(inputLogin,forKey:"login")
            UserDefaults.standard.set(inputPassword,forKey:"password")
            return true
        } else {
            return false
        }
    }

    // Function runs when user presses "Save and Reconnect" button. It first saves connection settings to User Defaults and then
    // moves to "Loading" screen, which tries to connect to portal using saved settings
    @IBAction func saveAndReconnectBtnClick(_ sender: Any) {
        if self.saveSettings() {
            self.navigationController?.popToRootViewController(animated:false)
            self.performSegue(withIdentifier: "settingsReconnectSegue", sender: self)
        }
    }
    
    // When user presses "Save" button, this handler saves  portal connection settings from input fields
    // to UserDefaults storage after validation of data
    @objc func saveBtnClick(_ sender: UIButton) {
        self.saveSettings()
    }
 
}

//MARK: Text fields delegate
extension PortalSettingsViewController: UITextFieldDelegate {
    
    // Function dismisses onscreen keyboard when user touches screen (out of text fields)
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Function dismisses onscreen keyboard when user presses "Return" button on it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Method fires when user focues input field. It sets active field parameter for future use
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        return true
    }
    
    // Method fire when onscreen keyboard begins to appear on screen. It calculates to which distance need to scroll
    // screen to make sure that onscreen keyboard not overlap active text field and scrolls screen to this position
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            let input_field_origin = activeTextField!.convert(activeTextField!.frame.origin, to: self.view)
            if self.view.frame.height-keyboardSize.height-(self.navigationController?.navigationBar.frame.height)!<(input_field_origin.y+activeTextField!.frame.height) {
                self.view.frame.origin.y = self.view.frame.origin.y -
                    activeTextField!.frame.origin.y
            }
        }
    }
    
    // Method fire when onscreen keyboard dismissed. It scrolls screen back to initial position
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
}
