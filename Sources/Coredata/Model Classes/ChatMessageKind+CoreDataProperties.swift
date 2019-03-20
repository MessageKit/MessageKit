//
//  ChatMessageKind+CoreDataProperties.swift
//  MessageKit
//
//  Created by Gumdal, Raj Pawan on 14/03/19.
//  Copyright © 2019 Gumdal, Raj Pawan. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatMessageKind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessageKind> {
        return NSFetchRequest<ChatMessageKind>(entityName: "ChatMessageKind")
    }

    @NSManaged public var text: String?

}
