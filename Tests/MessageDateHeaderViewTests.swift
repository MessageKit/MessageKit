//
//  MessageDateHeaderViewTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class MessageDateHeaderViewTests: XCTestCase {
    
    var view: MessageDateHeaderView!
    
    override func setUp() {
        super.setUp()
        view = MessageDateHeaderView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertTrue(view.subviews.contains(view.dateLabel))
        XCTAssertEqual(view.dateLabel.textAlignment, .center)
        XCTAssertEqual(view.dateLabel.font, .boldSystemFont(ofSize: 10))
        XCTAssertEqual(view.dateLabel.textColor, UIColor.darkGray)
    }
    
}
