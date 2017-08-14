//
//  MessagesDisplayDataSourceTests.swift
//  MessageKit
//
//  Created by Dan Leonard on 8/14/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class MessagesDisplayDataSourceTests: XCTestCase {
    
    let testClass = TestMessagesViewControllerModel()
    override func setUp() {
        super.setUp()
        // Ensures that the messageList has been set.
        testClass.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(testClass)
        XCTAssertNotNil(testClass.messageList)
    }
    
    func testMessageTextColorDefaultState() {
        XCTAssertEqual(testClass.textColor(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)), UIColor.white)
        XCTAssertEqual(testClass.textColor(for: testClass.messageList[1], at: IndexPath(item: 1, section: 0)), UIColor.black)
    }
    
    func testBackGroundColorDefaultState() {
        XCTAssertEqual(testClass.backgroundColor(for: testClass.messageList[0], at:  IndexPath(item: 0, section: 0)), UIColor.outgoingGreen)
        XCTAssertNotEqual(testClass.backgroundColor(for: testClass.messageList[0], at:  IndexPath(item: 0, section: 0)), UIColor.incomingGray)
        XCTAssertEqual(testClass.backgroundColor(for: testClass.messageList[1], at:  IndexPath(item: 1, section: 0)), UIColor.incomingGray)
        XCTAssertNotEqual(testClass.backgroundColor(for: testClass.messageList[1], at:  IndexPath(item: 1, section: 0)), UIColor.outgoingGreen)
    }
    
    func testAvatarDefaultState() {
        XCTAssertNotNil(testClass.avatar(for: testClass.messageList[0]).initals)
        XCTAssertNotNil(testClass.avatar(for: testClass.messageList[1]).initals)
        XCTAssertEqual(testClass.avatar(for: testClass.messageList[0]).initals, "?")
        XCTAssertEqual(testClass.avatar(for: testClass.messageList[1]).initals, "?")
    }
    
    func testCellTopLabelDefaultState() {
        XCTAssertNil(testClass.cellTopLabelAttributedText(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)))
    }
    
    func testCellBottomLabelDefaultState() {
        XCTAssertNil(testClass.cellBottomLabelAttributedText(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)))
    }
}
