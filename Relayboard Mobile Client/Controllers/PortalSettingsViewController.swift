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
    var activeTextField: UITextField?
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
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveBtnClick))
        self.navigationItem.rightBarButtonItem = saveButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func saveSettings() -> Bool {
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
            return true
        } else {
            return false
        }
    }
    
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

extension PortalSettingsViewController: UITextFieldDelegate {
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("BEGIN EDIT")
        self.activeTextField = textField
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        print("KEYBOARD APPEARED")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            let input_field_origin = activeTextField!.convert(activeTextField!.frame.origin, to: self.view)
            if self.view.frame.height-keyboardSize.height-(self.navigationController?.navigationBar.frame.height)!<(input_field_origin.y+activeTextField!.frame.height) {
                self.view.frame.origin.y = self.view.frame.origin.y -
                    activeTextField!.frame.origin.y
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
}
