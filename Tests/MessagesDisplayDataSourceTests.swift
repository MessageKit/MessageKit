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
        XCTAssertEqual(testClass.textColorFor(testClass.messageList[0]), UIColor.white)
        XCTAssertEqual(testClass.textColorFor(testClass.messageList[1]), UIColor.black)
    }
    
    func testBackGroundColorDefaultState() {
        XCTAssertEqual(testClass.backgroundColorFor(testClass.messageList[0]), UIColor.outgoingGreen)
        XCTAssertNotEqual(testClass.backgroundColorFor(testClass.messageList[0]), UIColor.incomingGray)
        XCTAssertEqual(testClass.backgroundColorFor(testClass.messageList[1]), UIColor.incomingGray)
        XCTAssertNotEqual(testClass.backgroundColorFor(testClass.messageList[1]), UIColor.outgoingGreen)
    }
    
    func testAvatarDefaultState() {
        XCTAssertNotNil(testClass.avatarForMessage(testClass.messageList[0]))
        XCTAssertEqual(testClass.avatarForMessage(testClass.messageList[0]).initals, "?")
        XCTAssertNotNil(testClass.avatarForMessage(testClass.messageList[1]))
        XCTAssertEqual(testClass.avatarForMessage(testClass.messageList[1]).initals, "?")
    }
    
    func testHeaderDefaultState() {
        XCTAssertNil(testClass.headerForMessage(testClass.messageList[0], at: IndexPath(item: 0, section: 0), in: testClass.messagesCollectionView))
    }
    
    func testFooterDefaultState() {
        XCTAssertNil(testClass.footerForMessage(testClass.messageList[0], at: IndexPath(item: 0, section: 0), in: testClass.messagesCollectionView))
    }
    
    func testCellTopLabelDefaultState() {
        XCTAssertNil(testClass.cellTopLabelAttributedText(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)))
    }
    
    func testCellBottomLabelDefaultState() {
        XCTAssertNil(testClass.cellBottomLabelAttributedText(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)))
    }
}
