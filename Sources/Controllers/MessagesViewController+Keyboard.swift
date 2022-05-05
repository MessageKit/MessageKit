/*
 MIT License

 Copyright (c) 2017-2022 MessageKit

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
import UIKit
import Combine
import InputBarAccessoryView

internal extension MessagesViewController {

    // MARK: - Register Observers
    
    func addKeyboardObservers() {
        keyboardManager.bind(inputAccessoryView: inputContainerView)
        keyboardManager.bind(to: messagesCollectionView)

        /// Observe didBeginEditing to scroll down the content
        NotificationCenter.default
            .publisher(for: UITextView.textDidBeginEditingNotification)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleTextViewDidBeginEditing(notification)
            }
            .store(in: &disposeBag)

        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .compactMap { $0.object as? InputTextView }
            .filter { [weak self] textView in
                return textView == self?.messageInputBar.inputTextView
            }
            .map(\.text)
            .removeDuplicates()
            .delay(for: .milliseconds(50), scheduler: DispatchQueue.main) /// Wait for next runloop to lay out inputView properly
            .sink { [weak self] _ in
                self?.updateMessageCollectionViewBottomInset()

                if !(self?.maintainPositionOnInputBarHeightChanged ?? false) {
                    self?.messagesCollectionView.scrollToLastItem()
                }
            }
            .store(in: &disposeBag)

        Publishers.MergeMany(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        )
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] _ in
            self?.updateMessageCollectionViewBottomInset()
        })
        .store(in: &disposeBag)
    }

    // MARK: - Updating insets

    /// Updates bottom messagesCollectionView inset based on the position of inputContainerView
    func updateMessageCollectionViewBottomInset() {
        /// This is important to skip notifications from child modal controllers in iOS >= 13.0
        guard self.presentedViewController == nil else { return }
        let collectionViewHeight = messagesCollectionView.frame.height
        let newBottomInset = collectionViewHeight - (inputContainerView.frame.minY - additionalBottomInset) - automaticallyAddedBottomInset
        let normalizedNewBottomInset = max(0, newBottomInset)
        let differenceOfBottomInset = newBottomInset - messageCollectionViewBottomInset

        UIView.performWithoutAnimation {
            guard differenceOfBottomInset != 0 else { return }
            messagesCollectionView.contentInset.bottom = normalizedNewBottomInset
            messagesCollectionView.verticalScrollIndicatorInsets.bottom = newBottomInset
        }
    }

    // MARK: - Private methods

    private func handleTextViewDidBeginEditing(_ notification: Notification) {
        guard
            scrollsToLastItemOnKeyboardBeginsEditing,
            let inputTextView = notification.object as? InputTextView,
            inputTextView === messageInputBar.inputTextView
        else {
            return
        }
        messagesCollectionView.scrollToLastItem()
    }

    /// UIScrollView can automatically add safe area insets to its contentInset,
    /// which needs to be accounted for when setting the contentInset based on screen coordinates.
    ///
    /// - Returns: The distance automatically added to contentInset.bottom, if any.
    private var automaticallyAddedBottomInset: CGFloat {
        return messagesCollectionView.adjustedContentInset.bottom - messageCollectionViewBottomInset
    }

    private var messageCollectionViewBottomInset: CGFloat {
        return messagesCollectionView.contentInset.bottom
    }

    /// UIScrollView can automatically add safe area insets to its contentInset,
    /// which needs to be accounted for when setting the contentInset based on screen coordinates.
    ///
    /// - Returns: The distance automatically added to contentInset.top, if any.
    private var automaticallyAddedTopInset: CGFloat {
        return messagesCollectionView.adjustedContentInset.top - messageCollectionViewTopInset
    }

    private var messageCollectionViewTopInset: CGFloat {
        return messagesCollectionView.contentInset.top
    }
}
