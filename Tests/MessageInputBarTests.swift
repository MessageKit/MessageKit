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
