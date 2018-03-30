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

/// A protocol used by the `MessagesCollectionViewFlowLayout` object to determine
/// the size and layout of a `MessageCollectionViewCell` and its contents.
public protocol MessagesLayoutDelegate: AnyObject {

    /// Specifies the size to use for a `MessageHeaderView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this header.
    ///   - indexPath: The `IndexPath` of the header.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this header will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is the width of the `MessagesCollectionView`
    ///   and a height of 12.
    func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// Specifies the size to use for a `MessageFooterView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this footer.
    ///   - indexPath: The `IndexPath` of the footer.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this footer will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is a size of `GGSize.zero`.
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// Specifies the height for the `MessageContentCell`'s top label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is zero.
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// Specifies the height for the `MessageContentCell`'s bottom label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is zero.
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

}

public extension MessagesLayoutDelegate {

    func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        let shouldDisplay = displayDelegate.shouldDisplayHeader(for: message, at: indexPath, in: messagesCollectionView)
        return shouldDisplay ? CGSize(width: messagesCollectionView.bounds.width, height: 12) : .zero
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}
