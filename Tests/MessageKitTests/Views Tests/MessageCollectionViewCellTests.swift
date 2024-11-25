// MIT License
//
// Copyright (c) 2017-2020 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import XCTest
@testable import MessageKit

// MARK: - MessageContentCellTests

@MainActor
final class MessageContentCellTests: XCTestCase {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    func testInit() {
        let cell = MessageContentCell(frame: frame)
        XCTAssertEqual(cell.contentView.autoresizingMask, [.flexibleWidth, .flexibleHeight])
        XCTAssert(cell.contentView.subviews.contains(cell.cellTopLabel))
        XCTAssert(cell.contentView.subviews.contains(cell.messageBottomLabel))
        XCTAssert(cell.contentView.subviews.contains(cell.avatarView))
        XCTAssert(cell.contentView.subviews.contains(cell.messageContainerView))
    }

    func testMessageContainerViewPropertiesSetup() {
        let cell = MessageContentCell(frame: frame)
        XCTAssertTrue(cell.messageContainerView.clipsToBounds)
        XCTAssertTrue(cell.messageContainerView.layer.masksToBounds)
    }

    func testPrepareForReuse() {
        let cell = MessageContentCell(frame: frame)
        cell.prepareForReuse()
        XCTAssertNil(cell.cellTopLabel.text)
        XCTAssertNil(cell.cellTopLabel.attributedText)
        XCTAssertNil(cell.messageBottomLabel.text)
        XCTAssertNil(cell.messageBottomLabel.attributedText)
    }

    func testApplyLayoutAttributes() {
        let cell = MessageContentCell(frame: frame)
        let layoutAttributes = MessagesCollectionViewLayoutAttributes()
        layoutAttributes.avatarPosition = AvatarPosition(horizontal: .cellLeading, vertical: .cellBottom)
        cell.apply(layoutAttributes)

        XCTAssertEqual(cell.avatarView.frame, layoutAttributes.frame)
        XCTAssertEqual(cell.messageContainerView.frame.size, layoutAttributes.messageContainerSize)
        XCTAssertEqual(cell.cellTopLabel.frame.size, layoutAttributes.cellTopLabelSize)
        XCTAssertEqual(cell.messageBottomLabel.frame.size, layoutAttributes.messageBottomLabelSize)
    }
}

extension MessageContentCellTests {
    private class MockMessagesDisplayDelegate: MessagesDisplayDelegate {
        func snapshotOptionsForLocation(
            message _: MessageType,
            at _: IndexPath,
            in _: MessagesCollectionView)
        -> LocationMessageSnapshotOptions
        {
            LocationMessageSnapshotOptions()
        }
    }
}
