// MIT License
//
// Copyright (c) 2017-2022 MessageKit
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
import UIKit

// MARK: - Typing Indicator API

extension MessagesViewController {
  // MARK: Open

  /// Sets the typing indicator sate by inserting/deleting the `TypingBubbleCell`
  ///
  /// - Parameters:
  ///   - isHidden: A Boolean value that is to be the new state of the typing indicator
  ///   - animated: A Boolean value determining if the insertion is to be animated
  ///   - updates: A block of code that will be executed during `performBatchUpdates`
  ///              when `animated` is `TRUE` or before the `completion` block executes
  ///              when `animated` is `FALSE`
  ///   - completion: A completion block to execute after the insertion/deletion
  @objc
  open func setTypingIndicatorViewHidden(
    _ isHidden: Bool,
    animated: Bool,
    whilePerforming updates: (() -> Void)? = nil,
    completion: ((Bool) -> Void)? = nil)
  {
    guard isTypingIndicatorHidden != isHidden else {
      completion?(false)
      return
    }

    let section = messagesCollectionView.numberOfSections
    messagesCollectionView.setTypingIndicatorViewHidden(isHidden)

    if animated {
      messagesCollectionView.performBatchUpdates({ [weak self] in
        self?.performUpdatesForTypingIndicatorVisability(at: section)
        updates?()
      }, completion: completion)
    } else {
      performUpdatesForTypingIndicatorVisability(at: section)
      updates?()
      completion?(true)
    }
  }

  // MARK: Public

  public var isTypingIndicatorHidden: Bool {
    messagesCollectionView.isTypingIndicatorHidden
  }

  /// A method that by default checks if the section is the last in the
  /// `messagesCollectionView` and that `isTypingIndicatorViewHidden`
  /// is FALSE
  ///
  /// - Parameter section
  /// - Returns: A Boolean indicating if the TypingIndicator should be presented at the given section
  public func isSectionReservedForTypingIndicator(_ section: Int) -> Bool {
    !messagesCollectionView.isTypingIndicatorHidden && section == numberOfSections(in: messagesCollectionView) - 1
  }

  // MARK: Private

  /// Performs a delete or insert on the `MessagesCollectionView` on the provided section
  ///
  /// - Parameter section: The index to modify
  private func performUpdatesForTypingIndicatorVisability(at section: Int) {
    if isTypingIndicatorHidden {
      messagesCollectionView.deleteSections([section - 1])
    } else {
      messagesCollectionView.insertSections([section])
    }
  }
}
