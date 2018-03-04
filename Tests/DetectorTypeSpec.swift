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

import Quick
import Nimble
@testable import MessageKit

final class DetectorTypeSpec: QuickSpec {

    override func spec() {
        describe("mapping to NSTextCheckingResult.CheckingType") {
            context("case .address") {
                it("should equal .address") {
                    let address = DetectorType.address.textCheckingType
                    expect(address).to(equal(NSTextCheckingResult.CheckingType.address))
                }
            }
            context("case .url") {
                it("should equal .link") {
                    let url = DetectorType.url.textCheckingType
                    expect(url).to(equal(NSTextCheckingResult.CheckingType.link))
                }
            }
            context("case .date") {
                it("should equal .date") {
                    let date = DetectorType.date.textCheckingType
                    expect(date).to(equal(NSTextCheckingResult.CheckingType.date))
                }
            }
            context("case .phoneNumber") {
                it("should equal .phoneNumber") {
                    let phoneNumber = DetectorType.phoneNumber.textCheckingType
                    expect(phoneNumber).to(equal(NSTextCheckingResult.CheckingType.phoneNumber))
                }
            }
            context("case .transitInformation") {
                it("should equal .transitInformation") {
                    let transitInformation = DetectorType.transitInformation.textCheckingType
                    expect(transitInformation).to(equal(NSTextCheckingResult.CheckingType.transitInformation))
                }
            }
        }
    }
}
