//
//  AvatarSizeCalculator.swift
//  MessageKit
//
//  Created by Steven on 7/23/17.
//  Copyright © 2017 Hexed Bits. All rights reserved.
//

import Foundation

class AvatarSizeCalculator {

    func avatarSizeFor(messageType: MessageType, with layout: MessagesCollectionViewFlowLayout) -> CGSize {

        guard let messagesCollectionView = layout.collectionView as? MessagesCollectionView else { return .zero }
        guard let isOutgoingMessage = messagesCollectionView.messagesDataSource?.isFromCurrentSender(message: messageType) else { return .zero }
        
        return isOutgoingMessage ? layout.outgoingAvatarSize : layout.incomingAvatarSize

    }

}
