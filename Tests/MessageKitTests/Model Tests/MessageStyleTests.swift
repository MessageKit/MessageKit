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

final class MessageStyleTests: XCTestCase {
  // MARK: Internal

  func testTailCornerImageOrientation() {
    XCTAssertEqual(MessageStyle.TailCorner.bottomRight.imageOrientation, UIImage.Orientation.up)
    XCTAssertEqual(MessageStyle.TailCorner.bottomLeft.imageOrientation, UIImage.Orientation.upMirrored)
    XCTAssertEqual(MessageStyle.TailCorner.topLeft.imageOrientation, UIImage.Orientation.down)
    XCTAssertEqual(MessageStyle.TailCorner.topRight.imageOrientation, UIImage.Orientation.downMirrored)
  }

  func testTailStyleImageNameSuffix() {
    XCTAssertEqual(MessageStyle.TailStyle.curved.imageNameSuffix, "_tail_v2")
    XCTAssertEqual(MessageStyle.TailStyle.pointedEdge.imageNameSuffix, "_tail_v1")
  }

  func testImageNil() {
    XCTAssertNil(MessageStyle.none.image)
  }

  func testImageBubble() {
    let originalData = (MessageStyle.bubble.image ?? UIImage()).pngData()
    let testImage = UIImage(named: "bubble_full", in: assetBundle, compatibleWith: nil)
    let testData = stretch(testImage!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)
  }

  func testImageBubbleOutline() {
    let originalData = (MessageStyle.bubbleOutline(.black).image ?? UIImage()).pngData()
    let testImage = UIImage(named: "bubble_outlined", in: assetBundle, compatibleWith: nil)
    let testData = stretch(testImage!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)
  }

  func testImageBubbleTailCurved() {
    var originalData = (MessageStyle.bubbleTail(.bottomLeft, .curved).image ?? UIImage()).pngData()
    let testImage = UIImage(named: "bubble_full_tail_v2", in: assetBundle, compatibleWith: nil)
    var testData = stretch(transform(image: testImage!, corner: .bottomLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTail(.bottomRight, .curved).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .bottomRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTail(.topLeft, .curved).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTail(.topRight, .curved).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)
  }

  func testImageBubbleTailPointedEdge() {
    var originalData = (MessageStyle.bubbleTail(.bottomLeft, .pointedEdge).image ?? UIImage()).pngData()
    let testImage = UIImage(named: "bubble_full_tail_v1", in: assetBundle, compatibleWith: nil)
    var testData = stretch(transform(image: testImage!, corner: .bottomLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTail(.bottomRight, .pointedEdge).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .bottomRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTail(.topLeft, .pointedEdge).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTail(.topRight, .pointedEdge).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)
  }

  func testImageBubbleTailOutlineCurved() {
    var originalData = (MessageStyle.bubbleTailOutline(.red, .bottomLeft, .curved).image ?? UIImage()).pngData()
    let testImage = UIImage(named: "bubble_outlined_tail_v2", in: assetBundle, compatibleWith: nil)
    var testData = stretch(transform(image: testImage!, corner: .bottomLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTailOutline(.red, .bottomRight, .curved).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .bottomRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTailOutline(.red, .topLeft, .curved).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTailOutline(.red, .topRight, .curved).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)
  }

  func testImageBubbleTailOutlinePointedEdge() {
    var originalData = (MessageStyle.bubbleTailOutline(.red, .bottomLeft, .pointedEdge).image ?? UIImage()).pngData()
    let testImage = UIImage(named: "bubble_outlined_tail_v1", in: assetBundle, compatibleWith: nil)
    var testData = stretch(transform(image: testImage!, corner: .bottomLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTailOutline(.red, .bottomRight, .pointedEdge).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .bottomRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTailOutline(.red, .topLeft, .pointedEdge).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topLeft)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)

    originalData = (MessageStyle.bubbleTailOutline(.red, .topRight, .pointedEdge).image ?? UIImage()).pngData()
    testData = stretch(transform(image: testImage!, corner: .topRight)!).withRenderingMode(.alwaysTemplate).pngData()
    XCTAssertEqual(originalData, testData)
  }

  func testCachesIdenticalOutlineImagesFromCache() {
    let image1 = MessageStyle.bubbleTail(.topLeft, .pointedEdge).image ?? UIImage()
    let image2 = MessageStyle.bubbleTail(.topLeft, .pointedEdge).image ?? UIImage()
    XCTAssertEqual(image1, image2)
    // After clearing cache a new image instance will be loaded from disk
    MessageStyle.bubbleImageCache.removeAllObjects()
    XCTAssertFalse(image1 === MessageStyle.bubbleTail(.topLeft, .pointedEdge).image)
  }

  // MARK: Private

  private let assetBundle = Bundle.messageKitAssetBundle

  private func stretch(_ image: UIImage) -> UIImage {
    let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
    let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
    return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
  }

  private func transform(image: UIImage, corner: MessageStyle.TailCorner) -> UIImage? {
    guard let cgImage = image.cgImage else { return image }
    return UIImage(cgImage: cgImage, scale: image.scale, orientation: corner.imageOrientation)
  }
}
