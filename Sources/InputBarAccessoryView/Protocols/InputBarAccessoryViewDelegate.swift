//
//  InputBarAccessoryViewDelegate.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 8/18/17.
//

import Foundation
import UIKit

/// InputBarAccessoryViewDelegate is a protocol that can recieve notifications from the InputBarAccessoryView
public protocol InputBarAccessoryViewDelegate: AnyObject {
    
    /// Called when the default send button has been selected
    ///
    /// - Parameters:
    ///   - inputBar: The InputBarAccessoryView
    ///   - text: The current text in the InputBarAccessoryView's InputTextView
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String)
    
    /// Called when the instrinsicContentSize of the InputBarAccessoryView has changed. Can be used for adjusting content insets
    /// on other views to make sure the InputBarAccessoryView does not cover up any other view
    ///
    /// - Parameters:
    ///   - inputBar: The InputBarAccessoryView
    ///   - size: The new instrinsicContentSize
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize)
    
    /// Called when the InputBarAccessoryView's InputTextView's text has changed. Useful for adding your own logic without the
    /// need of assigning a delegate or notification
    ///
    /// - Parameters:
    ///   - inputBar: The InputBarAccessoryView
    ///   - text: The current text in the InputBarAccessoryView's InputTextView
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String)
    
    /// Called when a swipe gesture was recognized on the InputBarAccessoryView's InputTextView
    ///
    /// - Parameters:
    ///   - inputBar: The InputBarAccessoryView
    ///   - gesture: The gesture that was recognized
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer)
}

public extension InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {}
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {}
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {}
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {}
}
