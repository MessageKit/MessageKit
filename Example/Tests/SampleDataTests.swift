//
//  SampleDataTests.swift
//  ChatExample
//
//  Created by Alessio Arsuffi on 28/01/2018.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import XCTest
import MessageKit
import MapKit
@testable import ChatExample

class SampleDataTests: XCTestCase {
    
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
        SampleData.shared.hideMessageTypes(types: .text(""))

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertTrue(message.data != .text(""), "messageData is type .text, expected all but .text")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideAttributedTextMessages() {
        let testExpectation = expectation(description: "hideAttributedTextMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: .attributedText(NSAttributedString()))

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertTrue(message.data != .attributedText(NSAttributedString()), "messageData is type .attributedText, expected all but .attributedText")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHidePhotoMessages() {
        let testExpectation = expectation(description: "hidePhotoMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: .photo(UIImage()))

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertTrue(message.data != .photo(UIImage()), "messageData is type .photo, expected all but .photo")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideVideoMessages() {
        let testExpectation = expectation(description: "hideVideoMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: .video(file: URL(string: "http://")!, thumbnail: UIImage()))

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertTrue(message.data != .video(file: URL(string: "http://")!, thumbnail: UIImage()), "messageData is type .video, expected all but .video")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideLocationMessages() {
        let testExpectation = expectation(description: "hideLocationMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: .location(CLLocation(latitude: 0, longitude: 0)))

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertTrue(message.data != .location(CLLocation(latitude: 0, longitude: 0)), "messageData is type .location, expected all but .location")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testHideEmojiMessages() {
        let testExpectation = expectation(description: "hideEmojiMessagesExpectation")

        // Given
        SampleData.shared.hideMessageTypes(types: .emoji(""))

        // When
        SampleData.shared.getMessages(count: 50) { messages in
            messages.forEach { message in
                // Then
                XCTAssertTrue(message.data != .emoji(""), "messageData is type .emoji, expected all but .emoji")
            }
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }
}
