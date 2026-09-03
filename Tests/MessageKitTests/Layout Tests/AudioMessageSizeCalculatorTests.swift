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

// MARK: - AudioMessageSizeCalculatorTests

@MainActor
final class AudioMessageSizeCalculatorTests: XCTestCase {
  func testAnAudioItemThatFitsKeepsItsOwnSize() {
    let sut = makeSUT(size: CGSize(width: 160, height: 35))

    let size = sut.calculator.messageContainerSize(for: sut.message, at: sut.indexPath)

    XCTAssertEqual(size, CGSize(width: 160, height: 35))
  }

  func testAnOversizedAudioItemIsClampedToTheMaxWidth() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 400))

    let size = sut.calculator.messageContainerSize(for: sut.message, at: sut.indexPath)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.message, at: sut.indexPath)
    XCTAssertEqual(size.width, maxWidth)
  }

  func testAnOversizedAudioItemKeepsItsAspectRatio() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 400))

    let size = sut.calculator.messageContainerSize(for: sut.message, at: sut.indexPath)

    // The item is 10:1, so the clamped width decides the height.
    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.message, at: sut.indexPath)
    XCTAssertEqual(size.height, maxWidth / 10, accuracy: 0.001)
  }

  func testTheDurationDoesNotChangeTheContainerSize() {
    let brief = makeSUT(size: CGSize(width: 160, height: 35), duration: 1)
    let lengthy = makeSUT(size: CGSize(width: 160, height: 35), duration: 600)

    XCTAssertEqual(
      brief.calculator.messageContainerSize(for: brief.message, at: brief.indexPath),
      lengthy.calculator.messageContainerSize(for: lengthy.message, at: lengthy.indexPath))
  }
}

// MARK: - StubAudioItem

private struct StubAudioItem: AudioItem {
  var url = URL(fileURLWithPath: "/dev/null")
  var size: CGSize
  var duration: Float
}

// MARK: - Assistants

extension AudioMessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let calculator: AudioMessageSizeCalculator

    var message: MessageType { harness.dataSource.messages[0] }
    var indexPath: IndexPath { harness.indexPath(forMessageAt: 0) }
  }

  // MARK: Private

  private func makeSUT(size: CGSize, duration: Float = 10) -> SUT {
    let item = StubAudioItem(size: size, duration: duration)
    let harness = CalculatorHarness(messages: [
      MockMessage(kind: .audio(item), user: MockMessagesDataSource.incomingSender, messageId: "audio"),
    ])
    return SUT(harness: harness, calculator: AudioMessageSizeCalculator(layout: harness.layout))
  }
}
