//
//  ChatMessage+CoreDataProperties.swift
//  MessageKit
//
//  Created by Gumdal, Raj Pawan on 14/03/19.
//  Copyright © 2019 Gumdal, Raj Pawan. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessage> {
        return NSFetchRequest<ChatMessage>(entityName: "ChatMessage")
    }

    @NSManaged public var chatMessageID: String?
    @NSManaged public var chatMessageSentDate: NSDate?
    @NSManaged public var chatMessageKind: ChatMessageKind?
    @NSManaged public var chatMessageSender: ChatSender?
}
