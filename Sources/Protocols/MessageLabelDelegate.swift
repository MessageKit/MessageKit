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
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectAddress(_ addressComponents: [String: String], in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectAddress(_:in:touchLocation:)")
    func didSelectAddress(_ addressComponents: String)

    /// Triggered when a tap occurs on a detected date.
    ///
    /// - Parameters:
    ///   - date: The selected date.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectDate(_ date: Date, in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectDate(_:in:touchLocation:)")
    func didSelectDate(_ date: String)

    /// Triggered when a tap occurs on a detected phone number.
    ///
    /// - Parameters:
    ///   - phoneNumber: The selected phone number.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectPhoneNumber(_ phoneNumber: String, in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectPhoneNumber(_:in:touchLocation:)")
    func didSelectPhoneNumber(_ phoneNumber: String)

    /// Triggered when a tap occurs on a detected URL.
    ///
    /// - Parameters:
    ///   - url: The selected URL.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectURL(_ url: URL, in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectURL(_:in:touchLocation:)")
    func didSelectURL(_ url: String)

    /// Triggered when a tap occurs on detected transit information.
    ///
    /// - Parameters:
    ///   - transitInformation: The selected transit information.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectTransitInformation(_ transitInformation: [String: String], in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectTransitInformation(_:in:touchLocation:)")
    func didSelectTransitInformation(_ transitInformation: String)

    /// Triggered when a tap occurs on a mention
    ///
    /// - Parameters:
    ///   - mention: The selected mention.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectMention(_ mention: String, in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectMention(_:in:touchLocation:)")
    func didSelectMention(_ mention: String)

    /// Triggered when a tap occurs on a hashtag
    ///
    /// - Parameters:
    ///   - mention: The selected hashtag.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectHashtag(_ hashtag: String, in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectHashtag(_:in:touchLocation:)")
    func didSelectHashtag(_ hashtag: String)

    /// Triggered when a tap occurs on a custom regular expression
    ///
    /// - Parameters:
    ///   - pattern: the pattern of the regular expression.
    ///   - match: part that match with the regular expression.
    ///   - messageLabel: The `MessageLabel` in which the tap happened.
    ///   - touchLocation: The location in the `MessageLabel` in which the tap happened.
    func didSelectCustom(_ pattern: String, match: String?, in messageLabel: MessageLabel, touchLocation: CGPoint)

    @available(*, unavailable, renamed: "didSelectCustom(_:match:in:touchLocation:)")
    func didSelectCustom(_ pattern: String)
}

public extension MessageLabelDelegate {

    func didSelectAddress(_ addressComponents: [String: String], in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectDate(_ date: Date, in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectPhoneNumber(_ phoneNumber: String, in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectURL(_ url: URL, in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectTransitInformation(_ transitInformation: [String: String], in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectMention(_ mention: String, in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectHashtag(_ hashtag: String, in messageLabel: MessageLabel, touchLocation: CGPoint) {}

    func didSelectCustom(_ pattern: String, match: String?, in messageLabel: MessageLabel, touchLocation: CGPoint) {}

}
