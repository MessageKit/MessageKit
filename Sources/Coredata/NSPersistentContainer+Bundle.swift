//
//  NSPersistentContainer+Bundle.swift
//  MessageKit
//
//  Created by Gumdal, Raj Pawan on 20/03/19.
//

import Foundation
import CoreData

// https://gist.github.com/brennanMKE/45c2e809960b1715b29d83e560be8029
extension NSPersistentContainer {
    
    public convenience init(name: String, bundle: Bundle) {
        guard let modelURL = bundle.url(forResource: name, withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: modelURL)
            else {
                fatalError("Unable to located Core Data model")
        }
        
        self.init(name: name, managedObjectModel: mom)
    }
    
}
