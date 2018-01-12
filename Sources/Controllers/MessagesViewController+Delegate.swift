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

extension MessagesViewController: UICollectionViewDelegateFlowLayout {

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDeleagte)
        }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return layoutDelegate.headerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDeleagte)
        }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return layoutDelegate.footerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return false }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch message.data {
        case .text, .attributedText, .emoji, .photo:
            selectedIndexPathForMenu = indexPath
            return true
        default:
            return false
        }
    }

    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return (action == NSSelectorFromString("copy:"))
    }

    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let pasteBoard = UIPasteboard.general
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch message.data {
        case .text(let text), .emoji(let text):
            pasteBoard.string = text
        case .attributedText(let attributedText):
            pasteBoard.string = attributedText.string
        case .photo(let image):
            pasteBoard.image = image
        default:
            break
        }
    }
}
