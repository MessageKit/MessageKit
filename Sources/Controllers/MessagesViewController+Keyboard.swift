// MIT License
//
// Copyright (c) 2017-2022 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import Foundation
import InputBarAccessoryView
import UIKit

extension MessagesViewController {
  // MARK: Internal

  // MARK: - Register Observers

  internal func addKeyboardObservers() {
    keyboardManager.bind(inputAccessoryView: inputContainerView)
    keyboardManager.bind(to: messagesCollectionView)

    /// Observe didBeginEditing to scroll content to last item if necessary
    NotificationCenter.default
      .publisher(for: UITextView.textDidBeginEditingNotification)
      .subscribe(on: DispatchQueue.global())
      /// Wait for inputBar frame change animation to end
      .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
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
        textView == self?.messageInputBar.inputTextView
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

    /// Observe frame change of the input bar container to update collectioView bottom inset
    inputContainerView.publisher(for: \.center)
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink(receiveValue: { [weak self] _ in
        self?.updateMessageCollectionViewBottomInset()
      })
      .store(in: &disposeBag)
  }

  // MARK: - Updating insets

  /// Updates bottom messagesCollectionView inset based on the position of inputContainerView
  internal func updateMessageCollectionViewBottomInset() {
    let collectionViewHeight = messagesCollectionView.frame.maxY
    let newBottomInset = collectionViewHeight - (inputContainerView.frame.minY - additionalBottomInset) -
      automaticallyAddedBottomInset
    let normalizedNewBottomInset = max(0, newBottomInset)
    let differenceOfBottomInset = newBottomInset - messageCollectionViewBottomInset

    UIView.performWithoutAnimation {
      guard differenceOfBottomInset != 0 else { return }
      messagesCollectionView.contentInset.bottom = normalizedNewBottomInset
      messagesCollectionView.verticalScrollIndicatorInsets.bottom = newBottomInset
    }
  }

  // MARK: Private

  /// UIScrollView can automatically add safe area insets to its contentInset,
  /// which needs to be accounted for when setting the contentInset based on screen coordinates.
  ///
  /// - Returns: The distance automatically added to contentInset.bottom, if any.
  private var automaticallyAddedBottomInset: CGFloat {
    messagesCollectionView.adjustedContentInset.bottom - messageCollectionViewBottomInset
  }

  private var messageCollectionViewBottomInset: CGFloat {
    messagesCollectionView.contentInset.bottom
  }

  /// UIScrollView can automatically add safe area insets to its contentInset,
  /// which needs to be accounted for when setting the contentInset based on screen coordinates.
  ///
  /// - Returns: The distance automatically added to contentInset.top, if any.
  private var automaticallyAddedTopInset: CGFloat {
    messagesCollectionView.adjustedContentInset.top - messageCollectionViewTopInset
  }

  private var messageCollectionViewTopInset: CGFloat {
    messagesCollectionView.contentInset.top
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
}
