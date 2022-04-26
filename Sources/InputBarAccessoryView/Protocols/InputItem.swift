//
//  InputItem.swift
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
//  Copyright © 2017-2020 Nathan Tannar. All rights reserved.
//

import UIKit

/// InputItem is a protocol that links elements to the InputBarAccessoryView to make them reactive
public protocol InputItem: AnyObject {
    
    /// A weak reference to the InputBarAccessoryView. Set when inserted into an InputStackView
    var inputBarAccessoryView: InputBarAccessoryView? { get set }
    
    /// A reference to the InputStackView that the InputItem is contained in. Set when inserted into an InputStackView
    var parentStackViewPosition: InputStackView.Position? { get set }
    
    /// A hook that is called when the InputTextView's text is changed
    func textViewDidChangeAction(with textView: InputTextView)
    
    /// A hook that is called when the InputBarAccessoryView's InputTextView receieves a swipe gesture
    func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer)
    
    /// A hook that is called when the InputTextView is resigned as the first responder
    func keyboardEditingEndsAction()
    
    /// A hook that is called when the InputTextView is made the first responder
    func keyboardEditingBeginsAction()
}
