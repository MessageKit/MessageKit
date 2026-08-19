//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://messagekit.github.io
//
//
//  GitHub
//  https://github.com/MessageKit/MessageKit
//
//
//  License
//  Copyright (c) 2016-present Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest

final class ChatExampleUITests: XCTestCase {
  // MARK: Internal

  override func setUp() {
    super.setUp()

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
  }

  /// Smoke test: open every example in turn and check that it renders at least one
  /// message. This catches very obvious crashes on render.
  func testEveryExampleRenders() {
    let app = XCUIApplication()
    app.launch()

    for example in Self.chatExamples {
      let row = app.tables.staticTexts[example]
      XCTAssertTrue(row.waitForExistence(timeout: 10), "Missing row for \(example)")
      row.tap()

      let collectionView = app.collectionViews.firstMatch
      XCTAssertTrue(collectionView.waitForExistence(timeout: 10), "\(example) did not render a collection view")
      XCTAssertGreaterThan(collectionView.cells.count, 0, "\(example) rendered no messages")

      app.navigationBars.buttons.firstMatch.tap()
    }
  }

  // MARK: Private

  /// The example rows that present a chat. Kept in sync with `LaunchViewController.Row`.
  private static let chatExamples = [
    "Basic Example",
    "Advanced Example",
    "Autocomplete Example",
    "Embedded Example",
    "Custom Layout Example",
    "Subview Example",
    "Custom InputBar Example",
    "SwiftUI Example",
  ]
}
