/*
 MIT License

 Copyright (c) 2017 MessageKit

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

// MARK: - MessagesDisplayDataSource

@available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use MessagesDisplayDelegate.")
public protocol MessagesDisplayDataSource {}

// MARK: - MessagesCollectionView

public extension MessagesCollectionView {

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use messageCellDelegate.")
    public weak var messageLabelDelegate: MessageLabelDelegate? {
        return nil
    }

}

// MARK: - MessagesCollectionViewFlowLayout

public extension MessagesCollectionViewFlowLayout {

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use avatarSize(for:indexPath:messagesCollectionView)")
    public var incomingAvatarSize: CGSize {
        return .zero
    }

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use avatarSize(for:indexPath:messagesCollectionView)")
    public var outgoingAvatarSize: CGSize {
        return .zero
    }

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use `cellTopLabelPosition(for:indexPath:messagesCollectionView)")
    public var topLabelExtendsPastAvatar: Bool {
        return false
    }

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use `cellBottomLabelPosition(for:indexPath:messagesCollectionView)")
    public var bottomLabelExtendsPastAvatar: Bool {
        return false
    }

}

// MARK: - CellLabelPosition

@available(*, deprecated: 0.7.0, message: "Renamed to LabelAlignment in MessageKit 0.7.0")
public enum CellLabelPosition {

    case cellTrailing
    case cellLeading
    case cellCenter
    case messageTrailing
    case messageLeading
    
}

// MARK: - Avatar Position

@available(*, deprecated: 0.7.0, message: "Renamed to AvatarAlignment in MessageKit 0.7.0")
public enum AvatarPosition {

    case cellTop
    case messageTop
    case messageCenter
    case messageBottom
    case cellBottom
    
}

// MARK: - MessagesLayoutDelegate

public extension MessagesLayoutDelegate {

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use avatarAlignment(for:indexPath:messagesCollectionView)")
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return .cellBottom
    }

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use cellTopLabelAlignment(for:indexPath:messagesCollectionView)")
    func cellTopLabelPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellLabelPosition {
        return .cellLeading
    }

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use cellBottomLabelAlignment(for:indexPath:messagesCollectionView)")
    func cellBottomLabelPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellLabelPosition {
        return .cellLeading
    }

}
