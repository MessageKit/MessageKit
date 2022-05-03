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
        if #available(iOS 13.0, *) {
            NotificationCenter.default
                .publisher(for: UITextView.textDidBeginEditingNotification)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink { [weak self] notification in
                    self?.handleTextViewDidBeginEditing(notification)
                }
                .store(in: &disposeBag)

            Publishers.MergeMany(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification),
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
                NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            )
            .subscribe(on: DispatchQueue.global())
            .sink(receiveValue: { [weak self] _ in
                self?.updateMessageCollectionViewBottomInset()
            })
            .store(in: &disposeBag)
        }
    }

    // MARK: - Private methods

    private func updateMessageCollectionViewBottomInset() {

        /// This is important to skip notifications from child modal controllers in iOS >= 13.0
        guard
            viewIsVisible,
            self.presentedViewController == nil
        else {
            return
        }

        let collectionViewHeight = messagesCollectionView.frame.height
        let newBottomInset = collectionViewHeight - (inputContainerView.frame.minY - additionalBottomInset) - automaticallyAddedBottomInset
        let differenceOfBottomInset = newBottomInset - messageCollectionViewBottomInset

        UIView.performWithoutAnimation {
            if differenceOfBottomInset != 0 {
                messageCollectionViewBottomInset = newBottomInset
            }
        }

        if maintainPositionOnKeyboardFrameChanged && differenceOfBottomInset != 0 {
            let contentOffset = CGPoint(x: messagesCollectionView.contentOffset.x, y: messagesCollectionView.contentOffset.y + differenceOfBottomInset)
            // Changing contentOffset to bigger number than the contentSize will result in a jump of content
            // https://github.com/MessageKit/MessageKit/issues/1486
            guard contentOffset.y <= messagesCollectionView.contentSize.height else {
                return
            }
            messagesCollectionView.setContentOffset(contentOffset, animated: false)
        }
    }

    private func handleTextViewDidBeginEditing(_ notification: Notification) {
        if scrollsToLastItemOnKeyboardBeginsEditing || scrollsToLastItemOnKeyboardBeginsEditing {
            guard
                let inputTextView = notification.object as? InputTextView,
                inputTextView === messageInputBar.inputTextView
            else {
                return
            }
            if scrollsToLastItemOnKeyboardBeginsEditing {
                messagesCollectionView.scrollToLastItem()
            } else {
                messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }

    // MARK: - Inset Computation

    private func requiredScrollViewBottomInset(for inputViewFrame: CGRect) -> CGFloat {
        // we only need to adjust for the part of the keyboard that covers (i.e. intersects) our collection view;
        // see https://developer.apple.com/videos/play/wwdc2017/242/ for more details
        let intersection = messagesCollectionView.frame.intersection(inputViewFrame)
        if intersection.isNull || (messagesCollectionView.frame.maxY - intersection.maxY) > 0.001 {
            // The keyboard is hidden, is a hardware one, or is undocked and does not cover the bottom of the collection view.
            // Note: intersection.maxY may be less than messagesCollectionView.frame.maxY when dealing with undocked keyboards.
            return max(0, additionalBottomInset - automaticallyAddedBottomInset)
        }

        let heightOfSpaceUnderInputContainer = max(0, messagesCollectionView.frame.height - intersection.maxY)
        return heightOfSpaceUnderInputContainer
//        if intersection.isNull || (messagesCollectionView.frame.maxY - intersection.maxY) > 0.001 {
//            // The keyboard is hidden, is a hardware one, or is undocked and does not cover the bottom of the collection view.
//            // Note: intersection.maxY may be less than messagesCollectionView.frame.maxY when dealing with undocked keyboards.
//            return max(0, additionalBottomInset - automaticallyAddedBottomInset)
//        } else {
//            return max(0, intersection.height + additionalBottomInset - automaticallyAddedBottomInset)
//        }
    }

    func requiredInitialScrollViewBottomInset() -> CGFloat {
//        let inputAccessoryViewHeight = inputAccessoryView?.frame.height ?? 0
        let inputContainerViewHeight = inputContainerView.frame.height
        return max(0, inputContainerViewHeight + additionalBottomInset - automaticallyAddedBottomInset)
    }

    /// UIScrollView can automatically add safe area insets to its contentInset,
    /// which needs to be accounted for when setting the contentInset based on screen coordinates.
    ///
    /// - Returns: The distance automatically added to contentInset.bottom, if any.
    private var automaticallyAddedBottomInset: CGFloat {
        return messagesCollectionView.adjustedContentInset.bottom - messagesCollectionView.contentInset.bottom
    }
}
