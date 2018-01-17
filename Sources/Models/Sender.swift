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

/// An object that groups the metadata of a messages sender.
public struct Sender {

    /// MARK: - Properties

    /// The unique String identifier for the sender.
    ///
    /// Note: This value must be unique across all senders.
    public let id: String

    /// The display name of a sender.
    public let displayName: String

    // MARK: - Intializers

    public init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
}

// MARK: - Equatable Conformance

extension Sender: Equatable {

    /// Two senders are considered equal if they have the same id.
    public static func == (left: Sender, right: Sender) -> Bool {
        return left.id == right.id
    }

}
