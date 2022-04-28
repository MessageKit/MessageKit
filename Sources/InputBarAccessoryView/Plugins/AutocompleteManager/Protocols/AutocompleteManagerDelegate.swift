//
//  AutocompleteManagerDelegate.swift
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
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

/// AutocompleteManagerDelegate is a protocol that more precisely define AutocompleteManager logic
public protocol AutocompleteManagerDelegate: AnyObject {
    
    /// Can be used to determine if the AutocompleteManager should be inserted into an InputStackView
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - shouldBecomeVisible: If the AutocompleteManager should be presented or dismissed
    func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool)
    
    /// Determines if a prefix character should be registered to initialize the auto-complete selection table
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - prefix: The prefix `Character` could be registered
    ///   - range: The `NSRange` of the prefix in the UITextView managed by the AutocompleteManager
    /// - Returns: If the prefix should be registered. Default is TRUE
    func autocompleteManager(_ manager: AutocompleteManager, shouldRegister prefix: String, at range: NSRange) -> Bool
    
    /// Determines if a prefix character should be unregistered to de-initialize the auto-complete selection table
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - prefix: The prefix character could be unregistered
    ///   - range: The range of the prefix in the UITextView managed by the AutocompleteManager
    /// - Returns: If the prefix should be unregistered. Default is TRUE
    func autocompleteManager(_ manager: AutocompleteManager, shouldUnregister prefix: String) -> Bool
    
    /// Determines if a prefix character can should be autocompleted
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - prefix: The prefix character that is currently registered
    ///   - text: The text to autocomplete with
    /// - Returns: If the prefix can be autocompleted. Default is TRUE
    func autocompleteManager(_ manager: AutocompleteManager, shouldComplete prefix: String, with text: String) -> Bool
}

public extension AutocompleteManagerDelegate {
    
    func autocompleteManager(_ manager: AutocompleteManager, shouldRegister prefix: String, at range: NSRange) -> Bool {
        return true
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, shouldUnregister prefix: String) -> Bool {
        return true
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, shouldComplete prefix: String, with text: String) -> Bool {
        return true
    }
}

