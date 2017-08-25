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
        XCTAssertEqual(testClass.textColor(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0), in: testClass.messagesCollectionView), UIColor.white)
        XCTAssertEqual(testClass.textColor(for: testClass.messageList[1], at: IndexPath(item: 1, section: 0), in: testClass.messagesCollectionView), UIColor.black)
    }
    
    func testBackGroundColorDefaultState() {
        XCTAssertEqual(testClass.backgroundColor(for: testClass.messageList[0], at:  IndexPath(item: 0, section: 0), in: testClass.messagesCollectionView), UIColor.outgoingGreen)
        XCTAssertNotEqual(testClass.backgroundColor(for: testClass.messageList[0], at:  IndexPath(item: 0, section: 0), in: testClass.messagesCollectionView), UIColor.incomingGray)
        XCTAssertEqual(testClass.backgroundColor(for: testClass.messageList[1], at:  IndexPath(item: 1, section: 0), in: testClass.messagesCollectionView), UIColor.incomingGray)
        XCTAssertNotEqual(testClass.backgroundColor(for: testClass.messageList[1], at:  IndexPath(item: 1, section: 0), in: testClass.messagesCollectionView), UIColor.outgoingGreen)
    }
    
    func testAvatarDefaultState() {
        XCTAssertNotNil(testClass.avatar(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0), in: testClass.messagesCollectionView).initals)
    }
    
    func testCellTopLabelDefaultState() {
        XCTAssertNil(testClass.cellTopLabelAttributedText(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)))
    }
    
    func testCellBottomLabelDefaultState() {
        XCTAssertNil(testClass.cellBottomLabelAttributedText(for: testClass.messageList[0], at: IndexPath(item: 0, section: 0)))
    }
}
