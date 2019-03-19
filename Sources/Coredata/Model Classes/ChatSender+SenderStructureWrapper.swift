//
//  ChatSender+SenderStructureWrapper.swift
//  ConversationAI
//
//  Created by Gumdal, Raj Pawan on 14/03/19.
//  Copyright © 2019 Gumdal, Raj Pawan. All rights reserved.
//

import Foundation
import MessageKit

extension ChatSender {
    // From: https://stackoverflow.com/a/37877297/260665
    var sender: Sender {
        get {
            return Sender(id: self.senderID!, displayName: self.displayName!)
        }
        set {
            self.senderID = newValue.id
            self.displayName = newValue.displayName
        }
    }
}
