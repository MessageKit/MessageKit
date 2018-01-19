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

class MessageInputBarTests: XCTestCase {

    var sut: MessageInputBar!

    override func setUp() {
        super.setUp()
        sut = MessageInputBar()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testBlurEffectTranslatesAutoresizingMaskIntoConstraints_isFalseAfterInit() {
        XCTAssertFalse(sut.blurView.translatesAutoresizingMaskIntoConstraints)
    }

    func testIsTranslucent_isFalseForDefault() {
        XCTAssertFalse(sut.isTranslucent)
    }

    func testUISetups_forIsTranslucentIsTrue() {
        sut.isTranslucent = true
        XCTAssertFalse(sut.blurView.isHidden)
    }

    func testUISetups_forIsTranslucentIsFalse() {
        sut.isTranslucent = false
        XCTAssertTrue(sut.blurView.isHidden)
    }

    func testSeparatorLine_isNotNilAfterInit() {
        XCTAssertNotNil(sut.separatorLine)
    }

    func testLeftStackView_isNotNilAfterInit() {
        XCTAssertNotNil(sut.leftStackView)
    }

    func testLeftStackViewAxis_isHorizontalAfterInit() {
        XCTAssertEqual(sut.leftStackView.axis, .horizontal)
    }

    func testLeftStackViewSpacing_isZeroAfterInit() {
        XCTAssertEqual(sut.leftStackView.spacing, 0)
    }
    
    func testRightStackView_isNotNilAfterInit() {
        XCTAssertNotNil(sut.rightStackView)
    }

    func testRightStackViewAxis_isHorizontalAfterInit() {
        XCTAssertEqual(sut.rightStackView.axis, .horizontal)
    }

    func testRightStackViewSpacing_isZeroAfterInit() {
        XCTAssertEqual(sut.rightStackView.spacing, 0)
    }

    func testBottomStackView_isNotNilAfterInit() {
        XCTAssertNotNil(sut.bottomStackView)
    }

    func testBottomStackViewAxis_isHorizontalAfterInit() {
        XCTAssertEqual(sut.bottomStackView.axis, .horizontal)
    }

    func testBottomStackViewSpacing_isZeroAfterInit() {
        XCTAssertEqual(sut.bottomStackView.spacing, 15)
    }

    func testInputTextViewMessageInputBar_isSelf() {
        XCTAssertEqual(sut.inputTextView.messageInputBar, sut)
    }

    func testInputTextViewTranslatesAutoresizingMaskIntoConstraints_isFalseAfterInit() {
        XCTAssertFalse(sut.inputTextView.translatesAutoresizingMaskIntoConstraints)
    }

    func testSendButtonTitle_isSendAfterInit() {
        XCTAssertEqual(sut.sendButton.title, "Send")
    }

    func testSendButtonIsEnabled_isFalseAfterInit() {
        XCTAssertFalse(sut.sendButton.isEnabled)
    }

    func testSendButtonFont_isHeadlineAfterInit() {
        XCTAssertEqual(sut.sendButton.titleLabel?.font, UIFont.preferredFont(forTextStyle: .headline))
    }

}
