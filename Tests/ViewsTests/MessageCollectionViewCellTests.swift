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

class MessageCollectionViewCellTests: XCTestCase {

    var cell: MessageCollectionViewCell<UIView>!
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    override func setUp() {
        super.setUp()
        cell = MessageCollectionViewCell(frame: frame)
    }

    override func tearDown() {
        cell = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(cell.contentView.autoresizingMask, [.flexibleWidth, .flexibleHeight])
        XCTAssertEqual(cell.contentView.subviews, [cell.cellTopLabel, cell.messageContainerView, cell.avatarView, cell.cellBottomLabel])
        XCTAssertEqual(cell.messageContainerView.subviews, [cell.messageContentView])
    }

    func testMessageContainerViewPropertiesSetup() {
        XCTAssertTrue(cell.messageContainerView.clipsToBounds)
        XCTAssertTrue(cell.messageContainerView.layer.masksToBounds)
    }

    func testCellTopLabelPropertySetup() {
        XCTAssertEqual(cell.cellTopLabel.enabledDetectors, [])
    }

    func testMessageContentViewPropertiesSetup() {
        XCTAssertTrue(cell.messageContentView.clipsToBounds)
        XCTAssertTrue(cell.messageContentView.isUserInteractionEnabled)
    }

    func testCellBottomLabelPropertiesSetup() {
        XCTAssertEqual(cell.cellBottomLabel.enabledDetectors, [])
    }

    func testPrepareForReuse() {
        cell.prepareForReuse()
        XCTAssertNil(cell.cellTopLabel.text)
        XCTAssertNil(cell.cellTopLabel.attributedText)
        XCTAssertNil(cell.cellBottomLabel.text)
        XCTAssertNil(cell.cellBottomLabel.attributedText)
    }

    func testApplyLayoutAttributes() {
        let layoutAttributes = MessagesCollectionViewLayoutAttributes()
        cell.apply(layoutAttributes)

        XCTAssertEqual(cell.avatarView.frame, layoutAttributes.frame)
        XCTAssertEqual(cell.messageContainerView.frame, layoutAttributes.messageContainerFrame)
        XCTAssertEqual(cell.messageContentView.frame, cell.messageContainerView.frame)
        XCTAssertEqual(cell.cellTopLabel.frame, layoutAttributes.cellTopLabelFrame)
        XCTAssertEqual(cell.cellTopLabel.textInsets, layoutAttributes.cellTopLabelInsets)
        XCTAssertEqual(cell.cellBottomLabel.frame, layoutAttributes.cellBottomLabelFrame)
        XCTAssertEqual(cell.cellBottomLabel.textInsets, layoutAttributes.cellBottomLabelInsets)
    }

}

extension MessageCollectionViewCellTests {

    fileprivate class MockMessagesDisplayDelegate: MessagesDisplayDelegate { }

}
