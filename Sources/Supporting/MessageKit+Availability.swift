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

public extension MessagesLayoutDelegate {

    @available(*, deprecated: 0.14.0, message: "avatarSize(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingAvatarSize and outgoingAvatarSize properties on MessagesCollectionViewFlowLayout.")
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        fatalError("avatarSize(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingAvatarSize and outgoingAvatarSize properties on MessagesCollectionViewFlowLayout.")
    }

    @available(*, deprecated: 0.14.0, message: "avatarPosition(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingAvatarPosition and outgoingAvatarPosition properties on MessagesCollectionViewFlowLayout.")
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        fatalError("avatarPosition(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingAvatarPosition and outgoingAvatarPosition properties on MessagesCollectionViewFlowLayout.")
    }

    @available(*, deprecated: 0.14.0, message: "messageLabelInset(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingMessageLabelInset and outgoingMessageLabelInset properties on MessagesCollectionViewFlowLayout.")
    func messageLabelInset(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        fatalError("messageLabelInset(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingMessageLabelInset and outgoingMessageLabelInset properties on MessagesCollectionViewFlowLayout.")
    }

    @available(*, deprecated: 0.14.0, message: "messagePadding(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingMessagePadding and outgoingMessagePadding properties on MessagesCollectionViewFlowLayout.")
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        fatalError("messagePadding(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingMessagePadding and outgoingMessagePadding properties on MessagesCollectionViewFlowLayout.")
    }

    @available(*, deprecated: 0.14.0, message: "cellTopLabelAlignment(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingCellTopLabelAlignment and outgoingCellTopLabelAlignment properties on MessagesCollectionViewFlowLayout.")
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        fatalError("cellTopLabelAlignment(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingCellTopLabelAlignment and outgoingCellTopLabelAlignment properties on MessagesCollectionViewFlowLayout.")
    }

    @available(*, deprecated: 0.14.0, message: "cellBottomLabelAlignment(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingCellBottomLabelAlignment and outgoingCellBottomLabelAlignment properties on MessagesCollectionViewFlowLayout.")
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        fatalError("cellBottomLabelAlignment(for:at:in) has been removed in MessageKit 0.14.0. Please use the incomingCellBottomLabelAlignment and outgoingCellBottomLabelAlignment properties on MessagesCollectionViewFlowLayout.")
    }
}
