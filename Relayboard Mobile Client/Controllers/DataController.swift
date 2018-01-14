//
//  DataController.swift
//  Relayboard Mobile Client
//
//  Created by user on 14.01.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import CoreData
class DataController: NSObject {
    var persistentContainer: NSPersistentContainer?
    
    override init() {
        super.init()
    }
    
    func loadEngine(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "Relayboard_Mobile_Client")
        persistentContainer?.loadPersistentStores() { (description, error) in
            
           
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            print("Data Model loaded successfuly")
            completionClosure()
        }
    }
    
    
}
