//
//  MessageCollectionViewCellTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

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
    
    func testMessageContainerView() {
        XCTAssertTrue(cell.messageContainerView.clipsToBounds)
        XCTAssertTrue(cell.messageContainerView.layer.masksToBounds)
    }
    
    func testCellTopLabel() {
        XCTAssertEqual(cell.cellTopLabel.enabledDetectors, [])
    }
    
    func testMessageContentView() {
        XCTAssertTrue(cell.messageContentView.clipsToBounds)
        XCTAssertTrue(cell.messageContentView.isUserInteractionEnabled)
    }
    
    func testCellBottomLabel() {
        XCTAssertEqual(cell.cellBottomLabel.enabledDetectors, [])
    }
    
    func testPrepareForReuse() {
        cell.prepareForReuse()
        XCTAssertNil(cell.cellTopLabel.text)
        XCTAssertNil(cell.cellTopLabel.attributedText)
        XCTAssertNil(cell.cellBottomLabel.text)
        XCTAssertNil(cell.cellBottomLabel.attributedText)
    }
    
}
