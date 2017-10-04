//
//  MessageInputBarTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class MessageInputBarTests: XCTestCase {
    
    var inputBar: MessageInputBar!
    
    override func setUp() {
        super.setUp()
        inputBar = MessageInputBar()
    }
    
    override func tearDown() {
        inputBar = nil
        super.tearDown()
    }
    
    func testBlurEffect() {
        XCTAssertFalse(inputBar.blurView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(inputBar.blurView.isHidden)
    }
    
    func testIsTranslucent() {
        inputBar.isTranslucent = false
        XCTAssertTrue(inputBar.blurView.isHidden)
        XCTAssertEqual(inputBar.backgroundColor, UIColor.white)
        inputBar.isTranslucent = true
        XCTAssertFalse(inputBar.blurView.isHidden)
        XCTAssertEqual(inputBar.backgroundColor, UIColor.clear)
    }
    
    func testSeparatorLine() {
        XCTAssertEqual(inputBar.separatorLine.backgroundColor, UIColor.lightGray)
        XCTAssertFalse(inputBar.separatorLine.translatesAutoresizingMaskIntoConstraints)
    }
    
    func testLeftStackView() {
        XCTAssertEqual(inputBar.leftStackView.axis, .horizontal)
        XCTAssertEqual(inputBar.leftStackView.distribution, .fill)
        XCTAssertEqual(inputBar.leftStackView.alignment, .fill)
        XCTAssertEqual(inputBar.leftStackView.spacing, 15)
        XCTAssertFalse(inputBar.leftStackView.translatesAutoresizingMaskIntoConstraints)
    }
    
    func testRightStackView() {
        XCTAssertEqual(inputBar.rightStackView.axis, .horizontal)
        XCTAssertEqual(inputBar.rightStackView.distribution, .fill)
        XCTAssertEqual(inputBar.rightStackView.alignment, .fill)
        XCTAssertEqual(inputBar.rightStackView.spacing, 15)
        XCTAssertFalse(inputBar.rightStackView.translatesAutoresizingMaskIntoConstraints)
    }
    
    func testBottomStackView() {
        XCTAssertEqual(inputBar.bottomStackView.axis, .horizontal)
        XCTAssertEqual(inputBar.bottomStackView.distribution, .fill)
        XCTAssertEqual(inputBar.bottomStackView.alignment, .fill)
        XCTAssertEqual(inputBar.bottomStackView.spacing, 15)
        XCTAssertFalse(inputBar.bottomStackView.translatesAutoresizingMaskIntoConstraints)
    }
    
    func testInputTextView() {
        XCTAssertFalse(inputBar.inputTextView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(inputBar.inputTextView.messageInputBar, inputBar)
    }
    
    func testSendButton() {
        XCTAssertEqual(inputBar.sendButton.size, CGSize(width: 52, height: 28))
        XCTAssertEqual(inputBar.sendButton.title, "Send")
        XCTAssertEqual(inputBar.sendButton.titleLabel?.font, UIFont.preferredFont(forTextStyle: .headline))
        XCTAssertFalse(inputBar.sendButton.isEnabled)
    }
    
}
