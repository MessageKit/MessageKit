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

import Foundation

/// A protocol used to handle tap events on detected text.
public protocol MessageLabelDelegate: AnyObject {

    /// Triggered when a tap occurs on a detected address.
    ///
    /// - Parameters:
    ///   - addressComponents: The components of the selected address.
    func didSelectAddress(_ addressComponents: [String: String])

    /// Triggered when a tap occurs on a detected date.
    ///
    /// - Parameters:
    ///   - date: The selected date.
    func didSelectDate(_ date: Date)

    /// Triggered when a tap occurs on a detected phone number.
    ///
    /// - Parameters:
    ///   - phoneNumber: The selected phone number.
    func didSelectPhoneNumber(_ phoneNumber: String)

    /// Triggered when a tap occurs on a detected URL.
    ///
    /// - Parameters:
    ///   - url: The selected URL.
    func didSelectURL(_ url: URL)

    /// Triggered when a tap occurs on detected transit information.
    ///
    /// - Parameters:
    ///   - transitInformation: The selected transit information.
    func didSelectTransitInformation(_ transitInformation: [String: String])
    
    /// Triggered when a tap occurs on a mention
    ///
    /// - Parameters:
    ///   - mention: The selected mention
    func didSelectMention(_ mention: String)
    
    /// Triggered when a tap occurs on a hashtag
    ///
    /// - Parameters:
    ///   - mention: The selected hashtag
    func didSelectHashtag(_ hashtag: String)

    /// Triggered when a tap occurs on a custom regular expression
    ///
    /// - Parameters:
    ///   - pattern: the pattern of the regular expression
    ///   - match: part that match with the regular expression
    func didSelectCustom(_ pattern: String, match: String?)

}

public extension MessageLabelDelegate {

    func didSelectAddress(_ addressComponents: [String: String]) {}

    func didSelectDate(_ date: Date) {}

    func didSelectPhoneNumber(_ phoneNumber: String) {}

    func didSelectURL(_ url: URL) {}
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {}

    func didSelectMention(_ mention: String) {}

    func didSelectHashtag(_ hashtag: String) {}

    func didSelectCustom(_ pattern: String, match: String?) {}

}
