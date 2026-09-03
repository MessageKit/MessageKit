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

import XCTest
@testable import MessageKit

// MARK: - CellSizeCalculatorTests

@MainActor
final class CellSizeCalculatorTests: XCTestCase {
  func testTheBaseCalculatorSizesEveryItemToZero() {
    let sut = CellSizeCalculator()

    XCTAssertEqual(sut.sizeForItem(at: IndexPath(item: 0, section: 0)), .zero)
    XCTAssertEqual(sut.sizeForItem(at: IndexPath(item: 3, section: 7)), .zero)
  }

  func testTheBaseCalculatorLeavesTheAttributesAlone() {
    let sut = CellSizeCalculator()
    let attributes = MessagesCollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
    attributes.frame = CGRect(x: 1, y: 2, width: 3, height: 4)

    sut.configure(attributes: attributes)

    XCTAssertEqual(attributes.frame, CGRect(x: 1, y: 2, width: 3, height: 4))
    XCTAssertEqual(attributes.messageContainerSize, .zero)
  }

  func testTheCalculatorStartsWithoutALayout() {
    XCTAssertNil(CellSizeCalculator().layout)
  }

  /// The calculator must not keep the layout alive, because every layout owns
  /// its calculators and would otherwise form a cycle.
  func testTheCalculatorHoldsItsLayoutWeakly() {
    let sut = CellSizeCalculator()
    var layout: MessagesCollectionViewFlowLayout? = MessagesCollectionViewFlowLayout()
    sut.layout = layout
    XCTAssertNotNil(sut.layout)

    layout = nil

    XCTAssertNil(sut.layout)
  }

  func testTheMessageCalculatorTakesItsLayoutFromTheInitializer() {
    let layout = MessagesCollectionViewFlowLayout()

    let sut = MessageSizeCalculator(layout: layout)

    XCTAssertIdentical(sut.layout, layout)
    XCTAssertIdentical(sut.messagesLayout, layout)
  }
}
