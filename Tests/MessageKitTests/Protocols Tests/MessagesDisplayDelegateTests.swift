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

import Foundation
import XCTest
@testable import MessageKit

// MARK: - MessagesDisplayDelegateTests

final class MessagesDisplayDelegateTests: XCTestCase {
  // MARK: Internal

  override func setUp() {
    super.setUp()

    sut = MockMessagesViewController()
    _ = sut.view
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
    sut.viewDidLoad()
    sut.view.layoutIfNeeded()
  }

  override func tearDown() {
    sut = nil

    super.tearDown()
  }

  func testBackGroundColorDefaultState() {
    XCTAssertEqual(
      sut.backgroundColor(
        for: sut.dataProvider.messages[0],
        at: IndexPath(item: 0, section: 0),
        in: sut.messagesCollectionView),
      UIColor.outgoingMessageBackground)
    XCTAssertNotEqual(
      sut.backgroundColor(
        for: sut.dataProvider.messages[0],
        at: IndexPath(item: 0, section: 0),
        in: sut.messagesCollectionView),
      UIColor.incomingMessageBackground)
    XCTAssertEqual(
      sut.backgroundColor(
        for: sut.dataProvider.messages[1],
        at: IndexPath(item: 1, section: 0),
        in: sut.messagesCollectionView),
      UIColor.incomingMessageBackground)
    XCTAssertNotEqual(
      sut.backgroundColor(
        for: sut.dataProvider.messages[1],
        at: IndexPath(item: 1, section: 0),
        in: sut.messagesCollectionView),
      UIColor.outgoingMessageBackground)
  }

  func testBackgroundColorWithoutDataSource_returnsWhiteForDefault() {
    sut.messagesCollectionView.messagesDataSource = nil
    let backgroundColor = sut.backgroundColor(
      for: sut.dataProvider.messages[0],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)

    XCTAssertEqual(backgroundColor, UIColor.white)
  }

  func testBackgroundColorForMessageWithEmoji_returnsClearForDefault() {
    sut.dataProvider.messages.append(MockMessage(
      emoji: "🤔",
      user: sut.dataProvider.currentUser,
      messageId: "003"))
    let backgroundColor = sut.backgroundColor(
      for: sut.dataProvider.messages[2],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)

    XCTAssertEqual(backgroundColor, .clear)
  }

  func testCellTopLabelDefaultState() {
    XCTAssertNil(sut.dataProvider.cellTopLabelAttributedText(
      for: sut.dataProvider.messages[0],
      at: IndexPath(item: 0, section: 0)))
  }

  func testMessageBottomLabelDefaultState() {
    XCTAssertNil(sut.dataProvider.messageBottomLabelAttributedText(
      for: sut.dataProvider.messages[0],
      at: IndexPath(item: 0, section: 0)))
  }

  func testMessageStyle_returnsBubleTypeForDefault() {
    let type = sut.messageStyle(
      for: sut.dataProvider.messages[0],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)

    let result: Bool
    switch type {
    case .bubble:
      result = true
    default:
      result = false
    }

    XCTAssertTrue(result)
  }

  func testMessageHeaderView_isNotNil() {
    let indexPath = IndexPath(item: 0, section: 1)
    XCTAssert(sut.dataProvider != nil)
    let headerView = sut.messageHeaderView(for: indexPath, in: sut.messagesCollectionView)
    XCTAssertNotNil(headerView)
  }

  // MARK: Private

  private var sut: MockMessagesViewController!
}

// MARK: - TextMessageDisplayDelegateTests

class TextMessageDisplayDelegateTests: XCTestCase {
  // MARK: Internal

  override func setUp() {
    super.setUp()

    sut = MockMessagesViewController()
    _ = sut.view
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
  }

  override func tearDown() {
    sut = nil

    super.tearDown()
  }

  func testTextColorFromCurrentSender_returnsWhiteForDefault() {
    let textColor = sut.textColor(
      for: sut.dataProvider.messages[0],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)

    XCTAssertEqual(textColor, UIColor.outgoingMessageLabel)
  }

  func testTextColorFromYou_returnsDarkTextForDefault() {
    let textColor = sut.textColor(
      for: sut.dataProvider.messages[1],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)

    XCTAssertEqual(textColor, UIColor.incomingMessageLabel)
  }

  func testTextColorWithoutDataSource_returnsDarkTextForDefault() {
    let dataSource = sut.makeDataSource()
    sut.messagesCollectionView.messagesDataSource = dataSource
    let textColor = sut.textColor(
      for: sut.dataProvider.messages[1],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)

    XCTAssertEqual(textColor, UIColor.incomingMessageLabel)
  }

  func testEnableDetectors_returnsEmptyForDefault() {
    let detectors = sut.enabledDetectors(
      for: sut.dataProvider.messages[1],
      at: IndexPath(item: 0, section: 0),
      in: sut.messagesCollectionView)
    let expectedDetectors: [DetectorType] = []

    XCTAssertEqual(detectors, expectedDetectors)
  }

  // MARK: Private

  private var sut: MockMessagesViewController!
}

// MARK: - MockMessagesViewController

private class MockMessagesViewController: MessagesViewController, MessagesDisplayDelegate, MessagesLayoutDelegate {
  // MARK: Internal

  var dataProvider: MockMessagesDataSource!

  func heightForLocation(message _: MessageType, at _: IndexPath, with _: CGFloat, in _: MessagesCollectionView) -> CGFloat {
    200
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    dataProvider = makeDataSource()
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messagesDataSource = dataProvider
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.reloadData()
  }

  func snapshotOptionsForLocation(
    message _: MessageType,
    at _: IndexPath,
    in _: MessagesCollectionView)
    -> LocationMessageSnapshotOptions
  {
    LocationMessageSnapshotOptions()
  }

  // MARK: Fileprivate

  fileprivate func makeDataSource() -> MockMessagesDataSource {
    let dataSource = MockMessagesDataSource()
    dataSource.messages.append(MockMessage(
      text: "Text 1",
      user: dataSource.senders[0],
      messageId: "001"))
    dataSource.messages.append(MockMessage(
      text: "Text 2",
      user: dataSource.senders[1],
      messageId: "002"))

    return dataSource
  }
}
