//
//  MessagesDisplayDataSource.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation

// MARK: - MessagesDisplayDataSource

public protocol MessagesDisplayDataSource {
    
    func bubbleForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> MessageBubble
    
    func avatarForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> Avatar
}
