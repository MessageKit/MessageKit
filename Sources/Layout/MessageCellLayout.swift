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

import UIKit

open class CellSizeCalculator {

    open weak var layout: UICollectionViewFlowLayout?

    public init(layout: UICollectionViewFlowLayout? = nil) {
        self.layout = layout
    }

    open func configure(attributes: UICollectionViewLayoutAttributes) {
        // No-op default
    }

    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return .zero
    }

}

open class MessageSizeCalculator: CellSizeCalculator {

    public var incomingAvatarSize = CGSize(width: 30, height: 30)
    public var outgoingAvatarSize = CGSize(width: 30, height: 30)

    public var incomingAvatarPosition = AvatarPosition(vertical: .messageBottom)
    public var outgoingAvatarPosition = AvatarPosition(vertical: .messageBottom)

    public var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    public var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)

    public var incomingCellTopLabelAlignment = LabelAlignment.messageLeading(.zero)
    public var outgoingCellTopLabelAlignment = LabelAlignment.messageTrailing(.zero)

    public var incomingCellBottomLabelAlignment = LabelAlignment.messageTrailing(.zero)
    public var outgoingCellBottomLabelAlignment = LabelAlignment.messageLeading(.zero)

    internal var messagesLayout: MessagesCollectionViewFlowLayout {
        guard let layout = layout as? MessagesCollectionViewFlowLayout else {
            fatalError("Layout object is missing or is not a MessagesCollectionViewFlowLayout")
        }
        return layout
    }

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

    internal func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

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

    internal func avatarPosition(for message: MessageType) -> AvatarPosition {
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

    internal func avatarSize(for message: MessageType) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAvatarSize : incomingAvatarSize
    }

    // MARK: - Top Label

    internal func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let text = dataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        guard let topLabelText = text else { return .zero }
        let maxWidth = cellTopLabelMaxWidth(for: message)
        return labelSize(for: topLabelText, considering: maxWidth)
    }

    internal func cellTopLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellTopLabelAlignment : incomingCellTopLabelAlignment
    }

    internal func cellTopLabelMaxWidth(for message: MessageType) -> CGFloat {
        let alignment = cellTopLabelAlignment(for: message)
        let position = avatarPosition(for: message)
        let avatarWidth = avatarSize(for: message).width
        let containerSize = messageContainerSize(for: message)
        let messagePadding = messageContainerPadding(for: message)

        let avatarHorizontal = position.horizontal
        let avatarVertical = position.vertical

        let itemWidth = messagesLayout.itemWidth

        switch (alignment, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellTop ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellTop ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = containerSize.width + messagePadding.left - alignment.insets.horizontal
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = containerSize.width + messagePadding.right - alignment.insets.horizontal
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - messagePadding.left - alignment.insets.horizontal

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - messagePadding.right - alignment.insets.horizontal

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
    }

    // MARK: - Bottom Label

    open func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let text = dataSource.cellBottomLabelAttributedText(for: message, at: indexPath)
        guard let bottomLabelText = text else { return .zero }
        let maxWidth = cellBottomLabelMaxWidth(for: message)
        return labelSize(for: bottomLabelText, considering: maxWidth)
    }

    internal func cellBottomLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellBottomLabelAlignment : incomingCellBottomLabelAlignment
    }

    internal func cellBottomLabelMaxWidth(for message: MessageType) -> CGFloat {

        let alignment = cellBottomLabelAlignment(for: message)
        let avatarWidth = avatarSize(for: message).width
        let containerSize = messageContainerSize(for: message)
        let messagePadding = messageContainerPadding(for: message)
        let position = avatarPosition(for: message)

        let avatarHorizontal = position.horizontal
        let avatarVertical = position.vertical

        let itemWidth = messagesLayout.itemWidth

        switch (alignment, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellBottom ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellBottom ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = containerSize.width + messagePadding.left - alignment.insets.horizontal
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = containerSize.width + messagePadding.right - alignment.insets.horizontal
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - messagePadding.left - alignment.insets.horizontal

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - messagePadding.right - alignment.insets.horizontal

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
    }

    // MARK: - MessageContainer

    internal func messageContainerPadding(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessagePadding : incomingMessagePadding
    }

    open func messageContainerSize(for message: MessageType) -> CGSize {
        // Returns .zero by default
        return .zero
    }

    internal func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let avatarWidth = avatarSize(for: message).width
        let messagePadding = messageContainerPadding(for: message)
        return messagesLayout.itemWidth - avatarWidth - messagePadding.horizontal
    }

    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let estimatedHeight = attributedText.height(considering: maxWidth)
        let estimatedWidth = attributedText.width(considering: estimatedHeight)

        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

        return CGSize(width: finalWidth, height: finalHeight)
    }
}

open class TextMessageSizeCalculator: MessageSizeCalculator {

    public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18)

    public var messageLabelFont = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)
        }
    }

    internal var emojiLabelFont: UIFont

    public init() {
        emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)
    }

    internal func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }

    internal override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message)
        let textInsets = messageLabelInsets(for: message)
        return maxWidth - textInsets.horizontal
    }

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)

        var messageContainerSize: CGSize
        let attributedText: NSAttributedString

        switch message.data {
        case .text(let text):
            attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
        case .attributedText(let text):
            attributedText = text
        case .emoji(let text):
            attributedText = NSAttributedString(string: text, attributes: [.font: emojiLabelFont])
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.data)")
        }

        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)

        let messageInsets = messageLabelInsets(for: message)
        messageContainerSize.width += messageInsets.horizontal
        messageContainerSize.height += messageInsets.vertical

        return messageContainerSize
    }

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }

        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)

        attributes.messageLabelInsets = messageLabelInsets(for: message)
        attributes.messageLabelFont = messageLabelFont

        switch message.data {
        case .attributedText(let text):
            guard !text.string.isEmpty else { return }
            guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
            attributes.messageLabelFont = font
        case .emoji:
            attributes.messageLabelFont = emojiLabelFont
        default:
            break
        }
    }
}

open class MediaMessageSizeCalculator: MessageSizeCalculator {

    // TODO: - Figure out how we are going to size these
    public var incomingMediaSize: CGSize = .zero
    public var outgoingMediaSize: CGSize = .zero

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        switch message.data {
        case .photo(_):
            // TODO: - Implement actual sizing
            return CGSize(width: maxWidth, height: 240)
        case .video(_, _):
            // TODO: - Implement actual sizing
            return CGSize(width: maxWidth, height: 240)
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.data)")
        }
    }
}

open class LocationMessageSizeCalculator: MessageSizeCalculator {

    // TODO: - Figure out how we are going to size these
    public var incomingLocationSize: CGSize = .zero
    public var outgoingLocationSize: CGSize = .zero

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        switch message.data {
        case .location(_):
            // TODO: - Implement actual sizing
            return CGSize(width: maxWidth, height: 240)
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.data)")
        }
    }
}