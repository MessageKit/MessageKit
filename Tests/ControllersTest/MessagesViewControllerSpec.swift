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

final class MessagesViewControllerSpec: QuickSpec {

    override func spec() {

        var controller: MessagesViewController!

        beforeEach {
            controller = MessagesViewController()
        }

        describe("default property values") {

            it("does not scroll to bottom on first layout") {
                expect(controller.scrollsToBottomOnFirstLayout).to(beFalse())
            }

            it("does not scroll to bottom on begins editing") {
                expect(controller.scrollsToBottomOnKeybordBeginsEditing).to(beFalse())
            }

            it("can become first responder") {
                expect(controller.canBecomeFirstResponder).to(beTrue())
            }

            it("does not autorotate") {
                expect(controller.shouldAutorotate).to(beFalse())
            }

            it("has an inputAccessoryView of type MessageInputBar") {
                expect(controller.inputAccessoryView).toNot(beNil())
                expect(controller.inputAccessoryView is MessageInputBar).to(beTrue())
            }

            it("has a MessagesCollectionView") {
                expect(controller.messagesCollectionView).toNot(beNil())
            }
        }

        describe("after viewDidLoad") {

            beforeEach {
                controller.viewDidLoad()
            }

            it("does not automatically adjust scroll view insets") {
                expect(controller.automaticallyAdjustsScrollViewInsets).to(beFalse())
            }

            it("includes opaque bars in extended layout") {
                expect(controller.extendedLayoutIncludesOpaqueBars).to(beTrue())
            }

            it("has a background color of white") {
                expect(controller.view.backgroundColor).to(be(UIColor.white))
            }

            describe("messagesCollectionView properties") {

                var messagesCollectionView: MessagesCollectionView!

                beforeEach {
                    messagesCollectionView = controller.messagesCollectionView
                }

                it("uses interactive keyboard dismissal") {
                    expect(messagesCollectionView.keyboardDismissMode).to(equal(UIScrollViewKeyboardDismissMode.interactive))
                }

                it("it always bounces vertical") {
                    expect(messagesCollectionView.alwaysBounceVertical).to(beTrue())
                }
            }
        }
    }
}
