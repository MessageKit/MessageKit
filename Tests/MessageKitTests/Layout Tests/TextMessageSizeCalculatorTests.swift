// MIT License
//
// Copyright (c) 2017-2026 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
@testable import MessageKit

// MARK: - TextMessageSizeCalculatorTests

@MainActor
final class TextMessageSizeCalculatorTests: XCTestCase {
  // MARK: - Label insets

  func testTheLabelInsetsFollowTheSender() {
    let sut = makeSUT()
    sut.calculator.incomingMessageLabelInsets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
    sut.calculator.outgoingMessageLabelInsets = UIEdgeInsets(top: 5, left: 6, bottom: 7, right: 8)

    XCTAssertEqual(
      sut.calculator.messageLabelInsets(for: sut.incomingMessage),
      UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
    XCTAssertEqual(
      sut.calculator.messageLabelInsets(for: sut.outgoingMessage),
      UIEdgeInsets(top: 5, left: 6, bottom: 7, right: 8))
  }

  func testTheContainerMaxWidthRemovesTheLabelInsets() {
    let sut = makeSUT()
    let base = MessageSizeCalculator(layout: sut.harness.layout)
      .messageContainerMaxWidth(for: sut.incomingMessage, at: sut.incomingIndexPath)
    sut.calculator.incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(maxWidth, base - 32)
  }

  // MARK: - Container size

  func testTheContainerAddsTheLabelInsetsToTheMeasuredText() {
    let sut = makeSUT()
    sut.calculator.incomingMessageLabelInsets = .zero
    let bare = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    sut.calculator.incomingMessageLabelInsets = UIEdgeInsets(top: 3, left: 5, bottom: 4, right: 6)
    let padded = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    // A short text fits on one line either way, so the container grows by
    // exactly the insets.
    XCTAssertEqual(padded.height, bare.height + 7)
    XCTAssertEqual(padded.width, bare.width + 11)
  }

  func testALongerTextNeedsATallerContainer() {
    let sut = makeSUT()
    let short = sut.calculator.messageContainerSize(for: sut.shortMessage, at: sut.harness.indexPath(forMessageAt: 2))
    let long = sut.calculator.messageContainerSize(for: sut.longMessage, at: sut.harness.indexPath(forMessageAt: 3))

    XCTAssertGreaterThan(long.height, short.height)
  }

  func testALongTextWrapsInsteadOfOverflowingTheContainer() {
    let sut = makeSUT()
    let indexPath = sut.harness.indexPath(forMessageAt: 3)

    let size = sut.calculator.messageContainerSize(for: sut.longMessage, at: indexPath)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.longMessage, at: indexPath)
    let insets = sut.calculator.messageLabelInsets(for: sut.longMessage)
    XCTAssertLessThanOrEqual(size.width, maxWidth + insets.horizontal)
  }

  func testABiggerLabelFontNeedsATallerContainer() {
    let sut = makeSUT()
    let indexPath = sut.harness.indexPath(forMessageAt: 2)
    let regular = sut.calculator.messageContainerSize(for: sut.shortMessage, at: indexPath)

    sut.calculator.messageLabelFont = .systemFont(ofSize: sut.calculator.messageLabelFont.pointSize * 2)
    let doubled = sut.calculator.messageContainerSize(for: sut.shortMessage, at: indexPath)

    XCTAssertGreaterThan(doubled.height, regular.height)
  }

  func testAnAttributedTextIsMeasuredWithItsOwnAttributes() {
    let sut = makeSUT()
    let small = MockMessage(
      attributedText: NSAttributedString(string: "Attributed", attributes: [.font: UIFont.systemFont(ofSize: 12)]),
      user: MockMessagesDataSource.incomingSender,
      messageId: "small")
    let large = MockMessage(
      attributedText: NSAttributedString(string: "Attributed", attributes: [.font: UIFont.systemFont(ofSize: 36)]),
      user: MockMessagesDataSource.incomingSender,
      messageId: "large")
    let indexPath = sut.harness.indexPath(forMessageAt: 1)

    let smallSize = sut.calculator.messageContainerSize(for: small, at: indexPath)
    let largeSize = sut.calculator.messageContainerSize(for: large, at: indexPath)

    XCTAssertGreaterThan(largeSize.height, smallSize.height)
    XCTAssertGreaterThan(largeSize.width, smallSize.width)
  }

  func testAnEmojiIsMeasuredLikeText() {
    let sut = makeSUT()
    let emoji = MockMessage(emoji: "👍", user: MockMessagesDataSource.incomingSender, messageId: "emoji")

    let size = sut.calculator.messageContainerSize(for: emoji, at: sut.harness.indexPath(forMessageAt: 1))

    XCTAssertGreaterThan(size.width, 0)
    XCTAssertGreaterThan(size.height, 0)
  }

  // MARK: - Attributes

  func testConfigureCopiesTheLabelInsetsAndTheFontOntoTheAttributes() {
    let sut = makeSUT()
    sut.calculator.incomingMessageLabelInsets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
    sut.calculator.messageLabelFont = .systemFont(ofSize: 21)
    let attributes = sut.harness.attributes(forMessageAt: 1)

    sut.calculator.configure(attributes: attributes)

    XCTAssertEqual(attributes.messageLabelInsets, UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
    XCTAssertEqual(attributes.messageLabelFont, .systemFont(ofSize: 21))
  }

  func testConfigureTakesTheFontFromAnAttributedText() {
    let font = UIFont.systemFont(ofSize: 27)
    let sut = makeSUT(extraMessages: [
      MockMessage(
        attributedText: NSAttributedString(string: "Attributed", attributes: [.font: font]),
        user: MockMessagesDataSource.incomingSender,
        messageId: "attributed"),
    ])
    sut.calculator.messageLabelFont = .systemFont(ofSize: 21)
    let attributes = sut.harness.attributes(forMessageAt: 4)

    sut.calculator.configure(attributes: attributes)

    XCTAssertEqual(attributes.messageLabelFont, font)
  }

  func testConfigureKeepsTheCalculatorFontForAnEmptyAttributedText() {
    let sut = makeSUT(extraMessages: [
      MockMessage(
        attributedText: NSAttributedString(string: ""),
        user: MockMessagesDataSource.incomingSender,
        messageId: "empty"),
    ])
    sut.calculator.messageLabelFont = .systemFont(ofSize: 21)
    let attributes = sut.harness.attributes(forMessageAt: 4)

    sut.calculator.configure(attributes: attributes)

    XCTAssertEqual(attributes.messageLabelFont, .systemFont(ofSize: 21))
  }
}

// MARK: - Assistants

extension TextMessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let calculator: TextMessageSizeCalculator

    var outgoingMessage: MessageType { harness.dataSource.messages[0] }
    var incomingMessage: MessageType { harness.dataSource.messages[1] }
    var shortMessage: MessageType { harness.dataSource.messages[2] }
    var longMessage: MessageType { harness.dataSource.messages[3] }
    var outgoingIndexPath: IndexPath { harness.indexPath(forMessageAt: 0) }
    var incomingIndexPath: IndexPath { harness.indexPath(forMessageAt: 1) }
  }

  // MARK: Private

  private func makeSUT(extraMessages: [MessageType] = []) -> SUT {
    let messages: [MessageType] = [
      MockMessage(text: "Outgoing", user: MockMessagesDataSource.outgoingSender, messageId: "001"),
      MockMessage(text: "Incoming", user: MockMessagesDataSource.incomingSender, messageId: "002"),
      MockMessage(text: "Short", user: MockMessagesDataSource.incomingSender, messageId: "003"),
      MockMessage(
        text: String(repeating: "A long message that has to wrap over several lines. ", count: 8),
        user: MockMessagesDataSource.incomingSender,
        messageId: "004"),
    ]
    let harness = CalculatorHarness(messages: messages + extraMessages)
    return SUT(harness: harness, calculator: TextMessageSizeCalculator(layout: harness.layout))
  }
}
