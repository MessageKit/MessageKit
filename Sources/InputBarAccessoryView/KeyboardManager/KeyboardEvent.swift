//
//  KeyboardEvent.swift
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

/// Keyboard events that can happen. Translates directly to `UIKeyboard` notifications from UIKit.
public enum KeyboardEvent {
    
    /// Event raised by UIKit's `.UIKeyboardWillShow`.
    case willShow
    
    /// Event raised by UIKit's `.UIKeyboardDidShow`.
    case didShow
    
    /// Event raised by UIKit's `.UIKeyboardWillShow`.
    case willHide
    
    /// Event raised by UIKit's `.UIKeyboardDidHide`.
    case didHide
    
    /// Event raised by UIKit's `.UIKeyboardWillChangeFrame`.
    case willChangeFrame
    
    /// Event raised by UIKit's `.UIKeyboardDidChangeFrame`.
    case didChangeFrame
    
    /// Non-keyboard based event raised by UIKit
    case unknown
    
}
