//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://messagekit.github.io
//
//
//  GitHub
//  https://github.com/MessageKit/MessageKit
//
//
//  License
//  Copyright (c) 2016-present Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit


public struct MessageBubble {

    public let image: UIImage

    public let highlightedImage: UIImage

    public func image(highlighted: Bool) -> UIImage {
        return highlighted ? image : highlightedImage
    }
}


public struct Avatar {

    public let image: UIImage?

    public let highlightedImage: UIImage?

    public let placeholderImage: UIImage

    public init(image: UIImage? = nil, highlightedImage: UIImage? = nil, placeholderImage: UIImage) {
        self.image = image
        self.highlightedImage = highlightedImage
        self.placeholderImage = placeholderImage
    }

    public func image(highlighted: Bool) -> UIImage {
        guard let image = image else {
            return placeholderImage
        }

        guard let highlightedImage = highlightedImage else {
            return image
        }

        return highlighted ? image : highlightedImage
    }
}


public protocol MessagesDataSource {

    var currentSender: Sender { get }

    func messageForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> MessageType
}


extension MessagesDataSource {

    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender == currentSender
    }
}


public protocol MessagesDisplayDataSource {

    func bubbleForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> MessageBubble

    func avatarForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> Avatar
}
