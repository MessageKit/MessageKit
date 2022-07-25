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
@testable import ChatExample

final class ChatExampleUITests: XCTestCase {
  override func setUp() {
    super.setUp()

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test.
    // Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()

    // In UI tests it’s important to set the initial state
    // - such as interface orientation - required for your tests before they run.
    // The setUp method is a good place to do this.
  }

  func testExampleRuns() {
    // Extremely simple UI test which is designed to run and display the example project
    // This should show if there are any very obvious crashes on render
    let app = XCUIApplication()
    app.tables.staticTexts["Test"].tap()
    XCTAssertTrue(app.collectionViews.staticTexts["Check out this awesome UI library for Chat"].exists)
  }
}
