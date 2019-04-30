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

import Quick
import Nimble
@testable import MessageKit

final class SenderSpec: QuickSpec {

    override func spec() {
        describe("equality between two Senders") {
            context("they have the same id ") {
                it("should be equal") {
                    let sender1 = MockUser(senderId: "1", displayName: "Steven")
                    let sender2 = MockUser(senderId: "1", displayName: "Nathan")
                    expect(sender1.senderId == sender2.senderId).to(equal(true))
                }
            }
            context("they have a different id") {
                it("should not be equal") {
                    let sender1 = MockUser(senderId: "1", displayName: "Steven")
                    let sender2 = MockUser(senderId: "2", displayName: "Nathan")
                    expect(sender1.senderId == sender2.senderId).to(equal(false))
                }
            }
        }
    }
}
