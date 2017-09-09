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

extension MessagesCollectionView {

    @available(*, deprecated: 0.7.0, message: "Removed in MessageKit 0.7.0. Please use messageCellDelegate.")
    public weak var messageLabelDelegate: MessageLabelDelegate? {
        return nil
    }

}

// MARK: - MessagesCollectionViewFlowLayout

extension MessagesCollectionViewFlowLayout {

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
