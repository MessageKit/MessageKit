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

extension MessagesViewController {
  // MARK: Internal

  /// Display time of message by swiping the cell
  func addPanGesture() {
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    guard let panGesture = panGesture else {
      return
    }
    panGesture.delegate = self
    messagesCollectionView.addGestureRecognizer(panGesture)
    messagesCollectionView.clipsToBounds = false
  }

  func removePanGesture() {
    guard let panGesture = panGesture else {
      return
    }
    panGesture.delegate = nil
    self.panGesture = nil
    messagesCollectionView.removeGestureRecognizer(panGesture)
    messagesCollectionView.clipsToBounds = true
  }

  // MARK: Private

  @objc
  private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard let parentView = gesture.view else {
      return
    }

    switch gesture.state {
    case .began, .changed:
      messagesCollectionView.showsVerticalScrollIndicator = false
      let translation = gesture.translation(in: view)
      let minX = -(view.frame.size.width * 0.35)
      let maxX: CGFloat = 0
      var offsetValue = translation.x
      offsetValue = max(offsetValue, minX)
      offsetValue = min(offsetValue, maxX)
      parentView.frame.origin.x = offsetValue
    case .ended:
      messagesCollectionView.showsVerticalScrollIndicator = true
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.8,
        options: .curveEaseOut,
        animations: {
          parentView.frame.origin.x = 0
        },
        completion: nil)
    default:
      break
    }
  }
}

// MARK: - MessagesViewController + UIGestureRecognizerDelegate

extension MessagesViewController: UIGestureRecognizerDelegate {
  /// Check Pan Gesture Direction:
  open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
      return false
    }
    let velocity = panGesture.velocity(in: messagesCollectionView)
    return abs(velocity.x) > abs(velocity.y)
  }
}
