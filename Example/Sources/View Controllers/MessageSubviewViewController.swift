//
// MIT License
//
// Copyright (c) 2017-2019 MessageKit
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

import Foundation
import InputBarAccessoryView
import UIKit

final class MessageSubviewViewController: BasicExampleViewController {
  // MARK: Internal

  // In order to reach the subviewInputBar
  override var inputAccessoryView: UIView? {
    self.subviewInputBar
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    subviewInputBar.delegate = self
    // Take into account the height of the bottom input bar
    additionalBottomInset = 88
    // Binding to the messagesCollectionView will enable interactive dismissal
    keyboardManager.bind(to: messagesCollectionView)
  }

  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    parent?.view.addSubview(subviewInputBar)
    // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
    keyboardManager.bind(inputAccessoryView: subviewInputBar)
  }

  override func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
    processInputBar(subviewInputBar)
  }

  // MARK: Private

  private var keyboardManager = KeyboardManager()

  private let subviewInputBar = InputBarAccessoryView()
}
