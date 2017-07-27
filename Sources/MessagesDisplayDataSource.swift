//
//  MessagesDisplayDataSource.swift
//  MessageKit
//
//  Created by Steven on 7/26/17.
//  Copyright © 2017 Hexed Bits. All rights reserved.
//

import Foundation

// I don't want this to inherit from MessagesDataSource really but I need access to isFromCurrentSender(message:) for now
public protocol MessagesDisplayDataSource: class, MessagesDataSource {
    
    func avatarForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> Avatar
    
}

public extension MessagesDisplayDataSource {
    
    func messageColorFor(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .outgoingGreen : .incomingGray
    }
    
}
