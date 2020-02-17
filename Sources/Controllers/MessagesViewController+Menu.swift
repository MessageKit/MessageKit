/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

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

internal extension MessagesViewController {

    // MARK: - Register / Unregister Observers

    internal func addMenuControllerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.menuControllerWillShow(_:)), name: UIMenuController.willShowMenuNotification, object: nil)
    }

    internal func removeMenuControllerObservers() {
        NotificationCenter.default.removeObserver(self, name: UIMenuController.willShowMenuNotification, object: nil)
    }

    // MARK: - Notification Handlers

    /// Show menuController and set target rect to selected bubble
    @objc
    private func menuControllerWillShow(_ notification: Notification) {

        guard let currentMenuController = notification.object as? UIMenuController,
            let selectedIndexPath = selectedIndexPathForMenu else { return }

        NotificationCenter.default.removeObserver(self, name: UIMenuController.willShowMenuNotification, object: nil)
        defer {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(MessagesViewController.menuControllerWillShow(_:)),
                                                   name: UIMenuController.willShowMenuNotification, object: nil)
            selectedIndexPathForMenu = nil
        }

        currentMenuController.setMenuVisible(false, animated: false)

        guard let selectedCell = messagesCollectionView.cellForItem(at: selectedIndexPath) as? MessageContentCell else { return }
        let selectedCellMessageBubbleFrame = selectedCell.convert(selectedCell.messageContainerView.frame, to: view)

        var messageInputBarFrame: CGRect = .zero
        if let messageInputBarSuperview = messageInputBar.superview {
            messageInputBarFrame = view.convert(messageInputBar.frame, from: messageInputBarSuperview)
        }

        var topNavigationBarFrame: CGRect = navigationBarFrame
        if navigationBarFrame != .zero, let navigationBarSuperview = navigationController?.navigationBar.superview {
            topNavigationBarFrame = view.convert(navigationController!.navigationBar.frame, from: navigationBarSuperview)
        }

        let menuHeight = currentMenuController.menuFrame.height

        let selectedCellMessageBubblePlusMenuFrame = CGRect(selectedCellMessageBubbleFrame.origin.x, selectedCellMessageBubbleFrame.origin.y - menuHeight, selectedCellMessageBubbleFrame.size.width, selectedCellMessageBubbleFrame.size.height + 2 * menuHeight)

        var targetRect: CGRect = selectedCellMessageBubbleFrame
        currentMenuController.arrowDirection = .default

        /// Message bubble intersects with navigationBar and keyboard
        if selectedCellMessageBubblePlusMenuFrame.intersects(topNavigationBarFrame) && selectedCellMessageBubblePlusMenuFrame.intersects(messageInputBarFrame) {
            let centerY = (selectedCellMessageBubblePlusMenuFrame.intersection(messageInputBarFrame).minY + selectedCellMessageBubblePlusMenuFrame.intersection(topNavigationBarFrame).maxY) / 2
            targetRect = CGRect(selectedCellMessageBubblePlusMenuFrame.midX, centerY, 1, 1)
        } /// Message bubble only intersects with navigationBar
        else if selectedCellMessageBubblePlusMenuFrame.intersects(topNavigationBarFrame) {
            currentMenuController.arrowDirection = .up
        }

        currentMenuController.setTargetRect(targetRect, in: view)
        currentMenuController.setMenuVisible(true, animated: true)
    }

    // MARK: - Helpers

    private var navigationBarFrame: CGRect {
        guard let navigationController = navigationController, !navigationController.navigationBar.isHidden else {
            return .zero
        }
        return navigationController.navigationBar.frame
    }
}
