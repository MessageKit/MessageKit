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

import UIKit
import InputBarAccessoryView

@available(*, obsoleted: 3.0.0, renamed: "InputBarAccessoryView")
public typealias MessageInputBar = InputBarAccessoryView

@available(*, obsoleted: 3.0.0, renamed: "InputBarAccessoryViewDelegate")
public typealias MessageInputBarDelegate = InputBarAccessoryViewDelegate

//public extension MessageInputBarDelegate {
//
//    @available(*, obsoleted: 3.0.0, message: "`MessageInputBar` has been replaced with `InputBarAccessoryView` in 3.0.0. Use `inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String)` instead.")
//    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//    }
//
//    @available(*, obsoleted: 3.0.0, message: "`MessageInputBar` has been replaced with `InputBarAccessoryView` in 3.0.0. Use `inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String)` instead.")
//    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
//    }
//
//    @available(*, obsoleted: 3.0.0, message: "`MessageInputBar` has been replaced with `InputBarAccessoryView` in 3.0.0. Use `inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize)` instead.")
//    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
//    }
//}
//
//extension InputBarButtonItem {
//
//    @available(*, renamed: "inputBarAccessoryView")
//    public var messageInputBar: MessageInputBar? {
//        return inputBarAccessoryView
//    }
//}
