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

/// A protocol used by `MessageContentCell` subclasses to detect taps in the cell's subviews.
public protocol MessageCellDelegate: MessageLabelDelegate {

    /// Triggered when a tap occurs in the `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - cell: The cell where the tap occurred.
    ///
    /// - Note:
    /// You can get a reference to the `MessageType` for the cell by using `UICollectionView`'s
    /// `indexPath(for: cell)` method. Then using the returned `IndexPath` with the `MessagesDataSource`
    /// method `messageForItem(at:indexPath:messagesCollectionView)`.
    func didTapMessage(in cell: MessageCollectionViewCell)

    /// Triggered when a tap occurs in the `AvatarView`.
    ///
    /// - Parameters:
    ///   - cell: The cell where the tap occurred.
    ///
    /// You can get a reference to the `MessageType` for the cell by using `UICollectionView`'s
    /// `indexPath(for: cell)` method. Then using the returned `IndexPath` with the `MessagesDataSource`
    /// method `messageForItem(at:indexPath:messagesCollectionView)`.
    func didTapAvatar(in cell: MessageCollectionViewCell)

    /// Triggered when a tap occurs in the cellTopLabel.
    ///
    /// - Parameters:
    ///   - cell: The cell tap the touch occurred.
    ///
    /// You can get a reference to the `MessageType` for the cell by using `UICollectionView`'s
    /// `indexPath(for: cell)` method. Then using the returned `IndexPath` with the `MessagesDataSource`
    /// method `messageForItem(at:indexPath:messagesCollectionView)`.
    func didTapCellTopLabel(in cell: MessageCollectionViewCell)
    
    /// Triggered when a tap occurs in the messageTopLabel.
    ///
    /// - Parameters:
    ///   - cell: The cell tap the touch occurred.
    ///
    /// You can get a reference to the `MessageType` for the cell by using `UICollectionView`'s
    /// `indexPath(for: cell)` method. Then using the returned `IndexPath` with the `MessagesDataSource`
    /// method `messageForItem(at:indexPath:messagesCollectionView)`.
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell)

    /// Triggered when a tap occurs in the messageBottomLabel.
    ///
    /// - Parameters:
    ///   - cell: The cell where the tap occurred.
    ///
    /// You can get a reference to the `MessageType` for the cell by using `UICollectionView`'s
    /// `indexPath(for: cell)` method. Then using the returned `IndexPath` with the `MessagesDataSource`
    /// method `messageForItem(at:indexPath:messagesCollectionView)`.
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell)
    
    /// Triggered when a tap occurs in the accessoryView.
    ///
    /// - Parameters:
    ///   - cell: The cell where the tap occurred.
    ///
    /// You can get a reference to the `MessageType` for the cell by using `UICollectionView`'s
    /// `indexPath(for: cell)` method. Then using the returned `IndexPath` with the `MessagesDataSource`
    /// method `messageForItem(at:indexPath:messagesCollectionView)`.
    func didTapAccessoryView(in cell: MessageCollectionViewCell)

}

public extension MessageCellDelegate {

    func didTapMessage(in cell: MessageCollectionViewCell) {}

    func didTapAvatar(in cell: MessageCollectionViewCell) {}

    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {}

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {}

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {}
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {}
}
