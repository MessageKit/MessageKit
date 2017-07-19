//
//  MessagesDataSource.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation

// MARK: - MessagesDataSource

public protocol MessagesDataSource {
    
    var currentSender: Sender { get }
    
    func messageForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> MessageType
}

// MARK: - MessagesDataSource Default

extension MessagesDataSource {
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender == currentSender
    }
}
