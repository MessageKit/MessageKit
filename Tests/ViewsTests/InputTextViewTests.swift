/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
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

    func testPlaceholderLabelSetup() {
        XCTAssertEqual(textView.placeholderLabel.numberOfLines, 0)
        XCTAssertEqual(textView.placeholderLabel.textColor, UIColor.lightGray)
        XCTAssertEqual(textView.placeholderLabel.text, "New Message")
        XCTAssertEqual(textView.placeholderLabel.backgroundColor, UIColor.clear)
        XCTAssertFalse(textView.placeholderLabel.translatesAutoresizingMaskIntoConstraints)
    }

    func testPlaceholderLabelIsHiddenWhenTextIsEmpty() {
        textView.text = ""
        XCTAssertFalse(textView.placeholderLabel.isHidden)
    }

    func testPlaceholderLabelIsNotHiddenWhenTextIsNotEmpty() {
        textView.text = "New Text"
        XCTAssert(textView.placeholderLabel.isHidden)
    }

    func testPlaceholderTextChanging() {
        textView.placeholder = "New Placeholder"
        XCTAssertEqual(textView.placeholderLabel.text, "New Placeholder")
    }

    func testPlaceholderTextColorChanging() {
        textView.placeholderTextColor = UIColor.red
        XCTAssertEqual(textView.placeholderLabel.textColor, UIColor.red)
    }

    func testFontChanging() {
        textView.font = UIFont.systemFont(ofSize: 14)
        XCTAssertEqual(textView.placeholderLabel.font, UIFont.systemFont(ofSize: 14))
    }

    func testTextAlignmentChanging() {
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
