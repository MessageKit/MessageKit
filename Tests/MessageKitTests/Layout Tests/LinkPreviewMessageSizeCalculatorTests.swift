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

import UIKit
import XCTest
@testable import MessageKit

// MARK: - LinkPreviewMessageSizeCalculatorTests

@MainActor
final class LinkPreviewMessageSizeCalculatorTests: XCTestCase {
  // MARK: - Max width

  func testTheContainerIsNeverNarrowerThanThreeQuartersOfTheCollectionView() {
    let sut = makeSUT()
    // A wide avatar would otherwise squeeze the container below the floor.
    sut.calculator.incomingAvatarSize = CGSize(width: 260, height: 30)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.linkMessage, at: sut.linkIndexPath)

    let collectionViewWidth = sut.harness.controller.messagesCollectionView.bounds.width
    XCTAssertEqual(maxWidth, collectionViewWidth * 0.75)
  }

  func testAPlainTextMessageKeepsTheInheritedMaxWidth() {
    let sut = makeSUT()
    let text = TextMessageSizeCalculator(layout: sut.harness.layout)
    text.incomingMessageLabelInsets = sut.calculator.incomingMessageLabelInsets

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.textMessage, at: sut.textIndexPath)

    XCTAssertEqual(maxWidth, text.messageContainerMaxWidth(for: sut.textMessage, at: sut.textIndexPath))
  }

  // MARK: - Container size

  func testTheContainerFillsTheAvailableMaxWidth() {
    let sut = makeSUT()
    let indexPath = sut.linkIndexPath

    let size = sut.calculator.messageContainerSize(for: sut.linkMessage, at: indexPath)

    XCTAssertEqual(size.width, sut.calculator.messageContainerMaxWidth(for: sut.linkMessage, at: indexPath))
  }

  func testTheContainerLeavesRoomForTheThumbnailBesideTheText() {
    let sut = makeSUT()

    let size = sut.calculator.messageContainerSize(for: sut.linkMessage, at: sut.linkIndexPath)

    let insets = sut.calculator.messageLabelInsets(for: sut.linkMessage)
    XCTAssertGreaterThanOrEqual(size.height, LinkPreviewMessageSizeCalculator.imageViewSize + insets.vertical)
  }

  func testALongerTeaserNeedsATallerContainer() {
    let sut = makeSUT()

    let brief = sut.calculator.messageContainerSize(for: sut.linkMessage, at: sut.linkIndexPath)
    let verbose = sut.calculator.messageContainerSize(
      for: sut.longTeaserMessage,
      at: sut.harness.indexPath(forMessageAt: 2))

    XCTAssertGreaterThan(verbose.height, brief.height)
  }

  func testAnEmptyTitleAndTeaserStillLeaveTheThumbnailRoom() {
    let sut = makeSUT()

    let size = sut.calculator.messageContainerSize(for: sut.bareMessage, at: sut.harness.indexPath(forMessageAt: 3))

    let insets = sut.calculator.messageLabelInsets(for: sut.bareMessage)
    XCTAssertGreaterThanOrEqual(size.height, LinkPreviewMessageSizeCalculator.imageViewSize + insets.vertical)
  }

  // MARK: - Attributes

  func testConfigureCopiesThePreviewFontsOntoTheAttributes() {
    let sut = makeSUT()
    sut.calculator.titleFont = .systemFont(ofSize: 17)
    sut.calculator.teaserFont = .systemFont(ofSize: 15)
    sut.calculator.domainFont = .systemFont(ofSize: 13)
    let attributes = sut.harness.attributes(forMessageAt: 0)

    sut.calculator.configure(attributes: attributes)

    XCTAssertEqual(
      attributes.linkPreviewFonts,
      LinkPreviewFonts(
        titleFont: .systemFont(ofSize: 17),
        teaserFont: .systemFont(ofSize: 15),
        domainFont: .systemFont(ofSize: 13)))
  }

  func testTheDefaultPreviewFontsScaleWithTheContentSize() {
    let sut = makeSUT()

    // The initializer runs each default font through a `UIFontMetrics`, so the
    // sizes stay in the footnote and caption ranges rather than the raw values.
    XCTAssertGreaterThan(sut.calculator.titleFont.pointSize, 0)
    XCTAssertGreaterThan(sut.calculator.domainFont.pointSize, 0)
    XCTAssertNotEqual(sut.calculator.titleFont, sut.calculator.domainFont)
  }
}

// MARK: - Assistants

extension LinkPreviewMessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let calculator: LinkPreviewMessageSizeCalculator

    var linkMessage: MessageType { harness.dataSource.messages[0] }
    var textMessage: MessageType { harness.dataSource.messages[1] }
    var longTeaserMessage: MessageType { harness.dataSource.messages[2] }
    var bareMessage: MessageType { harness.dataSource.messages[3] }
    var linkIndexPath: IndexPath { harness.indexPath(forMessageAt: 0) }
    var textIndexPath: IndexPath { harness.indexPath(forMessageAt: 1) }
  }

  // MARK: Private

  private func makeSUT() -> SUT {
    let harness = CalculatorHarness(messages: [
      MockMessage(
        linkItem: makeLinkItem(title: "MessageKit", teaser: "An elegant messages UI library for iOS."),
        user: MockMessagesDataSource.incomingSender,
        messageId: "link"),
      MockMessage(text: "Plain text", user: MockMessagesDataSource.incomingSender, messageId: "text"),
      MockMessage(
        linkItem: makeLinkItem(
          title: "MessageKit",
          teaser: String(repeating: "A teaser that runs on over several lines. ", count: 6)),
        user: MockMessagesDataSource.incomingSender,
        messageId: "longTeaser"),
      MockMessage(
        linkItem: makeLinkItem(title: "", teaser: ""),
        user: MockMessagesDataSource.incomingSender,
        messageId: "bare"),
    ])
    return SUT(harness: harness, calculator: LinkPreviewMessageSizeCalculator(layout: harness.layout))
  }

  private func makeLinkItem(title: String, teaser: String) -> MockLinkItem {
    MockLinkItem(
      text: "https://github.com/MessageKit/MessageKit",
      attributedText: nil,
      url: URL(string: "https://github.com/MessageKit/MessageKit")!,
      title: title,
      teaser: teaser,
      thumbnailImage: UIImage())
  }
}
