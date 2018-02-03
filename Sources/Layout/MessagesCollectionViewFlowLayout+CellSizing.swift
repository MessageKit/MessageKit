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

    /// Returns the height of a `MessageCollectionViewCell`'s content at a given `IndexPath`
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let avatarPosition = _avatarPosition(for: message, at: indexPath)
        let avatarHeight = _avatarSize(for: message, at: indexPath).height
        let messageContainerHeight = _messageContainerSize(for: message, at: indexPath).height
        let bottomLabelHeight = _cellBottomLabelSize(for: message, at: indexPath).height
        let topLabelHeight = _cellTopLabelSize(for: message, at: indexPath).height
        let messageVerticalPadding = _messageContainerPadding(for: message, at: indexPath).vertical

        var cellHeight: CGFloat = 0

        switch avatarPosition.vertical {
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

    /// Returns the size for the `MessageCollectionViewCell` at a given `IndexPath`
    /// considering all of the cell's content.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` of the cell.
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let context = cellLayoutContext(for: message, at: indexPath)
        guard let itemHeight = context.itemHeight else {
            fatalError("Unexpectedly received a nil itemHeight")
        }
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Internal

extension MessagesCollectionViewFlowLayout {

    internal func _cellContentHeight(for message: MessageType, at indexPath: IndexPath, _ cache: Bool = true) -> CGFloat {
        if cache, let cachedHeight = layoutContextCache.object(forKey: indexPath as NSIndexPath)?.itemHeight {
            return cachedHeight
        }
        return cellContentHeight(for: message, at: indexPath)
    }

    internal func _sizeForItem(at indexPath: IndexPath) -> CGSize {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let itemHeight = cellContentHeight(for: message, at: indexPath)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
