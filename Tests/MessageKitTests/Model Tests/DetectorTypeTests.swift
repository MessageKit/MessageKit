/*
 MIT License

 Copyright (c) 2017-2020 MessageKit

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
import XCTest
@testable import MessageKit

final class DetectorTypeTests: XCTestCase {
    func testMappingToNSTextCheckingResultCheckingType() {
        /// case .address should equal .address
        let address = DetectorType.address.textCheckingType
        XCTAssertEqual(address, NSTextCheckingResult.CheckingType.address)
        /// case .url should equal to .link
        let url = DetectorType.url.textCheckingType
        XCTAssertEqual(url, NSTextCheckingResult.CheckingType.link)
        /// case .date should equal to .date
        let date = DetectorType.date.textCheckingType
        XCTAssertEqual(date, NSTextCheckingResult.CheckingType.date)
        /// case .phoneNumber should equal to .phoneNumber
        let phoneNumber = DetectorType.phoneNumber.textCheckingType
        XCTAssertEqual(phoneNumber, NSTextCheckingResult.CheckingType.phoneNumber)
        /// case .transitInformation should equal to .transitInformation
        let transitInformation = DetectorType.transitInformation.textCheckingType
        XCTAssertEqual(transitInformation, NSTextCheckingResult.CheckingType.transitInformation)
    }
}
