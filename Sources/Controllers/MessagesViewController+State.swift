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
  final class State {
    /// Pan gesture for display the date of message by swiping left.
    var panGesture: UIPanGestureRecognizer?
    var maintainPositionOnInputBarHeightChanged = false
    var scrollsToLastItemOnKeyboardBeginsEditing = false

    let inputContainerView: MessagesInputContainerView = .init()
    @Published var inputBarType: MessageInputBarKind = .messageInputBar
    let keyboardManager = KeyboardManager()
    var disposeBag: Set<AnyCancellable> = .init()
  }

  // MARK: - Getters

  var keyboardManager: KeyboardManager { state.keyboardManager }

  var panGesture: UIPanGestureRecognizer? {
    get { state.panGesture }
    set { state.panGesture = newValue }
  }

  var disposeBag: Set<AnyCancellable> {
    get { state.disposeBag }
    set { state.disposeBag = newValue }
  }
}

extension MessagesViewController {
  /// Container holding `messageInputBar` view. To change type of input bar, set `inputBarType` to desired kind.
  public var inputContainerView: MessagesInputContainerView { state.inputContainerView }

  /// Kind of `messageInputBar` to be added into `inputContainerView`
  public var inputBarType: MessageInputBarKind {
    get { state.inputBarType }
    set { state.inputBarType = newValue }
  }

  /// A Boolean value that determines whether the `MessagesCollectionView`
  /// maintains it's current position when the height of the `MessageInputBar` changes.
  ///
  /// The default value of this property is `false`.
  @available(
    *,
    deprecated,
    renamed: "maintainPositionOnInputBarHeightChanged",
    message: "Please use new property - maintainPositionOnInputBarHeightChanged")
  public var maintainPositionOnKeyboardFrameChanged: Bool {
    get { state.maintainPositionOnInputBarHeightChanged }
    set { state.maintainPositionOnInputBarHeightChanged = newValue }
  }

  /// A Boolean value that determines whether the `MessagesCollectionView`
  /// maintains it's current position when the height of the `MessageInputBar` changes.
  ///
  /// The default value of this property is `false` and the `MessagesCollectionView` will scroll to bottom after the
  /// height of the `MessageInputBar` changes.
  public var maintainPositionOnInputBarHeightChanged: Bool {
    get { state.maintainPositionOnInputBarHeightChanged }
    set { state.maintainPositionOnInputBarHeightChanged = newValue }
  }

  /// A Boolean value that determines whether the `MessagesCollectionView` scrolls to the
  /// last item whenever the `InputTextView` begins editing.
  ///
  /// The default value of this property is `false`.
  /// NOTE: This is related to `scrollToLastItem` whereas the below flag is related to `scrollToBottom` - check each function for differences
  public var scrollsToLastItemOnKeyboardBeginsEditing: Bool {
    get { state.scrollsToLastItemOnKeyboardBeginsEditing }
    set { state.scrollsToLastItemOnKeyboardBeginsEditing = newValue }
  }
}
