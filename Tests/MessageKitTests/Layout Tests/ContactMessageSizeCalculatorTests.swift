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

// MARK: - ContactMessageSizeCalculatorTests

@MainActor
final class ContactMessageSizeCalculatorTests: XCTestCase {
  // MARK: - Label insets

  func testTheNameLabelInsetsFollowTheSender() {
    let sut = makeSUT()
    sut.calculator.incomingMessageNameLabelInsets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
    sut.calculator.outgoingMessageNameLabelInsets = UIEdgeInsets(top: 5, left: 6, bottom: 7, right: 8)

    XCTAssertEqual(
      sut.calculator.contactLabelInsets(for: sut.incomingMessage),
      UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
    XCTAssertEqual(
      sut.calculator.contactLabelInsets(for: sut.outgoingMessage),
      UIEdgeInsets(top: 5, left: 6, bottom: 7, right: 8))
  }

  func testTheContainerMaxWidthRemovesTheNameLabelInsets() {
    let sut = makeSUT()
    let base = MessageSizeCalculator(layout: sut.harness.layout)
      .messageContainerMaxWidth(for: sut.incomingMessage, at: sut.incomingIndexPath)
    sut.calculator.incomingMessageNameLabelInsets = UIEdgeInsets(top: 7, left: 46, bottom: 7, right: 30)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(maxWidth, base - 76)
  }

  // MARK: - Container size

  func testTheContainerAddsTheNameLabelInsetsToTheMeasuredName() {
    let sut = makeSUT()
    sut.calculator.incomingMessageNameLabelInsets = .zero
    let bare = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    sut.calculator.incomingMessageNameLabelInsets = UIEdgeInsets(top: 3, left: 5, bottom: 4, right: 6)
    let padded = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(padded.height, bare.height + 7)
    XCTAssertEqual(padded.width, bare.width + 11)
  }

  func testALongerDisplayNameNeedsAWiderContainer() {
    let sut = makeSUT()

    let short = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)
    let long = sut.calculator.messageContainerSize(for: sut.longNameMessage, at: sut.harness.indexPath(forMessageAt: 2))

    XCTAssertGreaterThan(long.width, short.width)
  }

  func testOnlyTheDisplayNameDecidesTheContainerSize() {
    let sut = makeSUT()

    let plain = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)
    let detailed = sut.calculator.messageContainerSize(for: sut.detailedMessage, at: sut.harness.indexPath(forMessageAt: 3))

    // The phone numbers, the emails and the initials do not take up any room.
    XCTAssertEqual(plain, detailed)
  }

  func testABiggerContactFontNeedsATallerContainer() {
    let sut = makeSUT()
    let regular = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    sut.calculator.contactLabelFont = .systemFont(ofSize: sut.calculator.contactLabelFont.pointSize * 2)
    let doubled = sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertGreaterThan(doubled.height, regular.height)
  }

  // MARK: - Attributes

  func testConfigureCopiesTheContactFontOntoTheAttributes() {
    let sut = makeSUT()
    sut.calculator.contactLabelFont = .systemFont(ofSize: 23)
    let attributes = sut.harness.attributes(forMessageAt: 1)

    sut.calculator.configure(attributes: attributes)

    XCTAssertEqual(attributes.messageLabelFont, .systemFont(ofSize: 23))
  }
}

// MARK: - StubContactItem

private struct StubContactItem: ContactItem {
  var displayName: String
  var initials = ""
  var phoneNumbers: [String] = []
  var emails: [String] = []
}

// MARK: - Assistants

extension ContactMessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let calculator: ContactMessageSizeCalculator

    var outgoingMessage: MessageType { harness.dataSource.messages[0] }
    var incomingMessage: MessageType { harness.dataSource.messages[1] }
    var longNameMessage: MessageType { harness.dataSource.messages[2] }
    var detailedMessage: MessageType { harness.dataSource.messages[3] }
    var incomingIndexPath: IndexPath { harness.indexPath(forMessageAt: 1) }
  }

  // MARK: Private

  private func makeSUT() -> SUT {
    let harness = CalculatorHarness(messages: [
      MockMessage(
        kind: .contact(StubContactItem(displayName: "Ada")),
        user: MockMessagesDataSource.outgoingSender,
        messageId: "outgoing"),
      MockMessage(
        kind: .contact(StubContactItem(displayName: "Ada")),
        user: MockMessagesDataSource.incomingSender,
        messageId: "incoming"),
      MockMessage(
        kind: .contact(StubContactItem(displayName: "Ada Lovelace of Marylebone")),
        user: MockMessagesDataSource.incomingSender,
        messageId: "longName"),
      MockMessage(
        kind: .contact(StubContactItem(
          displayName: "Ada",
          initials: "AL",
          phoneNumbers: ["+421 000 000 000", "+421 111 111 111"],
          emails: ["ada@example.com"])),
        user: MockMessagesDataSource.incomingSender,
        messageId: "detailed"),
    ])
    return SUT(harness: harness, calculator: ContactMessageSizeCalculator(layout: harness.layout))
  }
}
