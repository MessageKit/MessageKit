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

    var sut: MessageInputBar!

    override func setUp() {
        super.setUp()
        sut = MessageInputBar()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testBlurEffectTranslatesAutoresizingMaskIntoConstraints_IsFalseAfterInit() {
        XCTAssertFalse(sut.blurView.translatesAutoresizingMaskIntoConstraints)
    }

    func testBlurEffectIsHidden_IsTrueAfterInit() {
        XCTAssertTrue(sut.blurView.isHidden)
    }

    func testIsTranslucent_IsFalseForDefault() {
        XCTAssertFalse(sut.isTranslucent)
    }

    func testBlurViewIsHidden_IsFalseWhenIsTranslucentIsTrue() {
        sut.isTranslucent = true
        XCTAssertFalse(sut.blurView.isHidden)
    }

    func testBackgroundColor_IsClearWhenIsTranslucentIsTrue() {
        sut.isTranslucent = true
        XCTAssertEqual(sut.backgroundColor, UIColor.clear)
    }

    func testBlurViewIsHidden_IsTrueWhenIsTranslucentIsFalse() {
        sut.isTranslucent = false
        XCTAssertTrue(sut.blurView.isHidden)
    }

    func testBackgroundColor_IsWhiteWhenIsTranslucentIsFalse() {
        sut.isTranslucent = false
        XCTAssertEqual(sut.backgroundColor, UIColor.white)
    }

    func testSeparatorLine_IsNotNilAfterInit() {
        XCTAssertNotNil(sut.separatorLine)
    }

    func testLeftStackView_IsNotNilAfterInit() {
        XCTAssertNotNil(sut.leftStackView)
    }

    func testLeftStackViewAxis_IsHorizontalAfterInit() {
        XCTAssertEqual(sut.leftStackView.axis, .horizontal)
    }

    func testLeftStackViewSpacing_IsZeroAfterInit() {
        XCTAssertEqual(sut.leftStackView.spacing, 0)
    }
    
    func testRightStackView_IsNotNilAfterInit() {
        XCTAssertNotNil(sut.rightStackView)
    }

    func testRightStackViewAxis_IsHorizontalAfterInit() {
        XCTAssertEqual(sut.rightStackView.axis, .horizontal)
    }

    func testRightStackViewSpacing_IsZeroAfterInit() {
        XCTAssertEqual(sut.rightStackView.spacing, 0)
    }

    func testBottomStackView_IsNotNilAfterInit() {
        XCTAssertNotNil(sut.bottomStackView)
    }

    func testBottomStackViewAxis_IsHorizontalAfterInit() {
        XCTAssertEqual(sut.bottomStackView.axis, .horizontal)
    }

    func testBottomStackViewSpacing_IsZeroAfterInit() {
        XCTAssertEqual(sut.bottomStackView.spacing, 15)
    }

    func testInputTextViewMessageInputBar_IsSelf() {
        XCTAssertEqual(sut.inputTextView.messageInputBar, sut)
    }

    func testInputTextViewTranslatesAutoresizingMaskIntoConstraints_IsFalseAfterInit() {
        XCTAssertFalse(sut.inputTextView.translatesAutoresizingMaskIntoConstraints)
    }

    func testSendButtonTitle_IsSendAfterInit() {
        XCTAssertEqual(sut.sendButton.title, "Send")
    }

    func testSendButtonIsEnabled_IsFalseAfterInit() {
        XCTAssertFalse(sut.sendButton.isEnabled)
    }

    func testSendButtonFont_IsHeadlineAfterInit() {
        XCTAssertEqual(sut.sendButton.titleLabel?.font, UIFont.preferredFont(forTextStyle: .headline))
    }

}
