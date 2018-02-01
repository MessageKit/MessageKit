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

    // Top Label

    /// Returns the `LabelAlignment` of the `MessageCollectionViewCell`'s top label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    /// - Note: The default implementation of this method retrieves its value from
    ///         `cellTopLabelAlignment(for:at:in)` in `MessagesLayoutDelegate`.
    open func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        return messagesLayoutDelegate.cellTopLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// Returns the size of the `MessageCollectionViewCell`'s top label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method sizes the label to fit.
    open func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let text = messagesDataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        guard let topLabelText = text else { return .zero }
        let maxWidth = _cellTopLabelMaxWidth(for: message, at: indexPath)
        return labelSize(for: topLabelText, considering: maxWidth)
    }

    /// Returns the maximum width of the `MessageCollectionViewCell`'s top label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func cellTopLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let labelAlignment = _cellTopLabelAlignment(for: message, at: indexPath)
        let avatarPosition = _avatarPosition(for: message, at: indexPath)
        let avatarWidth = _avatarSize(for: message, at: indexPath).width
        let messageContainerSize = _messageContainerSize(for: message, at: indexPath)
        let messagePadding = _messageContainerPadding(for: message, at: indexPath)

        let avatarHorizontal = avatarPosition.horizontal
        let avatarVertical = avatarPosition.vertical

        switch (labelAlignment, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - labelAlignment.insets.horizontal
            return avatarVertical != .cellTop ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - labelAlignment.insets.horizontal
            return avatarVertical != .cellTop ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = messageContainerSize.width + messagePadding.left - labelAlignment.insets.horizontal
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = messageContainerSize.width + messagePadding.right - labelAlignment.insets.horizontal
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - messagePadding.left - labelAlignment.insets.horizontal

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - messagePadding.right - labelAlignment.insets.horizontal

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
    }

    // Bottom Label

    /// Returns the `LabelAlignment` of the `MessageCollectionViewCell`'s bottom label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    /// - Note: The default implementation of this method retrieves its value from
    ///         `cellBottomLabelAlignment(for:at:in)` in `MessagesLayoutDelegate`.
    open func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        return messagesLayoutDelegate.cellBottomLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// Returns the size of the `MessageCollectionViewCell`'s bottom label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method sizes the label to fit.
    open func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let text = messagesDataSource.cellBottomLabelAttributedText(for: message, at: indexPath)
        guard let bottomLabelText = text else { return .zero }
        let maxWidth = _cellBottomLabelMaxWidth(for: message, at: indexPath)
        return labelSize(for: bottomLabelText, considering: maxWidth)
    }

    /// Returns the maximum width of the `MessageCollectionViewCell`'s bottom label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func cellBottomLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let labelAlignment = _cellBottomLabelAlignment(for: message, at: indexPath)
        let avatarWidth = _avatarSize(for: message, at: indexPath).width
        let messageContainerSize = _messageContainerSize(for: message, at: indexPath)
        let messagePadding = _messageContainerPadding(for: message, at: indexPath)
        let avatarPosition = _avatarPosition(for: message, at: indexPath)

        let avatarHorizontal = avatarPosition.horizontal
        let avatarVertical = avatarPosition.vertical

        switch (labelAlignment, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - labelAlignment.insets.horizontal
            return avatarVertical != .cellBottom ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - labelAlignment.insets.horizontal
            return avatarVertical != .cellBottom ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = messageContainerSize.width + messagePadding.left - labelAlignment.insets.horizontal
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = messageContainerSize.width + messagePadding.right - labelAlignment.insets.horizontal
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - messagePadding.left - labelAlignment.insets.horizontal

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - messagePadding.right - labelAlignment.insets.horizontal

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
    }
}

// MARK: - Internal

extension MessagesCollectionViewFlowLayout {

    // Top Label

    internal func _cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        return cellTopLabelAlignment(for: message, at: indexPath)
    }

    internal func _cellTopLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        return cellTopLabelMaxWidth(for: message, at: indexPath)
    }

    internal func _cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return cellTopLabelSize(for: message, at: indexPath)
    }

    // Bottom Label

    internal func _cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        return cellBottomLabelAlignment(for: message, at: indexPath)
    }

    internal func _cellBottomLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        return cellBottomLabelMaxWidth(for: message, at: indexPath)
    }

    internal func _cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return cellBottomLabelSize(for: message, at: indexPath)
    }
}

// MARK: - Helpers

extension MessagesCollectionViewFlowLayout {

    /// Returns the size required fit a NSAttributedString considering a constrained max width.
    ///
    /// - Parameters:
    ///   - attributedText: The `NSAttributedString` used to calculate a size that fits.
    ///   - maxWidth: The max width available for the label.
    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {

        let estimatedHeight = attributedText.height(considering: maxWidth)
        let estimatedWidth = attributedText.width(considering: estimatedHeight)

        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

        return CGSize(width: finalWidth, height: finalHeight)
    }

    /// Returns the size required to fit a String considering a constrained max width.
    ///
    /// - Parameters:
    ///   - text: The `String` used to calculate a size that fits.
    ///   - maxWidth: The max width available for the label.
    internal func labelSize(for text: String, considering maxWidth: CGFloat, and font: UIFont) -> CGSize {

        let estimatedHeight = text.height(considering: maxWidth, and: font)
        let estimatedWidth = text.width(considering: estimatedHeight, and: font)

        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

        return CGSize(width: finalWidth, height: finalHeight)
    }
}
