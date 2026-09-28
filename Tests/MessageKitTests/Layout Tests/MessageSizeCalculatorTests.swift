// MIT License
//
// Copyright (c) 2017-2020 MessageKit
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

// MARK: - MessageSizeCalculatorTests

@MainActor
final class MessageSizeCalculatorTests: XCTestCase {
  // MARK: - Avatar position

  func testNaturalAvatarPositionResolvesToTrailingForTheCurrentSender() {
    let sut = makeSUT()

    let position = sut.calculator.avatarPosition(for: sut.outgoingMessage)

    XCTAssertEqual(position.horizontal, .cellTrailing)
  }

  func testNaturalAvatarPositionResolvesToLeadingForEveryOtherSender() {
    let sut = makeSUT()

    let position = sut.calculator.avatarPosition(for: sut.incomingMessage)

    XCTAssertEqual(position.horizontal, .cellLeading)
  }

  func testAnExplicitAvatarPositionSurvivesTheNaturalResolution() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarPosition = AvatarPosition(horizontal: .cellTrailing, vertical: .cellTop)

    let position = sut.calculator.avatarPosition(for: sut.incomingMessage)

    XCTAssertEqual(position.horizontal, .cellTrailing)
    XCTAssertEqual(position.vertical, .cellTop)
  }

  // MARK: - Avatar size

  func testAvatarSizeFallsBackToTheSenderSpecificSize() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarSize = CGSize(width: 10, height: 20)
    sut.calculator.outgoingAvatarSize = CGSize(width: 30, height: 40)

    XCTAssertEqual(sut.calculator.avatarSize(for: sut.incomingMessage, at: sut.incomingIndexPath), CGSize(width: 10, height: 20))
    XCTAssertEqual(sut.calculator.avatarSize(for: sut.outgoingMessage, at: sut.outgoingIndexPath), CGSize(width: 30, height: 40))
  }

  func testTheLayoutDelegateOverridesTheSenderSpecificAvatarSize() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarSize = CGSize(width: 10, height: 20)
    sut.layoutDelegate.stubbedAvatarSize = CGSize(width: 64, height: 64)

    let size = sut.calculator.avatarSize(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(size, CGSize(width: 64, height: 64))
  }

  // MARK: - Container

  func testTheBaseCalculatorReportsAnEmptyContainer() {
    let sut = makeSUT()

    XCTAssertEqual(sut.calculator.messageContainerSize(for: sut.incomingMessage, at: sut.incomingIndexPath), .zero)
  }

  func testContainerPaddingFollowsTheSender() {
    let sut = makeSUT()
    sut.calculator.incomingMessagePadding = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
    sut.calculator.outgoingMessagePadding = UIEdgeInsets(top: 5, left: 6, bottom: 7, right: 8)

    XCTAssertEqual(
      sut.calculator.messageContainerPadding(for: sut.incomingMessage),
      UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
    XCTAssertEqual(
      sut.calculator.messageContainerPadding(for: sut.outgoingMessage),
      UIEdgeInsets(top: 5, left: 6, bottom: 7, right: 8))
  }

  func testTheContainerMaxWidthRemovesEverythingBesideTheContainer() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarSize = CGSize(width: 30, height: 30)
    sut.calculator.incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 6)
    sut.calculator.incomingAccessoryViewSize = CGSize(width: 20, height: 20)
    sut.calculator.incomingAccessoryViewPadding = HorizontalEdgeInsets(left: 2, right: 3)
    sut.calculator.avatarLeadingTrailingPadding = 5

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.incomingMessage, at: sut.incomingIndexPath)

    // itemWidth less the avatar, the container padding, the accessory view,
    // the accessory padding and the avatar padding.
    XCTAssertEqual(maxWidth, sut.layout.itemWidth - 30 - 10 - 20 - 5 - 5)
  }

  // MARK: - Cell height

  func testTheCellIsAsTallAsTheAvatarWhenNothingElseIsTaller() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarSize = CGSize(width: 30, height: 48)

    let height = sut.calculator.cellContentHeight(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(height, 48)
  }

  func testTheCellGrowsToTheAccessoryViewWhenItIsTheTallest() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarSize = CGSize(width: 30, height: 30)
    sut.calculator.incomingAccessoryViewSize = CGSize(width: 20, height: 120)

    let height = sut.calculator.cellContentHeight(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(height, 120)
  }

  func testTheCellCountsTheContainerPaddingInItsHeight() {
    let sut = makeSUT()
    sut.calculator.incomingAvatarSize = .zero
    sut.calculator.incomingMessagePadding = UIEdgeInsets(top: 7, left: 0, bottom: 11, right: 0)

    let height = sut.calculator.cellContentHeight(for: sut.incomingMessage, at: sut.incomingIndexPath)

    XCTAssertEqual(height, 18)
  }

  // MARK: - Label alignment

  func testCellLabelAlignmentFollowsTheSender() {
    let sut = makeSUT()
    let incoming = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0))
    let outgoing = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2))
    sut.calculator.incomingCellTopLabelAlignment = incoming
    sut.calculator.outgoingCellTopLabelAlignment = outgoing

    XCTAssertEqual(sut.calculator.cellTopLabelAlignment(for: sut.incomingMessage), incoming)
    XCTAssertEqual(sut.calculator.cellTopLabelAlignment(for: sut.outgoingMessage), outgoing)
  }
}

// MARK: - Assistants

extension MessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let layoutDelegate: StubLayoutDelegate
    let calculator: MessageSizeCalculator

    var layout: MessagesCollectionViewFlowLayout { harness.layout }

    /// `MockMessagesDataSource` treats `senders[0]` as the current sender.
    var outgoingMessage: MessageType { harness.dataSource.messages[0] }
    var incomingMessage: MessageType { harness.dataSource.messages[1] }
    var outgoingIndexPath: IndexPath { harness.indexPath(forMessageAt: 0) }
    var incomingIndexPath: IndexPath { harness.indexPath(forMessageAt: 1) }
  }

  // MARK: Private

  private func makeSUT() -> SUT {
    let layoutDelegate = StubLayoutDelegate()
    let harness = CalculatorHarness(
      messages: [
        MockMessage(text: "Outgoing", user: MockMessagesDataSource.outgoingSender, messageId: "001"),
        MockMessage(text: "Incoming", user: MockMessagesDataSource.incomingSender, messageId: "002"),
      ],
      layoutDelegate: layoutDelegate)

    return SUT(
      harness: harness,
      layoutDelegate: layoutDelegate,
      calculator: MessageSizeCalculator(layout: harness.layout))
  }
}
