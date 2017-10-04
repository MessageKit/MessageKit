//
//  InputTextViewTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class InputTextViewTests: XCTestCase {
    
    var textView: InputTextView!
    
    override func setUp() {
        super.setUp()
        textView = InputTextView()
    }
    
    override func tearDown() {
        textView = nil
        super.tearDown()
    }
    
    func testPlaceholderLabel() {
        XCTAssertEqual(textView.placeholderLabel.numberOfLines, 0)
        XCTAssertEqual(textView.placeholderLabel.textColor, UIColor.lightGray)
        XCTAssertEqual(textView.placeholderLabel.text, "New Message")
        XCTAssertEqual(textView.placeholderLabel.backgroundColor, UIColor.clear)
        XCTAssertFalse(textView.placeholderLabel.translatesAutoresizingMaskIntoConstraints)
    }
    
    func testTextChanging() {
        textView.text = "New Text"
        XCTAssertTrue(textView.placeholderLabel.isHidden)
        textView.text = ""
        XCTAssertFalse(textView.placeholderLabel.isHidden)
    }
    
    func testPlaceholderText() {
        textView.placeholder = "New Placeholder"
        XCTAssertEqual(textView.placeholderLabel.text, "New Placeholder")
    }
    
    func testPlaceholderTextColor() {
        textView.placeholderTextColor = UIColor.red
        XCTAssertEqual(textView.placeholderLabel.textColor, UIColor.red)
    }
    
    func testFont() {
        textView.font = UIFont.systemFont(ofSize: 14)
        XCTAssertEqual(textView.placeholderLabel.font, UIFont.systemFont(ofSize: 14))
    }
    
    func testTextAlignment() {
        textView.textAlignment = .center
        XCTAssertEqual(textView.placeholderLabel.textAlignment, .center)
    }
    
    func testSetup() {
        textView.setup()
        XCTAssertEqual(textView.font, UIFont.preferredFont(forTextStyle: .body))
        XCTAssertEqual(textView.textContainerInset, UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        XCTAssertFalse(textView.isScrollEnabled)
        XCTAssertEqual(textView.layer.cornerRadius, 5.0)
        XCTAssertEqual(textView.layer.borderWidth, 1.25)
        XCTAssertEqual(textView.layer.borderColor, UIColor.lightGray.cgColor)
        
        XCTAssertTrue(textView.subviews.contains(textView.placeholderLabel))
    }

}
