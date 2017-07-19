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
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. 
        // The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
