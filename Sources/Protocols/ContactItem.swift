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

/// A protocol used to represent the data for a contact message.
public protocol ContactItem {
    
    /// contact first name
    var firstName: String? { get }
    
    /// contact last name
    var lastName: String? { get }
    
    /// contact phone numbers
    var phoneNumbers: [String] { get }
    
    /// contact emails
    var emails: [String] { get }
    
    /// Return full name from given contact item
    /// By default the priority in computing contact name is:
    /// 1. first + last name
    /// 2. phone number
    /// 3. email address
    func getName() -> String
    
    /// Return name initials from given contact. If first and last name is not set it returns #
    func getInitials() -> String
}

/// Default Implementation for contact name and initials
public extension ContactItem {

    func getName() -> String {
        var name = firstName ?? ""
        if let lastName = lastName, lastName.count > 0 {
            name += (name.count > 0) ? " \(lastName)" : lastName
        }
        if name.count == 0 { // if name is still 0 show first phone number
            name = phoneNumbers.first ?? ""
        }
        if name.count == 0 { // if name is still 0 show first email
            name = emails.first ?? ""
        }
        return name
    }

    func getInitials() -> String {
        var initials = getFirstLeterFrom(firstName) + getFirstLeterFrom(lastName)
        if initials.count == 0 {
            initials = "#"
        }
        return initials
    }
    
    private func getFirstLeterFrom(_ string: String?) -> String {
        guard let value = string, value.count > 0 else {
            return ""
        }
        return String(value.first!).capitalized
    }
}
