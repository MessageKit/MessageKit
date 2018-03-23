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

class AutocompleteManagerTests: XCTestCase {
    
    var manager: AutocompleteManager?
    var textView: UITextView?
    
    /// A key used for referencing which substrings were autocompletes
    private let NSAttributedAutocompleteKey = NSAttributedStringKey.init("com.messagekit.autocompletekey")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        textView = UITextView()
        manager = AutocompleteManager(for: textView!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        manager = nil
        textView = nil
        
        super.tearDown()
    }
    
    func test_TailHighlight() {
        
        guard let textView = textView else { return XCTAssert(false, "textView nil") }
        guard let manager = manager else { return XCTAssert(false, "manager nil") }
        
        let prefix = "@"
        manager.autocompletePrefixes = [Character(prefix)]
        
        let nonAttributedText = "Some text "
        textView.attributedText = NSAttributedString(string: nonAttributedText + prefix)
        manager.reloadData() // Checks last char
        
        guard var session = manager.currentSession else {
            return XCTAssert(false, "Session nil")
        }
        let autocompleteText = "username"
        session.completion = AutocompleteCompletion(autocompleteText)
        manager.autocomplete(with: session)
        let range = NSRange(location: nonAttributedText.count, length: autocompleteText.count)
        let attributes = textView.attributedText.attributes(at: range.lowerBound, longestEffectiveRange: nil, in: range)
        guard let isAutocompleted = attributes[NSAttributedAutocompleteKey] as? Bool else {
            return XCTAssert(false, attributes.debugDescription)
        }
        XCTAssert(isAutocompleted, attributes.debugDescription)
    }
    
    func test_HeadHighlight() {
        
        guard let textView = textView else { return XCTAssert(false, "textView nil") }
        guard let manager = manager else { return XCTAssert(false, "manager nil") }
        
        let prefix = "@"
        manager.autocompletePrefixes = [Character(prefix)]
        
        let nonAttributedText = prefix
        textView.attributedText = NSAttributedString(string: nonAttributedText + prefix)
        manager.reloadData() // Checks last char
        
        guard var session = manager.currentSession else {
            return XCTAssert(false, "Session nil")
        }
        let autocompleteText = "username"
        session.completion = AutocompleteCompletion(autocompleteText)
        manager.autocomplete(with: session)
        let range = NSRange(location: nonAttributedText.count, length: autocompleteText.count)
        let attributes = textView.attributedText.attributes(at: range.lowerBound, longestEffectiveRange: nil, in: range)
        guard let isAutocompleted = attributes[NSAttributedAutocompleteKey] as? Bool else {
            return XCTAssert(false, attributes.debugDescription)
        }
        XCTAssert(isAutocompleted, attributes.debugDescription)
    }
    
}
