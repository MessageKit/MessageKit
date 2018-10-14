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

import Quick
import Nimble
@testable import MessageKit

//swiftlint:disable todo
final class MessageLabelSpec: QuickSpec {

    //swiftlint:disable function_body_length
    override func spec() {

        var messageLabel: MessageLabel!

        beforeEach {
            messageLabel = MessageLabel()
        }

//        describe("text recognized by a DetectorType") {
//            context("address detection is enabled") {
//                it("applies addressAttributes to text") {
//                    let expectedColor = UIColor.blue
//                    messageLabel.addressAttributes = [.foregroundColor: expectedColor]
//                    messageLabel.text = "One Infinite Loop Cupertino, CA 95014"
//                    messageLabel.enabledDetectors = [.address]
//                    let attributes = messageLabel.textAttributes
//                    let textColor = attributes[.foregroundColor] as? UIColor
//                    expect(textColor).to(equal(expectedColor))
//                }
//            }
//            context("phone number detection is enabled") {
//                it("applies phoneNumberAttributes to text") {
//                    let expectedFont = UIFont.systemFont(ofSize: 8)
//                    messageLabel.phoneNumberAttributes = [.font: expectedFont]
//                    messageLabel.text = "1-800-555-1234"
//                    messageLabel.enabledDetectors = [.phoneNumber]
//                    let attributes = messageLabel.textAttributes
//                    let textFont = attributes[.font] as? UIFont
//                    expect(textFont).to(equal(expectedFont))
//                }
//            }
//            context("url detection is enabled") {
//                it("applies urlAttributes to text") {
//                    let expectedColor = UIColor.green
//                    messageLabel.urlAttributes = [.foregroundColor: expectedColor]
//                    messageLabel.text = "https://github.com/MessageKit"
//                    messageLabel.enabledDetectors = [.url]
//                    let attributes = messageLabel.textAttributes
//                    let textColor = attributes[.foregroundColor] as? UIColor
//                    expect(textColor).to(equal(expectedColor))
//                }
//            }
//            context("date detection is enabled") {
//                it("applies dateAttributes to text") {
//                    let expectedFont = UIFont.italicSystemFont(ofSize: 22)
//                    messageLabel.dateAttributes = [.font: expectedFont]
//                    messageLabel.text = "Today"
//                    messageLabel.enabledDetectors = [.date]
//                    let attributes = messageLabel.textAttributes
//                    let textFont = attributes[.font] as? UIFont
//                    expect(textFont).to(equal(expectedFont))
//                }
//            }
//        }

        describe("the synchronization between text and attributedText") {
            context("when attributedText is set to a non-nil value") {
                it("updates text with that value") {
                    let expectedText = "Some text"
                    messageLabel.attributedText = NSAttributedString(string: expectedText)
                    expect(messageLabel.text).to(equal(expectedText))
                }
            }
            context("when attributedText is set to nil") {
                it("updates text with the nil value") {
                    messageLabel.text = "Not nil"
                    messageLabel.attributedText = nil
                    expect(messageLabel.text).to(beNil())
                }
            }
            context("when text is set to a non-nil value") {
                it("updates attributedText with that value") {
                    let expectedText = "Some text"
                    messageLabel.text = expectedText
                    expect(messageLabel.attributedText?.string).to(equal(expectedText))
                }
            }
            context("when text is set to a nil value") {
                it("updates attributedText with that value") {
                    messageLabel.attributedText = NSAttributedString(string: "Not nil")
                    messageLabel.text = nil
                    expect(messageLabel.attributedText).to(beNil())
                }
            }
        }

        describe("the labels text drawing rect") {
            context("when textInset is .zero") {
                it("does not inset the text rect") {

                }
            }
            context("when the textInset is not .zero") {
                it("insets the text rect") {

                }
            }
            context("when the textInset is updated") {
                it("updates the text rect") {

                }
            }
        }

        // TODO: - Not working
        // This does not work for MessageLabel, the properties don't sync
        describe("the synchronization between attributedText and format API") {
            context("when font property is set") {
                it("updates the font of attributedText") {

                }
            }
            context("when textColor property is set") {
                it("updates the textColor of attributedText") {

                }
            }
            context("when lineBreakMode property is set") {
                it("updates the lineBreakMode of attributedText") {

                }
            }
            context("when the textAlignment property is set") {
                it("updates the textAlignment of attributedText") {

                }
            }
        }

        describe("updating the attributes of detected text") {
            context("addressAttributes is set to a new value") {
                it("updates ranges for detected addresses") {

                }
            }
            context("phoneNumberAttributes is set to a new value") {
                it("updates ranges for detected phone numbers") {

                }
            }
            context("dateAttributes is set to a new value") {
                it("updates ranges for detected dates") {

                }
            }
            context("urlAttributes is set to a new value") {
                it("updates ranges for detected urls") {

                }
            }
        }

        describe("text dectection of multiple DetectorTypes") {
            context("contains address, date, url, and phone number") {
                it("applies addressAttributes to detected addresses") {

                }
                it("applies phoneNumberAttributes to detected phone numbers") {

                }
                it("applies urlAttributes to detected urls") {

                }
                it("applies dateAttributes to detected dates") {

                }
                it("does not apply attributes to non detected ranges") {
                    
                }
            }
        }

        describe("touch handling for detected text") {
            context("message text contains detected address") {
                context("touch occurs on address") {

                }
                context("touch does not occur on address") {

                }
            }
            context("message text contains detected phone number") {
                context("touch occurs on phone number") {

                }
                context("touch does not occur on phone number") {

                }
            }
            context("message text contains detected url") {
                context("touch occurs on url") {

                }
                context("touch does not occur on url") {

                }
            }
            context("message text contains detected date") {
                context("touch occurs on date") {

                }
                context("touch does not occur on date") {

                }
            }
        }
    }
}

// MARK: - Helpers

fileprivate extension MessageLabel {

    var textAttributes: [NSAttributedString.Key: Any] {
        let length = attributedText!.length
        var range = NSRange(location: 0, length: length)
        return attributedText!.attributes(at: 0, effectiveRange: &range)
    }
}
