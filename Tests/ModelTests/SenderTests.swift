/*
 MIT License
 
 Copyright (c) 2017 MessageKit
 
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

import XCTest
@testable import MessageKit

class SenderTests: XCTestCase {

    var senderBob: Sender!

    override func setUp() {
        super.setUp()
        senderBob = Sender(id: "id1", displayName: "Bob")
    }

    override func tearDown() {
        super.tearDown()
        senderBob = nil
    }

    func testEquatableWithSameID() {
        let alsoSenderBob = Sender(id: "id1", displayName: "Bob")
        XCTAssertEqual(senderBob, alsoSenderBob)
    }

    func testEquatableWithDifferentID() {
        let anotherSenderBob = Sender(id: "id2", displayName: "Bob")
        XCTAssertNotEqual(senderBob, anotherSenderBob)
    }
}
