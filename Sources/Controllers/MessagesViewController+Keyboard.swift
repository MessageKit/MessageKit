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

extension MessagesViewController {

    // MARK: - Register / Unregister Observers

    internal func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.handleKeyboardDidChangeState(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.handleTextViewDidBeginEditing(_:)), name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.adjustScrollViewTopInset), name: .UIDeviceOrientationDidChange, object: nil)
    }

    internal func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }

    // MARK: - Notification Handlers

    @objc
    private func handleTextViewDidBeginEditing(_ notification: Notification) {
        if scrollsToBottomOnKeybordBeginsEditing {
            guard let inputTextView = notification.object as? InputTextView, inputTextView === messageInputBar.inputTextView else { return }
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    @objc
    private func handleKeyboardDidChangeState(_ notification: Notification) {
        guard let keyboardStartFrameInScreenCoords = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard !keyboardStartFrameInScreenCoords.isEmpty else {
            // WORKAROUND for what seems to be a bug in iPad's keyboard handling in iOS 11: we receive an extra spurious frame change
            // notification when undocking the keyboard, with a zero starting frame and an incorrect end frame. The workaround is to
            // ignore this notification.
            return
        }
        
        guard let keyboardEndFrameInScreenCoords = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardEndFrame = view.convert(keyboardEndFrameInScreenCoords, from: view.window)
        
        guard !isMessagesControllerBeingDismissed else { return }
        
        let newBottomInset = computeScrollViewBottomInset(forKeyboardFrame: keyboardEndFrame)
        let differenceOfBottomInset = newBottomInset - messageCollectionViewBottomInset
        
        if maintainPositionOnKeyboardFrameChanged && differenceOfBottomInset != 0 {
            let contentOffset = CGPoint(x: messagesCollectionView.contentOffset.x, y: messagesCollectionView.contentOffset.y + differenceOfBottomInset)
            messagesCollectionView.setContentOffset(contentOffset, animated: false)
        }
        
        messageCollectionViewBottomInset = newBottomInset
    }


    // MARK: - Inset Computation

    @objc
    internal func adjustScrollViewTopInset() {
        if #available(iOS 11.0, *) {
            // No need to add to the top contentInset
        } else {
            let navigationBarInset = navigationController?.navigationBar.frame.height ?? 0
            let statusBarInset: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : 20
            let topInset = navigationBarInset + statusBarInset
            messagesCollectionView.contentInset.top = topInset
            messagesCollectionView.scrollIndicatorInsets.top = topInset
        }
    }

    private func computeScrollViewBottomInset(forKeyboardFrame keyboardFrame: CGRect) -> CGFloat {
        // we only need to adjust for the part of the keyboard that covers (i.e. intersects) our collection view;
        // see https://developer.apple.com/videos/play/wwdc2017/242/ for more details
        let intersection = messagesCollectionView.frame.intersection(keyboardFrame)
        
        if intersection.isNull || intersection.maxY < messagesCollectionView.frame.maxY - 1e-6 /* never compare floats without a tolerance */ {
            return 0  // keyboard is undocked/hardware, or just does not cover the bottom of the collection view
        } else {
            return max(0, intersection.height - automaticallyAddedBottomInset)
        }
    }

    internal func computeInitialScrollViewBottomInset() -> CGFloat {
        guard let inputAccessoryView = inputAccessoryView else { return 0 }
        return max(0, inputAccessoryView.frame.height - automaticallyAddedBottomInset)
    }

    /// iOS 11's UIScrollView can automatically add safe area insets to its contentInset,
    /// which needs to be accounted for when setting the contentInset based on screen coordinates.
    ///
    /// - Returns: The distance automatically added to contentInset.bottom, if any.
    private var automaticallyAddedBottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            return messagesCollectionView.adjustedContentInset.bottom - messagesCollectionView.contentInset.bottom
        } else {
            return 0
        }
    }

}
