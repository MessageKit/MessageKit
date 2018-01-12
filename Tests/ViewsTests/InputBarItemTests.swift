/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import XCTest
@testable import MessageKit

class InputBarItemTests: XCTestCase {
    
    var button: InputBarButtonItem!
    
    override func setUp() {
        super.setUp()
        button = InputBarButtonItem()
    }
    
    override func tearDown() {
        button = nil
        super.tearDown()
    }
    
    func testSetup() {
        XCTAssertEqual(button.contentVerticalAlignment, .center)
        XCTAssertEqual(button.contentHorizontalAlignment, .center)
        XCTAssertEqual(button.imageView?.contentMode, .scaleAspectFit)
        XCTAssertEqual(button.titleColor(for: .normal), UIColor(red: 0, green: 122/255, blue: 1, alpha: 1))
        XCTAssertEqual(button.titleColor(for: .highlighted), UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.3))
        XCTAssertEqual(button.titleColor(for: .disabled), UIColor.lightGray)
        XCTAssertFalse(button.adjustsImageWhenHighlighted)
    }

    func testImagePropertyDefaultNil() {
        XCTAssertNil(button.image)
    }

    func testImagePropertyGettersAndSetters() {
        button.image = UIImage()
        XCTAssertNotNil(button.image)
        XCTAssertEqual(UIImagePNGRepresentation(button.image!), UIImagePNGRepresentation(UIImage()))
    }

    func testIsHighlightedProperty() {
        var onSelectedCalled = false
        button.onSelected { (_) in
            onSelectedCalled = true
        }

        button.isHighlighted = true

        XCTAssert(onSelectedCalled)
    }

    func testIsNotHighlightedProperty() {
        var onDeselectedCalled = false
        button.onDeselected { (_) in
            onDeselectedCalled = true
        }

        button.isHighlighted = false

        XCTAssert(onDeselectedCalled)
    }

    func testIsEnabledProperty() {
        var onEnabledCalled = false
        button.onEnabled { (_) in
            onEnabledCalled = true
        }
        button.isEnabled = true

        XCTAssert(onEnabledCalled)
    }

    func testIsNotEnabledProperty() {
        var onDisabledCalled = false
        button.onDisabled { (_) in
            onDisabledCalled = true
        }
        button.isEnabled = false

        XCTAssert(onDisabledCalled)
    }
}
