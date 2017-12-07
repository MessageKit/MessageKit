/*
 MIT License

 Copyright (c) 2017 MessageKit

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

import Quick
import Nimble
@testable import MessageKit

final class MessageLabelSpec: QuickSpec {

    //swiftlint:disable function_body_length
    override func spec() {

        var messageLabel: MessageLabel!

        beforeEach {
            messageLabel = MessageLabel()
        }

        describe("text recognized by a DetectorType") {
            context("address detection is enabled") {
                it("applies addressAttributes to text") {
                    let expectedColor = UIColor.blue
                    messageLabel.addressAttributes = [.foregroundColor: expectedColor]
                    messageLabel.text = "One Infinite Loop Cupertino, CA 95014"
                    messageLabel.enabledDetectors = [.address]
                    var attributes = messageLabel.textAttributes
                    var textColor = attributes?[.foregroundColor] as? UIColor
                    expect(textColor).toNot(beNil())
                    expect(textColor).to(equal(expectedColor))
                }
            }
            context("phone number detection is enabled") {
                it("applies phoneNumberAttributes to text") {
                    let expectedFont = UIFont.systemFont(ofSize: 8)
                    messageLabel.phoneNumberAttributes = [.font: expectedFont]
                    messageLabel.text = "1-800-555-1234"
                    messageLabel.enabledDetectors = [.phoneNumber]
                    let attributes = messageLabel.textAttributes
                    let textFont = attributes?[.font] as? UIFont
                    expect(textFont).toNot(beNil())
                    expect(textFont).to(equal(expectedFont))
                }
            }
            context("url detection is enabled") {
                it("applies urlAttributes to text") {
                    let expectedColor = UIColor.green
                    messageLabel.urlAttributes = [.foregroundColor: expectedColor]
                    messageLabel.text = "https://github.com/MessageKit"
                    messageLabel.enabledDetectors = [.url]
                    let attributes = messageLabel.textAttributes
                    let textColor = attributes?[.foregroundColor] as? UIColor
                    expect(textColor).toNot(beNil())
                    expect(textColor).to(equal(expectedColor))
                }
            }
            context("date detection is enabled") {
                it("applies dateAttributes to text") {
                    let expectedFont = UIFont.italicSystemFont(ofSize: 22)
                    messageLabel.dateAttributes = [.font: expectedFont]
                    messageLabel.text = "Today"
                    messageLabel.enabledDetectors = [.date]
                    let attributes = messageLabel.textAttributes
                    let textFont = attributes?[.font] as? UIFont
                    expect(textFont).toNot(beNil())
                    expect(textFont).to(equal(expectedFont))
                }
            }
        }
    }
}

// MARK: - Helpers

fileprivate extension MessageLabel {

    var textAttributes: [NSAttributedStringKey: Any]? {
        let length = attributedText!.length
        var range = NSRange(location: 0, length: length)
        return attributedText?.attributes(at: 0, effectiveRange: &range)
    }
}
