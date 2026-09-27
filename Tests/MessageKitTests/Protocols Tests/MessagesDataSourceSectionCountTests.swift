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

// MARK: - MessagesDataSourceSectionCountTests

/// `numberOfSections(in:)` was renamed to `numberOfMessageSections(in:)`, and
/// both names still resolve. These pin down all three conformance shapes,
/// including the one that implements neither.
@MainActor
final class MessagesDataSourceSectionCountTests: XCTestCase {
  // MARK: Internal

  func testADataSourceOnTheNewNameReportsItsOwnCount() {
    let dataSource = ModernDataSource()
    dataSource.count = 7

    XCTAssertEqual(dataSource.numberOfMessageSections(in: makeCollectionView()), 7)
  }

  /// The point of the deprecation: a data source written before the rename
  /// keeps working through the bridging default.
  func testADataSourceOnTheOldNameStillReachesTheFramework() {
    let dataSource = LegacyDataSource()
    dataSource.count = 4

    XCTAssertEqual(dataSource.numberOfMessageSections(in: makeCollectionView()), 4)
  }

  /// Two defaults that called each other would recurse until the stack ran out.
  /// The deprecated default is a leaf instead, so this returns rather than
  /// crashing.
  func testADataSourceOnNeitherNameReportsNoSectionsInsteadOfRecursing() {
    let dataSource = EmptyDataSource()

    XCTAssertEqual(dataSource.numberOfMessageSections(in: makeCollectionView()), 0)
  }

  func testTheControllerCountsTheMessageSectionsOfALegacyDataSource() {
    let dataSource = LegacyDataSource()
    dataSource.count = 4
    let controller = makeController(dataSource: dataSource)

    XCTAssertEqual(controller.numberOfSections(in: controller.messagesCollectionView), 4)
  }

  func testTheControllerAddsTheIndicatorSectionForALegacyDataSource() {
    let dataSource = LegacyDataSource()
    dataSource.count = 4
    let controller = makeController(dataSource: dataSource)

    controller.messagesCollectionView.setTypingIndicatorViewHidden(false)

    XCTAssertEqual(controller.numberOfSections(in: controller.messagesCollectionView), 5)
  }

  // MARK: Private

  /// `MessagesCollectionView` keeps its data source and delegates weakly.
  private var retained: [Any] = []

  private func makeCollectionView() -> MessagesCollectionView {
    MessagesCollectionView()
  }

  private func makeController(dataSource: some MessagesDataSource) -> MessagesViewController {
    let controller = MessagesViewController()
    let layoutDelegate = SectionCountLayoutDelegate()
    retained.append(layoutDelegate)
    retained.append(dataSource)
    controller.messagesCollectionView.messagesDataSource = dataSource
    controller.messagesCollectionView.messagesLayoutDelegate = layoutDelegate
    controller.messagesCollectionView.messagesDisplayDelegate = layoutDelegate
    _ = controller.view
    return controller
  }
}

// MARK: - ModernDataSource

/// Implements only the new name.
private final class ModernDataSource: MessagesDataSource {
  var count = 0

  var currentSender: SenderType {
    MockUser(senderId: "sender_1", displayName: "Sender 1")
  }

  func numberOfMessageSections(in _: MessagesCollectionView) -> Int {
    count
  }

  func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
    MockMessage(text: "Message", user: MockUser(senderId: "sender_1", displayName: "Sender 1"), messageId: "\(indexPath.section)")
  }
}

// MARK: - LegacyDataSource

/// Implements only the deprecated name, the way every data source written
/// before the rename does.
private final class LegacyDataSource: MessagesDataSource {
  var count = 0

  var currentSender: SenderType {
    MockUser(senderId: "sender_1", displayName: "Sender 1")
  }

  @available(*, deprecated)
  func numberOfSections(in _: MessagesCollectionView) -> Int {
    count
  }

  func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
    MockMessage(text: "Message", user: MockUser(senderId: "sender_1", displayName: "Sender 1"), messageId: "\(indexPath.section)")
  }
}

// MARK: - EmptyDataSource

/// Implements neither name, which is the shape that would recurse.
private final class EmptyDataSource: MessagesDataSource {
  var currentSender: SenderType {
    MockUser(senderId: "sender_1", displayName: "Sender 1")
  }

  func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
    MockMessage(text: "Message", user: MockUser(senderId: "sender_1", displayName: "Sender 1"), messageId: "\(indexPath.section)")
  }
}

// MARK: - SectionCountLayoutDelegate

private final class SectionCountLayoutDelegate: MessagesLayoutDelegate, MessagesDisplayDelegate { }
