// MIT License
//
// Copyright (c) 2017-2019 MessageKit
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

// MARK: - TypingIndicatorSectionTests

/// Almost every real subclass is its own data source, the way the example app
/// and the Quick Start guide both write it:
///
///     class ChatViewController: MessagesViewController, MessagesDataSource
///
/// These tests pin down where the typing indicator section lands in that shape.
@MainActor
final class TypingIndicatorSectionTests: XCTestCase {
  // MARK: Internal

  func testTheExtraSectionIsTheTypingIndicatorSection() {
    let controller = makeController(messageCount: 3)

    controller.messagesCollectionView.setTypingIndicatorViewHidden(false)

    // Three messages hold sections 0, 1 and 2, so the indicator takes section 3.
    XCTAssertTrue(controller.isSectionReservedForTypingIndicator(3))
  }

  func testTheLastMessageIsNotTheTypingIndicatorSection() {
    let controller = makeController(messageCount: 3)

    controller.messagesCollectionView.setTypingIndicatorViewHidden(false)

    XCTAssertFalse(controller.isSectionReservedForTypingIndicator(2))
  }

  func testTheControllerAndTheLayoutAgreeOnTheSection() {
    let controller = makeController(messageCount: 3)

    controller.messagesCollectionView.setTypingIndicatorViewHidden(false)

    let layout = controller.messagesCollectionView.messagesCollectionViewFlowLayout
    for section in 0 ... 3 {
      XCTAssertEqual(
        controller.isSectionReservedForTypingIndicator(section),
        layout.isSectionReservedForTypingIndicator(section),
        "The controller and the layout disagree about section \(section)")
    }
  }

  func testNoSectionIsReservedWhileTheIndicatorIsHidden() {
    let controller = makeController(messageCount: 3)

    for section in 0 ... 3 {
      XCTAssertFalse(controller.isSectionReservedForTypingIndicator(section))
    }
  }

  // MARK: - The public API

  func testShowingTheIndicatorAddsExactlyOneSection() {
    let controller = makeController(messageCount: 3)

    controller.setTypingIndicatorViewHidden(false, animated: false)

    XCTAssertEqual(controller.messagesCollectionView.numberOfSections, 4)
    XCTAssertFalse(controller.isTypingIndicatorHidden)
  }

  func testHidingTheIndicatorAgainRemovesThatSection() {
    let controller = makeController(messageCount: 3)
    controller.setTypingIndicatorViewHidden(false, animated: false)

    controller.setTypingIndicatorViewHidden(true, animated: false)

    XCTAssertEqual(controller.messagesCollectionView.numberOfSections, 3)
    XCTAssertTrue(controller.isTypingIndicatorHidden)
  }

  func testTogglingTheIndicatorRepeatedlyStaysConsistent() {
    let controller = makeController(messageCount: 3)

    for _ in 0 ..< 5 {
      controller.setTypingIndicatorViewHidden(false, animated: false)
      XCTAssertEqual(controller.messagesCollectionView.numberOfSections, 4)
      controller.setTypingIndicatorViewHidden(true, animated: false)
      XCTAssertEqual(controller.messagesCollectionView.numberOfSections, 3)
    }
  }

  func testTheIndicatorSectionDequeuesTheTypingIndicatorCell() {
    let controller = makeController(messageCount: 3)
    controller.setTypingIndicatorViewHidden(false, animated: false)
    controller.messagesCollectionView.layoutIfNeeded()

    let cell = controller.collectionView(
      controller.messagesCollectionView,
      cellForItemAt: IndexPath(item: 0, section: 3))

    XCTAssertTrue(cell is TypingIndicatorCell, "Got \(type(of: cell)) instead")
  }

  func testTheLastMessageSectionStillDequeuesAMessageCell() {
    let controller = makeController(messageCount: 3)
    controller.setTypingIndicatorViewHidden(false, animated: false)
    controller.messagesCollectionView.layoutIfNeeded()

    let cell = controller.collectionView(
      controller.messagesCollectionView,
      cellForItemAt: IndexPath(item: 0, section: 2))

    XCTAssertTrue(cell is TextMessageCell, "Got \(type(of: cell)) instead")
  }

  func testShowingTheIndicatorWhileAddingAMessageKeepsTheSectionCount() {
    let controller = makeController(messageCount: 3)

    controller.setTypingIndicatorViewHidden(false, animated: false, whilePerforming: {
      controller.messages.append(MockMessage(
        text: "Arrived with the indicator",
        user: MockUser(senderId: "sender_1", displayName: "Sender 1"),
        messageId: "extra"))
      controller.messagesCollectionView.insertSections([3])
    })

    // Four messages plus the indicator.
    XCTAssertEqual(controller.messagesCollectionView.numberOfSections, 5)
  }

  // MARK: Private

  private func makeController(messageCount: Int) -> SelfSourcingController {
    let controller = SelfSourcingController()
    let sender = MockUser(senderId: "sender_1", displayName: "Sender 1")
    controller.messages = (0 ..< messageCount).map {
      MockMessage(text: "Message \($0)", user: sender, messageId: "\($0)")
    }
    // The example app and the Quick Start guide both wire all three to self.
    controller.messagesCollectionView.messagesDataSource = controller
    controller.messagesCollectionView.messagesLayoutDelegate = controller
    controller.messagesCollectionView.messagesDisplayDelegate = controller
    _ = controller.view
    controller.beginAppearanceTransition(true, animated: false)
    controller.endAppearanceTransition()
    controller.view.layoutIfNeeded()
    controller.messagesCollectionView.reloadData()
    return controller
  }
}

// MARK: - SelfSourcingController

@MainActor
private final class SelfSourcingController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate,
  MessagesDisplayDelegate
{
  var messages: [MessageType] = []

  var currentSender: SenderType {
    MockUser(senderId: "sender_1", displayName: "Sender 1")
  }

  func numberOfMessageSections(in _: MessagesCollectionView) -> Int {
    messages.count
  }

  func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
    messages[indexPath.section]
  }
}
