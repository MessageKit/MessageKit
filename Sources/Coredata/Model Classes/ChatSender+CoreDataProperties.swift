//
//  ChatSender+CoreDataProperties.swift
//  MessageKit
//
//  Created by Gumdal, Raj Pawan on 14/03/19.
//  Copyright © 2019 Gumdal, Raj Pawan. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatSender {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatSender> {
        return NSFetchRequest<ChatSender>(entityName: "ChatSender")
    }

    @NSManaged public var senderID: String?
    @NSManaged public var displayName: String?

}
