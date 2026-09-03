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

import CoreLocation
import XCTest
@testable import MessageKit

// MARK: - LocationMessageSizeCalculatorTests

@MainActor
final class LocationMessageSizeCalculatorTests: XCTestCase {
  func testALocationItemThatFitsKeepsItsOwnSize() {
    let sut = makeSUT(size: CGSize(width: 240, height: 240))

    let size = sut.calculator.messageContainerSize(for: sut.message, at: sut.indexPath)

    XCTAssertEqual(size, CGSize(width: 240, height: 240))
  }

  func testAnOversizedLocationItemIsClampedToTheMaxWidth() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 4000))

    let size = sut.calculator.messageContainerSize(for: sut.message, at: sut.indexPath)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.message, at: sut.indexPath)
    XCTAssertEqual(size.width, maxWidth)
  }

  func testAnOversizedLocationItemKeepsItsAspectRatio() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 1000))

    let size = sut.calculator.messageContainerSize(for: sut.message, at: sut.indexPath)

    // The item is 4:1, so the clamped width decides the height.
    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.message, at: sut.indexPath)
    XCTAssertEqual(size.height, maxWidth / 4, accuracy: 0.001)
  }

  func testTheCoordinateDoesNotChangeTheContainerSize() {
    let size = CGSize(width: 240, height: 240)
    let equator = makeSUT(size: size, location: CLLocation(latitude: 0, longitude: 0))
    let arctic = makeSUT(size: size, location: CLLocation(latitude: 78.22, longitude: 15.65))

    XCTAssertEqual(
      equator.calculator.messageContainerSize(for: equator.message, at: equator.indexPath),
      arctic.calculator.messageContainerSize(for: arctic.message, at: arctic.indexPath))
  }
}

// MARK: - StubLocationItem

private struct StubLocationItem: LocationItem {
  var location: CLLocation
  var size: CGSize
}

// MARK: - Assistants

extension LocationMessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let calculator: LocationMessageSizeCalculator

    var message: MessageType { harness.dataSource.messages[0] }
    var indexPath: IndexPath { harness.indexPath(forMessageAt: 0) }
  }

  // MARK: Private

  private func makeSUT(size: CGSize, location: CLLocation = CLLocation(latitude: 48.14, longitude: 17.10)) -> SUT {
    let item = StubLocationItem(location: location, size: size)
    let harness = CalculatorHarness(messages: [
      MockMessage(kind: .location(item), user: MockMessagesDataSource.incomingSender, messageId: "location"),
    ])
    return SUT(harness: harness, calculator: LocationMessageSizeCalculator(layout: harness.layout))
  }
}
