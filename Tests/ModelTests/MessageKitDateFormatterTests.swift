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

import XCTest
@testable import MessageKit

class MessageKitDateFormatterTests: XCTestCase {

    var formatter: DateFormatter!
    let attributes = [NSAttributedString.Key.backgroundColor: "red"]
    override func setUp() {
        super.setUp()

        formatter = DateFormatter()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testConfigureDateFormatterToday() {
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        XCTAssertEqual(MessageKitDateFormatter.shared.string(from: Date()), formatter.string(from: Date()))
    }

    func testConfigureDateFormatterTodayAttributed() {
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        XCTAssertEqual(MessageKitDateFormatter.shared.attributedString(from: Date(), with: attributes), NSAttributedString(string: formatter.string(from: Date()), attributes: attributes))
    }

    func testConfigureDateFormatterYesterday() {
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let yesterday = (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: Date(), options: [])!
        XCTAssertEqual(MessageKitDateFormatter.shared.string(from: yesterday), formatter.string(from: yesterday))
    }

    func testConfigureDateFormatterYesterdayAttributed() {
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let yesterday = (Calendar.current as NSCalendar).date(byAdding: .day, value: -1, to: Date(), options: [])!
        XCTAssertEqual(MessageKitDateFormatter.shared.attributedString(from: yesterday,
                                                                       with: attributes),
                       NSAttributedString(string: formatter.string(from: yesterday), attributes: attributes))
    }

    func testConfigureDateFormatterWeekAndYear() {
        //First day of current week
        var startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        //Check if today or yesterday was the first day of the week, because it will be different format then
        if Calendar.current.isDateInToday(startOfWeek) || Calendar.current.isDateInYesterday(startOfWeek) {
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .short
            formatter.timeStyle = .short

            XCTAssertEqual(MessageKitDateFormatter.shared.string(from: startOfWeek), formatter.string(from: startOfWeek))
        } else {
            formatter.dateFormat = "EEEE h:mm a"
            XCTAssertEqual(MessageKitDateFormatter.shared.string(from: startOfWeek), formatter.string(from: startOfWeek))
        }

        ///Day of last week
        startOfWeek = (Calendar.current as NSCalendar).date(byAdding: .day, value: -2, to: startOfWeek, options: [])!
        
        if Calendar.current.isDate(startOfWeek, equalTo: Date(), toGranularity: .year) {
            formatter.dateFormat = "E, d MMM, h:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
        
        XCTAssertEqual(MessageKitDateFormatter.shared.string(from: startOfWeek), formatter.string(from: startOfWeek))
    }

    func testConfigureDateFormatterForMoreThanYear() {
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        let lastYear = (Calendar.current as NSCalendar).date(byAdding: .year, value: -1, to: Date(), options: [])!

        XCTAssertEqual(formatter.string(from: lastYear), MessageKitDateFormatter.shared.string(from: lastYear))
    }

}
