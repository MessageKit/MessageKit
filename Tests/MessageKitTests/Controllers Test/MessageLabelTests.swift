/*
 MIT License

 Copyright (c) 2017-2020 MessageKit

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

import Foundation
import XCTest
@testable import MessageKit

final class MessageLabelTests: XCTestCase {

    let mentionsList = ["@julienkode", "@facebook", "@google", "@1234"]
    let hashtagsList = ["#julienkode", "#facebook", "#google", "#1234"]
    
    func testMentionDetection() {
        let messageLabel: MessageLabel = MessageLabel()
        let detector: DetectorType = DetectorType.mention
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: "Mention"): "MentionDetected"]
        
        let text = mentionsList.joined(separator: " #test ")
        set(text: text, and: [detector], with: attributes, to: messageLabel)
        let matches = extractCustomDetectors(for: detector, with: messageLabel)
        XCTAssertEqual(matches, mentionsList)
        
        let invalids = hashtagsList.joined(separator: " ")
        set(text: invalids, and: [detector], with: attributes, to: messageLabel)
        let invalidMatches = extractCustomDetectors(for: detector, with: messageLabel)
        XCTAssertEqual(invalidMatches.count, 0)
    }
    
    func testHashtagDetection() {
        let messageLabel: MessageLabel = MessageLabel()
        let detector: DetectorType = DetectorType.hashtag
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: "Hashtag"): "HashtagDetected"]
        
        let text = hashtagsList.joined(separator: " @test ")
        set(text: text, and: [detector], with: attributes, to: messageLabel)
        let matches = extractCustomDetectors(for: detector, with: messageLabel)
        XCTAssertEqual(matches, hashtagsList)
        
        let invalids = mentionsList.joined(separator: " ")
        set(text: invalids, and: [detector], with: attributes, to: messageLabel)
        let invalidMatches = extractCustomDetectors(for: detector, with: messageLabel)
        XCTAssertEqual(invalidMatches.count, 0)
    }

    func testCustomDetection() {
        let shouldPass = ["1234", "1", "09876"]
        let shouldFailed = ["abcd", "a", "!!!", ";"]
        
        let messageLabel: MessageLabel = MessageLabel()
        let detector: DetectorType = DetectorType.custom(try! NSRegularExpression(pattern: "[0-9]+", options: .caseInsensitive))
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: "Custom"): "CustomDetected"]
        
        let text = shouldPass.joined(separator: " ")
        set(text: text, and: [detector], with: attributes, to: messageLabel)
        let matches = extractCustomDetectors(for: detector, with: messageLabel)
        XCTAssertEqual(matches, shouldPass)
        
        let invalids = shouldFailed.joined(separator: " ")
        set(text: invalids, and: [detector], with: attributes, to: messageLabel)
        let invalidMatches = extractCustomDetectors(for: detector, with: messageLabel)
        XCTAssertEqual(invalidMatches.count, 0)
    }
    
    func testSyncBetweenAttributedAndText() {
        let messageLabel: MessageLabel = MessageLabel()
        let expectedText = "Some text"
        messageLabel.attributedText = NSAttributedString(string: expectedText)
        XCTAssertEqual(messageLabel.text, expectedText)
        
        messageLabel.attributedText = nil
        XCTAssertNil(messageLabel.text)
        
        messageLabel.text = "some"
        messageLabel.text = expectedText
        XCTAssertEqual(messageLabel.attributedText?.string, expectedText)
        
        messageLabel.attributedText = NSAttributedString(string: "Not nil")
        messageLabel.text = nil
        XCTAssertNil(messageLabel.attributedText)
    }

    // MARK: - Private helpers API for Detectors

    /**
     Takes a given `DetectorType` and extract matches from a `MessageLabel`

     - Parameters: detector: `DetectorType` that you want to extract
     - Parameters: label: `MessageLabel` where you want to get matches

     - Returns: an array of `String` that contains all matches for the given detector
     */
    private func extractCustomDetectors(for detector: DetectorType, with label: MessageLabel) -> [String] {
        guard let detection = label.rangesForDetectors[detector] else { return [] }
        return detection.compactMap ({ (range, messageChecking) -> String? in
            switch messageChecking {
            case .custom(_, let match):
                return match
            default:
                return nil
            }
        })
    }

    /**
     Simply set text, detectors and attriutes to a given label

     - Parameters: text: `String` that will be applied to the label
     - Parameters: detector: `DetectorType` that you want to apply to the label
     - Parameters: attributes: `[NSAttributedString.Key: Any]` that you want to apply to the label
     - Parameters: label: `MessageLabel` that takes the previous parameters

     */
    private func set(text: String, and detectors: [DetectorType], with attributes: [NSAttributedString.Key: Any], to label: MessageLabel) {
        label.mentionAttributes = attributes
        label.enabledDetectors = detectors
        label.text = text
    }

}

// MARK: - Helpers

private extension MessageLabel {

    var textAttributes: [NSAttributedString.Key: Any] {
        let length = attributedText!.length
        var range = NSRange(location: 0, length: length)
        return attributedText!.attributes(at: 0, effectiveRange: &range)
    }
}
