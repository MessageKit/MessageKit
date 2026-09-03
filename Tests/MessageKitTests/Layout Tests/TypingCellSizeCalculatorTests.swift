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

// MARK: - TypingCellSizeCalculatorTests

@MainActor
final class TypingCellSizeCalculatorTests: XCTestCase {
  func testTheCalculatorSizesTheCellToZeroWithoutALayout() {
    let sut = TypingCellSizeCalculator()

    XCTAssertEqual(sut.sizeForItem(at: IndexPath(item: 0, section: 0)), .zero)
  }

  func testTheCalculatorSizesTheCellToZeroForAPlainFlowLayout() {
    let sut = TypingCellSizeCalculator()
    let layout = UICollectionViewFlowLayout()
    sut.layout = layout

    XCTAssertEqual(sut.sizeForItem(at: IndexPath(item: 0, section: 0)), .zero)
  }

  func testTheCalculatorTakesTheSizeFromTheLayoutDelegate() {
    let delegate = StubTypingLayoutDelegate()
    delegate.stubbedTypingIndicatorViewSize = CGSize(width: 123, height: 45)
    let harness = CalculatorHarness(messages: [], layoutDelegate: delegate)
    let sut = TypingCellSizeCalculator(layout: harness.layout)

    let size = sut.sizeForItem(at: IndexPath(item: 0, section: 0))

    XCTAssertEqual(size, CGSize(width: 123, height: 45))
  }

  func testTheIndexPathDoesNotChangeTheSize() {
    let delegate = StubTypingLayoutDelegate()
    delegate.stubbedTypingIndicatorViewSize = CGSize(width: 123, height: 45)
    let harness = CalculatorHarness(messages: [], layoutDelegate: delegate)
    let sut = TypingCellSizeCalculator(layout: harness.layout)

    XCTAssertEqual(
      sut.sizeForItem(at: IndexPath(item: 0, section: 0)),
      sut.sizeForItem(at: IndexPath(item: 4, section: 9)))
  }

  func testTheDefaultSizeSpansTheCollectionViewLessItsInsets() {
    let harness = CalculatorHarness(messages: [])
    let sut = TypingCellSizeCalculator(layout: harness.layout)

    let size = sut.sizeForItem(at: IndexPath(item: 0, section: 0))

    let collectionView = harness.controller.messagesCollectionView
    let inset = harness.layout.sectionInset.horizontal + collectionView.contentInset.horizontal
    XCTAssertEqual(size.width, collectionView.bounds.width - inset)
    XCTAssertEqual(size.height, 62)
  }
}

// MARK: - StubTypingLayoutDelegate

/// A layout delegate that answers with a fixed typing indicator size, so the
/// calculator can be checked without the framework default getting in the way.
private final class StubTypingLayoutDelegate: MessagesLayoutDelegate, MessagesDisplayDelegate {
  var stubbedTypingIndicatorViewSize = CGSize.zero

  func typingIndicatorViewSize(for _: MessagesCollectionViewFlowLayout) -> CGSize {
    stubbedTypingIndicatorViewSize
  }
}
