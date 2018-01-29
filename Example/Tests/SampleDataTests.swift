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
 SOFTWARE.s
 */

import XCTest
import MessageKit
import MapKit
@testable import ChatExample

final class SampleDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        SampleData.shared.resetMessageTypes()
    }
    
    func testHideTextMessages() {
        let testExpectation = expectation(description: "hideTextMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: "text")

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertNotEqual(message.type, "text", "messageData is type .text, expected all but .text")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideAttributedTextMessages() {
        let testExpectation = expectation(description: "hideAttributedTextMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: "attributedText")

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertNotEqual(message.type, "attributedText", "messageData is type .attributedText, expected all but .attributedText")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHidePhotoMessages() {
        let testExpectation = expectation(description: "hidePhotoMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: "photo")

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertNotEqual(message.type, "photo", "messageData is type .photo, expected all but .photo")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideVideoMessages() {
        let testExpectation = expectation(description: "hideVideoMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: "video")

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertNotEqual(message.type, "video", "messageData is type .video, expected all but .video")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideLocationMessages() {
        let testExpectation = expectation(description: "hideLocationMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: "location")

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertNotEqual(message.type, "location", "messageData is type .location, expected all but .location")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideEmojiMessages() {
        let testExpectation = expectation(description: "hideEmojiMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: "emoji")

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertNotEqual(message.type, "emoji", "messageData is type .emoji, expected all but .emoji")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }
}
