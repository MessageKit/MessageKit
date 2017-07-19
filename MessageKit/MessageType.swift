//
//  MessageType.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation

// MARK: - MessageType

public protocol MessageType {

    var sender: Sender { get }

    var messageId: String { get }

    var sentDate: Date { get }

    var messageData: MessageData { get }

}
