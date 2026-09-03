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

// MARK: - TypingIndicatorTests

@MainActor
final class TypingIndicatorTests: XCTestCase {
  // MARK: - Layout

  func testTheIndicatorHoldsThreeDotsInAHorizontalStack() {
    let sut = TypingIndicator()

    XCTAssertEqual(sut.dots.count, 3)
    XCTAssertEqual(sut.stackView.arrangedSubviews.count, 3)
    XCTAssertEqual(sut.stackView.axis, .horizontal)
    XCTAssertEqual(sut.stackView.alignment, .center)
    XCTAssertEqual(sut.stackView.distribution, .fillEqually)
    XCTAssertTrue(sut.stackView.isDescendant(of: sut))
  }

  func testChangingTheDotColourRepaintsEveryDot() {
    let sut = TypingIndicator()

    sut.dotColor = .red

    XCTAssertEqual(sut.dots.map(\.backgroundColor), Array(repeating: UIColor.red, count: 3))
  }

  func testTheStackViewFillsTheIndicatorOnLayout() {
    let sut = TypingIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 20))

    sut.layoutIfNeeded()

    XCTAssertEqual(sut.stackView.frame, sut.bounds)
  }

  func testTheDotsAreSpacedOnlyOnceTheIndicatorHasWidth() {
    let collapsed = TypingIndicator(frame: .zero)
    let expanded = TypingIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 20))

    collapsed.layoutIfNeeded()
    expanded.layoutIfNeeded()

    XCTAssertEqual(collapsed.stackView.spacing, 0)
    XCTAssertEqual(expanded.stackView.spacing, 5)
  }

  // MARK: - Animation state

  func testTheIndicatorDoesNotAnimateUntilItIsStarted() {
    XCTAssertFalse(TypingIndicator().isAnimating)
  }

  func testStartingAndStoppingFlipsTheAnimatingFlag() {
    let sut = TypingIndicator()

    sut.startAnimating()
    XCTAssertTrue(sut.isAnimating)

    sut.stopAnimating()
    XCTAssertFalse(sut.isAnimating)
  }

  func testStoppingAnIndicatorThatNeverStartedLeavesItAlone() {
    let sut = TypingIndicator()

    sut.stopAnimating()

    XCTAssertFalse(sut.isAnimating)
    XCTAssertNil(sut.dots[0].layer.animationKeys())
  }

  // MARK: - Animation layers

  func testTheFadeAnimationDimsTheDotAndRepeatsForever() {
    let animation = TypingIndicator().opacityAnimationLayer

    XCTAssertEqual(animation.keyPath, "opacity")
    XCTAssertEqual((animation.fromValue as? NSNumber)?.doubleValue, 1)
    XCTAssertEqual((animation.toValue as? NSNumber)?.doubleValue, 0.5)
    XCTAssertEqual(animation.repeatCount, .infinity)
    XCTAssertTrue(animation.autoreverses)
  }

  func testTheBounceAnimationsFollowTheBounceOffset() {
    let sut = TypingIndicator()
    sut.bounceOffset = 10

    let bounce = sut.bounceAnimationLayer
    let initialOffset = sut.initialOffsetAnimationLayer

    XCTAssertEqual(bounce.keyPath, "transform.translation.y")
    XCTAssertEqual((bounce.fromValue as? NSNumber)?.doubleValue, 10)
    XCTAssertEqual((bounce.toValue as? NSNumber)?.doubleValue, -10)
    XCTAssertEqual(bounce.repeatCount, .infinity)
    XCTAssertTrue(bounce.autoreverses)

    XCTAssertEqual((initialOffset.byValue as? NSNumber)?.doubleValue, -10)
    XCTAssertTrue(initialOffset.isRemovedOnCompletion)
  }
}

// MARK: - TypingBubbleTests

@MainActor
final class TypingBubbleTests: XCTestCase {
  func testTheBubbleKeepsTheIndicatorInsideTheContentBubble() {
    let sut = TypingBubble()

    XCTAssertTrue(sut.typingIndicator.isDescendant(of: sut.contentBubble))
    XCTAssertTrue(sut.contentBubble.isDescendant(of: sut))
    XCTAssertTrue(sut.cornerBubble.isDescendant(of: sut))
    XCTAssertTrue(sut.tinyBubble.isDescendant(of: sut))
  }

  func testTheBubbleDoesNotAnimateUntilItIsStarted() {
    XCTAssertFalse(TypingBubble().isAnimating)
  }

  func testStartingPulsesEveryBubbleAndStartsTheIndicator() {
    let sut = TypingBubble()

    sut.startAnimating()

    XCTAssertTrue(sut.isAnimating)
    XCTAssertTrue(sut.typingIndicator.isAnimating)
    XCTAssertEqual(sut.contentBubble.layer.animationKeys()?.isEmpty, false)
    XCTAssertEqual(sut.cornerBubble.layer.animationKeys()?.isEmpty, false)
    XCTAssertEqual(sut.tinyBubble.layer.animationKeys()?.isEmpty, false)
  }

  func testDisablingThePulseStillStartsTheIndicator() {
    let sut = TypingBubble()
    sut.isPulseEnabled = false

    sut.startAnimating()

    XCTAssertTrue(sut.typingIndicator.isAnimating)
    XCTAssertNil(sut.contentBubble.layer.animationKeys())
    XCTAssertNil(sut.cornerBubble.layer.animationKeys())
    XCTAssertNil(sut.tinyBubble.layer.animationKeys())
  }

  func testStoppingRemovesEveryPulseLayer() {
    let sut = TypingBubble()
    sut.startAnimating()

    sut.stopAnimating()

    XCTAssertFalse(sut.isAnimating)
    XCTAssertFalse(sut.typingIndicator.isAnimating)
    XCTAssertEqual(sut.contentBubble.layer.animationKeys() ?? [], [])
    XCTAssertEqual(sut.cornerBubble.layer.animationKeys() ?? [], [])
    XCTAssertEqual(sut.tinyBubble.layer.animationKeys() ?? [], [])
  }

  func testStoppingABubbleThatNeverStartedLeavesItAlone() {
    let sut = TypingBubble()

    sut.stopAnimating()

    XCTAssertFalse(sut.isAnimating)
  }
}
