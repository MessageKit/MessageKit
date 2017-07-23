//
//  MessageContainerSizeCalculator.swift
//  MessageKit
//
//  Created by Steven on 7/23/17.
//  Copyright © 2017 Hexed Bits. All rights reserved.
//

import Foundation

class MessageContainerSizeCalculator {

    func messageContainerSizeFor(messageType: MessageType, with layout: MessagesCollectionViewFlowLayout) -> CGSize {
        
        let avatarWidth = layout.avatarSizeCalculator.avatarSizeFor(messageType: messageType, with: layout).width
        let horizontalOffsets = layout.avatarToEdgePadding + layout.avatarToContainerPadding + layout.messageLeftRightPadding
        let messageContainerWidth = layout.itemWidth - avatarWidth - horizontalOffsets
        
        switch messageType.data {
        case .text(let text):
            let messageContainerHeight = text.height(considering: messageContainerWidth, font: layout.messageFont)
            return CGSize(width: messageContainerWidth, height: messageContainerHeight)
        default:
            // TODO: Heights for other types of message data
            fatalError("Currently .text(String) is the only supported message type")
        }
    }

}

fileprivate extension String {
    
    func height(considering width: CGFloat, font: UIFont) -> CGFloat {
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundRect = self.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundRect.height
    }
    
}
