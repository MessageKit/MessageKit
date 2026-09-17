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
@testable import MessageKit

// MARK: - CalculatorHarness

/// A live `MessagesViewController` that gives a cell size calculator a real
/// collection view to measure against.
///
/// `MessagesCollectionView` keeps its data source and its delegates weakly, so
/// the harness holds them for the length of a test.
@MainActor
final class CalculatorHarness {
  // MARK: Lifecycle

  init(
    messages: [MessageType],
    layoutDelegate: MessagesLayoutDelegate & MessagesDisplayDelegate = StubLayoutDelegate())
  {
    let dataSource = MockMessagesDataSource()
    dataSource.messages = messages
    self.dataSource = dataSource
    self.layoutDelegate = layoutDelegate

    let controller = MessagesViewController()
    controller.messagesCollectionView.messagesDataSource = dataSource
    controller.messagesCollectionView.messagesLayoutDelegate = layoutDelegate
    controller.messagesCollectionView.messagesDisplayDelegate = layoutDelegate
    _ = controller.view
    controller.beginAppearanceTransition(true, animated: false)
    controller.endAppearanceTransition()
    controller.view.layoutIfNeeded()
    self.controller = controller
  }

  // MARK: Internal

  let controller: MessagesViewController
  let dataSource: MockMessagesDataSource
  let layoutDelegate: MessagesLayoutDelegate & MessagesDisplayDelegate

  var layout: MessagesCollectionViewFlowLayout {
    controller.messagesCollectionView.messagesCollectionViewFlowLayout
  }

  /// `MockMessagesDataSource` puts one message in each section, so the message
  /// index is also the section index.
  func indexPath(forMessageAt index: Int) -> IndexPath {
    IndexPath(item: 0, section: index)
  }

  /// Layout attributes an `open func configure(attributes:)` can fill in.
  func attributes(forMessageAt index: Int) -> MessagesCollectionViewLayoutAttributes {
    MessagesCollectionViewLayoutAttributes(forCellWith: indexPath(forMessageAt: index))
  }
}

// MARK: - StubLayoutDelegate

/// A layout delegate that answers with the framework defaults until a test
/// stubs a value.
final class StubLayoutDelegate: MessagesLayoutDelegate, MessagesDisplayDelegate {
  var stubbedAvatarSize: CGSize?

  func avatarSize(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGSize? {
    stubbedAvatarSize
  }
}
