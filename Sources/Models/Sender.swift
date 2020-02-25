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

/// An object that groups the metadata of a messages sender.
@available(*, deprecated, message: "`Sender` has been replaced with the `SenderType` protocol in 3.0.0")
public struct Sender: SenderType {

    // MARK: - Properties

    /// The unique String identifier for the sender.
    ///
    /// Note: This value must be unique across all senders.
    public let senderId: String

    @available(*, deprecated, renamed: "senderId", message: "`id` has been renamed `senderId` as defined in the `SenderType` protocol")
    public var id: String {
        return senderId
    }

    /// The display name of a sender.
    public let displayName: String

    // MARK: - Intializers

    public init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }

    @available(*, deprecated, message: "`id` has been renamed `senderId` as defined in the `SenderType` protocol")
    public init(id: String, displayName: String) {
        self.init(senderId: id, displayName: displayName)
    }
}
