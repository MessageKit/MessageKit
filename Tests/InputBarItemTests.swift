//
//  InputBarItemTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class InputBarItemTests: XCTestCase {
    
    var button: InputBarButtonItem!
    
    override func setUp() {
        super.setUp()
        button = InputBarButtonItem()
    }
    
    override func tearDown() {
        button = nil
        super.tearDown()
    }
    
    func testSetup() {
        XCTAssertEqual(button.contentVerticalAlignment, .center)
        XCTAssertEqual(button.contentHorizontalAlignment, .center)
        XCTAssertEqual(button.imageView?.contentMode, .scaleAspectFit)
        XCTAssertEqual(button.titleColor(for: .normal), UIColor(red: 0, green: 122/255, blue: 1, alpha: 1))
        XCTAssertEqual(button.titleColor(for: .highlighted), UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.3))
        XCTAssertEqual(button.titleColor(for: .disabled), UIColor.lightGray)
        XCTAssertFalse(button.adjustsImageWhenHighlighted)
    }
    
    func testFlexibleSpace() {
        XCTAssertEqual(InputBarButtonItem.flexibleSpace.size, .zero)
    }
    
    func testFixedSpace() {
        let item = InputBarButtonItem.fixedSpace(100)
        XCTAssertEqual(item.size, .zero)
    }
    
}
