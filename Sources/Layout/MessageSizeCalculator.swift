/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

open class MessageSizeCalculator: CellSizeCalculator {

    public init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        
        self.layout = layout
    }

    public var incomingAvatarSize = CGSize(width: 30, height: 30)
    public var outgoingAvatarSize = CGSize(width: 30, height: 30)

    public var incomingAvatarPosition = AvatarPosition(vertical: .messageBottom)
    public var outgoingAvatarPosition = AvatarPosition(vertical: .messageBottom)

    public var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    public var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)

    public var incomingCellTopLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
    public var outgoingCellTopLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

    public var incomingCellBottomLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
    public var outgoingCellBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }

        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)

        attributes.avatarSize = avatarSize(for: message)
        attributes.avatarPosition = avatarPosition(for: message)

        attributes.messageContainerPadding = messageContainerPadding(for: message)
        attributes.messageContainerSize = messageContainerSize(for: message)
        attributes.topLabelAlignment = cellTopLabelAlignment(for: message)
        attributes.topLabelSize = cellTopLabelSize(for: message, at: indexPath)

        attributes.bottomLabelAlignment = cellBottomLabelAlignment(for: message)
        attributes.bottomLabelSize = cellBottomLabelSize(for: message, at: indexPath)
    }

    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        let itemHeight = cellContentHeight(for: message, at: indexPath)
        return CGSize(width: messagesLayout.itemWidth, height: itemHeight)
    }

    open func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let avatarVerticalPosition = avatarPosition(for: message).vertical
        let avatarHeight = avatarSize(for: message).height
        let messageContainerHeight = messageContainerSize(for: message).height
        let bottomLabelHeight = cellBottomLabelSize(for: message, at: indexPath).height
        let topLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
        let messageVerticalPadding = messageContainerPadding(for: message).vertical

        var cellHeight: CGFloat = 0

        switch avatarVerticalPosition {
        case .cellTop:
            cellHeight += max(avatarHeight, topLabelHeight)
            cellHeight += bottomLabelHeight
            cellHeight += messageContainerHeight
            cellHeight += messageVerticalPadding
        case .cellBottom:
            cellHeight += max(avatarHeight, bottomLabelHeight)
            cellHeight += topLabelHeight
            cellHeight += messageContainerHeight
            cellHeight += messageVerticalPadding
        case .messageTop, .messageCenter, .messageBottom:
            cellHeight += max(avatarHeight, messageContainerHeight)
            cellHeight += messageVerticalPadding
            cellHeight += topLabelHeight
            cellHeight += bottomLabelHeight
        }

        return cellHeight
    }

    // MARK: - Avatar

    public func avatarPosition(for message: MessageType) -> AvatarPosition {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        var position = isFromCurrentSender ? outgoingAvatarPosition : incomingAvatarPosition

        switch position.horizontal {
        case .cellTrailing, .cellLeading:
            break
        case .natural:
            position.horizontal = isFromCurrentSender ? .cellTrailing : .cellLeading
        }
        return position
    }

    public func avatarSize(for message: MessageType) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAvatarSize : incomingAvatarSize
    }

    // MARK: - Top Label

    public func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let height = layoutDelegate.cellTopLabelHeight(for: message, at: indexPath, in: collectionView)
        return CGSize(width: messagesLayout.itemWidth, height: height)
    }

    public func cellTopLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellTopLabelAlignment : incomingCellTopLabelAlignment
    }

    // MARK: - Bottom Label

    public func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let height = layoutDelegate.cellBottomLabelHeight(for: message, at: indexPath, in: collectionView)
        return CGSize(width: messagesLayout.itemWidth, height: height)
    }

    public func cellBottomLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellBottomLabelAlignment : incomingCellBottomLabelAlignment
    }

    // MARK: - MessageContainer

    public func messageContainerPadding(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessagePadding : incomingMessagePadding
    }

    open func messageContainerSize(for message: MessageType) -> CGSize {
        // Returns .zero by default
        return .zero
    }

    open func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let avatarWidth = avatarSize(for: message).width
        let messagePadding = messageContainerPadding(for: message)
        return messagesLayout.itemWidth - avatarWidth - messagePadding.horizontal
    }

    // MARK: - Helpers

    public var messagesLayout: MessagesCollectionViewFlowLayout {
        guard let layout = layout as? MessagesCollectionViewFlowLayout else {
            fatalError("Layout object is missing or is not a MessagesCollectionViewFlowLayout")
        }
        return layout
    }

    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let estimatedHeight = attributedText.height(considering: maxWidth)
        let estimatedWidth = attributedText.width(considering: estimatedHeight)

        let finalHeight = ceil(estimatedHeight)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : ceil(estimatedWidth)

        return CGSize(width: finalWidth, height: finalHeight)
    }
}

fileprivate extension UIEdgeInsets {
    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}
