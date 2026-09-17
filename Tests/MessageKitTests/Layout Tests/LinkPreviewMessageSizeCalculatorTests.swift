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

  func testTheContainerMeasuresPreviewTextInTheWidthLeftBesideTheThumbnail() {
    let sut = makeSUT()
    let message = sut.longTeaserMessage
    let indexPath = sut.harness.indexPath(forMessageAt: 2)
    guard case .linkPreview(let linkItem) = message.kind else {
      XCTFail("Expected a link preview message")
      return
    }

    let size = sut.calculator.messageContainerSize(for: message, at: indexPath)

    let insets = sut.calculator.messageLabelInsets(for: message)
    let previewMaxWidth = size.width
      - (LinkPreviewMessageSizeCalculator.imageViewSize + LinkPreviewMessageSizeCalculator.imageViewMargin + insets.horizontal)
    let fullContainerTextWidth = size.width - insets.horizontal
    let title = linkItem.title ?? ""
    let domain = linkItem.url.host ?? ""
    let titleString = NSAttributedString(string: title, attributes: [.font: sut.calculator.titleFont])
    let teaserString = NSAttributedString(string: linkItem.teaser, attributes: [.font: sut.calculator.teaserFont])
    let domainString = NSAttributedString(string: domain, attributes: [.font: sut.calculator.domainFont])

    let previewTextHeight =
      sut.calculator.labelSize(for: titleString, considering: previewMaxWidth).height
      + sut.calculator.labelSize(for: teaserString, considering: previewMaxWidth).height
      + sut.calculator.labelSize(for: domainString, considering: previewMaxWidth).height
    let fullWidthTextHeight =
      sut.calculator.labelSize(for: titleString, considering: fullContainerTextWidth).height
      + sut.calculator.labelSize(for: teaserString, considering: fullContainerTextWidth).height
      + sut.calculator.labelSize(for: domainString, considering: fullContainerTextWidth).height
    XCTAssertGreaterThan(previewTextHeight, fullWidthTextHeight)

    let text = TextMessageSizeCalculator(layout: sut.harness.layout)
    text.incomingMessageLabelInsets = sut.calculator.incomingMessageLabelInsets
    text.outgoingMessageLabelInsets = sut.calculator.outgoingMessageLabelInsets
    text.messageLabelFont = sut.calculator.messageLabelFont
    let baseHeight = text.messageContainerSize(for: message, at: indexPath).height
    let expectedHeight =
      max(baseHeight + LinkPreviewMessageSizeCalculator.imageViewSize, baseHeight + previewTextHeight)
      + insets.vertical

    XCTAssertEqual(size.height, expectedHeight, accuracy: 0.5)
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
    let contentSizeCategory: UIContentSizeCategory = .accessibilityExtraExtraExtraLarge
    let sut = makeSUT(preferredContentSizeCategory: contentSizeCategory)
    let traits = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)

    XCTAssertEqual(
      sut.calculator.titleFont,
      UIFontMetrics(forTextStyle: .footnote)
        .scaledFont(for: .systemFont(ofSize: 13, weight: .semibold), compatibleWith: traits))
    XCTAssertEqual(
      sut.calculator.domainFont,
      UIFontMetrics(forTextStyle: .caption1)
        .scaledFont(for: .systemFont(ofSize: 12, weight: .semibold), compatibleWith: traits))
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

  private func makeSUT(preferredContentSizeCategory: UIContentSizeCategory = .large) -> SUT {
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
    let traitCollection = UITraitCollection(preferredContentSizeCategory: preferredContentSizeCategory)
    var calculator: LinkPreviewMessageSizeCalculator!
    traitCollection.performAsCurrent {
      calculator = LinkPreviewMessageSizeCalculator(layout: harness.layout)
    }
    return SUT(harness: harness, calculator: calculator)
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
