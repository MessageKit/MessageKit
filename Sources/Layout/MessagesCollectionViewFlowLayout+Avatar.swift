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
    
    /// Returns the `AvatarPosition` for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method retrieves its value from
    ///         `avatarPosition(for:at:in)` in `MessagesLayoutDelegate`.
    open func avatarPosition(for message: MessageType, at indexPath: IndexPath) -> AvatarPosition {
        var position = messagesLayoutDelegate.avatarPosition(for: message, at: indexPath, in: messagesCollectionView)

        switch position.horizontal {
        case .cellTrailing, .cellLeading:
            break
        case .natural:
            position.horizontal = messagesDataSource.isFromCurrentSender(message: message) ? .cellTrailing : .cellLeading
        }
        return position
    }

    /// Returns the `AvatarSize` for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    /// - Note: The default implementation of this method retrieves its value from
    ///         `avatarSize(for:at:in)` in `MessagesLayoutDelegate`.
    open func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return messagesLayoutDelegate.avatarSize(for: message, at: indexPath, in: messagesCollectionView)
    }
}

// MARK: - Internal

extension MessagesCollectionViewFlowLayout {

    internal func _avatarPosition(for message: MessageType, at indexPath: IndexPath) -> AvatarPosition {

        guard let cachedPosition = currentLayoutContext.avatarPosition else {
            let position = avatarPosition(for: message, at: indexPath)
            currentLayoutContext.avatarPosition = position
            return position
        }
        return cachedPosition
    }

    internal func _avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        guard let cachedSize = currentLayoutContext.avatarSize else {
            let size = avatarSize(for: message, at: indexPath)
            currentLayoutContext.avatarSize = size
            return size
        }
        return cachedSize
    }
}
