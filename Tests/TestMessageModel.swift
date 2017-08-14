//
//  TestMessageModel.swift
//  MessageKit
//
//  Created by Dan Leonard on 8/14/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation
struct TestMessage: MessageType {
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var data: MessageData
    
    init(text: String, sender: Sender, messageId: String) {
        data = .text(text)
        self.sender = sender
        self.messageId = messageId
        self.sentDate = Date()
    }
    
}
