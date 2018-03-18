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

// MARK: - Open

extension MessagesCollectionViewFlowLayout {

    /// Returns the insets of the `MessageLabel` in a `TextMessageCell` for
    /// the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method retrieves its value from
    ///         `messageLabelInset(for:at:in)` in `MessagesLayoutDelegate`.
    open func messageLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        return messagesLayoutDelegate.messageLabelInset(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// Returns the padding around the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method retrieves its value from
    ///         `messagePadding(for:at:in)` in `MessagesLayoutDelegate`.
    open func messageContainerPadding(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        return messagesLayoutDelegate.messagePadding(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// Returns the maximum width of the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let avatarWidth = _avatarSize(for: message, at: indexPath).width
        let messagePadding = _messageContainerPadding(for: message, at: indexPath)

        switch message.data {
        case .text, .attributedText:
            let messageInsets = _messageLabelInsets(for: message, at: indexPath)
            return itemWidth - avatarWidth - messagePadding.horizontal - messageInsets.horizontal
        default:
            return itemWidth - avatarWidth - messagePadding.horizontal
        }
    }

    /// Returns the size of the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let maxWidth = _messageContainerMaxWidth(for: message, at: indexPath)

        var messageContainerSize: CGSize = .zero

        switch message.data {
        case .text(let text):
            let messageLabelInsets = _messageLabelInsets(for: message, at: indexPath)
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: messageLabelFont)
            messageContainerSize.width += messageLabelInsets.horizontal
            messageContainerSize.height += messageLabelInsets.vertical
        case .attributedText(let text):
            let messageLabelInsets = _messageLabelInsets(for: message, at: indexPath)
            messageContainerSize = labelSize(for: text, considering: maxWidth)
            messageContainerSize.width += messageLabelInsets.horizontal
            messageContainerSize.height += messageLabelInsets.vertical
        case .emoji(let text):
            let messageLabelInsets = _messageLabelInsets(for: message, at: indexPath)
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: emojiLabelFont)
            messageContainerSize.width += messageLabelInsets.horizontal
            messageContainerSize.height += messageLabelInsets.vertical
        case .photo, .video:
            let width = messagesLayoutDelegate.widthForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .location:
            let width = messagesLayoutDelegate.widthForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .custom:
            fatalError(MessageKitError.customDataUnresolvedSize)
        }

        return messageContainerSize
    }
}

// MARK: - Internal

extension MessagesCollectionViewFlowLayout {

    internal func _messageLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let cachedInsets = currentLayoutContext.messageLabelInsets else {
            let insets = messageLabelInsets(for: message, at: indexPath)
            currentLayoutContext.messageLabelInsets = insets
            return insets
        }
        return cachedInsets
    }

    internal func _messageContainerPadding(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let cachedPadding = currentLayoutContext.messageContainerPadding else {
            let padding = messageContainerPadding(for: message, at: indexPath)
            currentLayoutContext.messageContainerPadding = padding
            return padding
        }
        return cachedPadding
    }

    internal func _messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        guard let cachedMaxWidth = currentLayoutContext.messageContainerMaxWidth else {
            let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
            currentLayoutContext.messageContainerMaxWidth = maxWidth
            return maxWidth
        }
        return cachedMaxWidth
    }

    internal func _messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        guard let cachedSize = currentLayoutContext.messageContainerSize else {
            let size = messageContainerSize(for: message, at: indexPath)
            currentLayoutContext.messageContainerSize = size
            return size
        }
        return cachedSize
    }
}
