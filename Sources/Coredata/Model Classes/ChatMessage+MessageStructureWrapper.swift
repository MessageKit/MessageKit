//
//  ChatMessage+MessageStructureWrapper.swift
//  MessageKit
//
//  Created by Gumdal, Raj Pawan on 15/03/19.
//  Copyright © 2019 Gumdal, Raj Pawan. All rights reserved.
//

import Foundation
import MessageKit

extension ChatMessage : MessageType{
    public var sender: Sender {
        get {
            var aSender:Sender? = nil
            if ((chatMessageSender) != nil) {
                aSender = chatMessageSender?.sender
            }
            return aSender!
        }
    }
    public var messageId: String {
        get {
            return chatMessageID!
        }
    }
    
    public var sentDate: Date {
        get {
            return chatMessageSentDate! as Date
        }
    }
    
    public var kind: MessageKind {
        get {
            return (chatMessageKind?.kind)!
        }
    }
    
    /*var chatMessageType: MessageType {
        get {
//            return Sender(id: self.senderID!, displayName: self.displayName!)
            let messType:MessageType = MessageType
            messType.kind = self.kind
            messType.sender = sender
            self.messageId = messageId
            self.sentDate = date

            return MessageType
        }
        set {
            self.senderID = newValue.id
            self.displayName = newValue.displayName
        }
    }*/
}

