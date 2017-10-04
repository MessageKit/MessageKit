//
//  MessageKitDateFormatterTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class MessageKitDateFormatterTests: XCTestCase {
    
    var formatter: DateFormatter!
    let attributes = [NSAttributedStringKey.backgroundColor: "red"]
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
        startOfWeek = startOfWeek.addingTimeInterval(-60*60*24)
        formatter.dateFormat = "E, d MMM, h:mm a"
        XCTAssertEqual(MessageKitDateFormatter.shared.string(from: startOfWeek), formatter.string(from: startOfWeek))
    }
    
    func testConfigureDateFormatterForMoreThanYear() {
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        let lastYear = (Calendar.current as NSCalendar).date(byAdding: .year, value: -1, to: Date(), options: [])!
        
        XCTAssertEqual(formatter.string(from: lastYear), MessageKitDateFormatter.shared.string(from: lastYear))
    }
    
}
