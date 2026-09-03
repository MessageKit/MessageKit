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

// MARK: - MediaMessageSizeCalculatorTests

@MainActor
final class MediaMessageSizeCalculatorTests: XCTestCase {
  // MARK: - Photo

  func testAPhotoThatFitsKeepsItsOwnSize() {
    let sut = makeSUT(size: CGSize(width: 120, height: 90))

    let size = sut.calculator.messageContainerSize(for: sut.photoMessage, at: sut.photoIndexPath)

    XCTAssertEqual(size, CGSize(width: 120, height: 90))
  }

  func testAnOversizedPhotoIsClampedToTheMaxWidth() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 2000))

    let size = sut.calculator.messageContainerSize(for: sut.photoMessage, at: sut.photoIndexPath)

    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.photoMessage, at: sut.photoIndexPath)
    XCTAssertEqual(size.width, maxWidth)
  }

  func testAnOversizedPhotoKeepsItsAspectRatio() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 2000))

    let size = sut.calculator.messageContainerSize(for: sut.photoMessage, at: sut.photoIndexPath)

    // The item is 2:1, so the clamped width decides the height.
    let maxWidth = sut.calculator.messageContainerMaxWidth(for: sut.photoMessage, at: sut.photoIndexPath)
    XCTAssertEqual(size.height, maxWidth / 2, accuracy: 0.001)
  }

  // MARK: - Video

  func testAVideoIsSizedTheSameWayAsAPhoto() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 2000))

    let photo = sut.calculator.messageContainerSize(for: sut.photoMessage, at: sut.photoIndexPath)
    let video = sut.calculator.messageContainerSize(for: sut.videoMessage, at: sut.videoIndexPath)

    XCTAssertEqual(photo, video)
  }

  // MARK: - Max width

  func testAWiderAvatarLeavesLessRoomForThePhoto() {
    let sut = makeSUT(size: CGSize(width: 4000, height: 2000))
    let roomy = sut.calculator.messageContainerSize(for: sut.photoMessage, at: sut.photoIndexPath)

    sut.calculator.incomingAvatarSize = CGSize(width: 90, height: 90)
    let tight = sut.calculator.messageContainerSize(for: sut.photoMessage, at: sut.photoIndexPath)

    XCTAssertEqual(tight.width, roomy.width - 60)
  }
}

// MARK: - StubMediaItem

private struct StubMediaItem: MediaItem {
  var url: URL?
  var image: UIImage?
  var placeholderImage = UIImage()
  var size: CGSize
}

// MARK: - Assistants

extension MediaMessageSizeCalculatorTests {
  // MARK: Fileprivate

  @MainActor
  fileprivate struct SUT {
    let harness: CalculatorHarness
    let calculator: MediaMessageSizeCalculator

    var photoMessage: MessageType { harness.dataSource.messages[0] }
    var videoMessage: MessageType { harness.dataSource.messages[1] }
    var photoIndexPath: IndexPath { harness.indexPath(forMessageAt: 0) }
    var videoIndexPath: IndexPath { harness.indexPath(forMessageAt: 1) }
  }

  // MARK: Private

  private func makeSUT(size: CGSize) -> SUT {
    let item = StubMediaItem(size: size)
    let harness = CalculatorHarness(messages: [
      MockMessage(kind: .photo(item), user: MockMessagesDataSource.incomingSender, messageId: "photo"),
      MockMessage(kind: .video(item), user: MockMessagesDataSource.incomingSender, messageId: "video"),
    ])
    return SUT(harness: harness, calculator: MediaMessageSizeCalculator(layout: harness.layout))
  }
}
