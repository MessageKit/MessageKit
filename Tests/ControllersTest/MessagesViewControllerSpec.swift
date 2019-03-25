/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

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
import InputBarAccessoryView
@testable import MessageKit

//swiftlint:disable function_body_length
final class MessagesViewControllerSpec: QuickSpec {

    override func spec() {

        var controller: MessagesViewController!

        beforeEach {
            controller = MessagesViewController()
        }

        describe("default property values") {
            context("after initialization") {
                it("sets scrollsToBottomOnKeyboardBeginsEditing to false") {
                    expect(controller.scrollsToBottomOnKeyboardBeginsEditing).to(beFalse())
                }
                it("sets canBecomeFirstResponder to true") {
                    expect(controller.canBecomeFirstResponder).to(beTrue())
                }
                it("sets shouldAutorotate to false") {
                    expect(controller.shouldAutorotate).to(beFalse())
                }
                it("sets inputAccessoryView to the messageInputBar") {
                    expect(controller.inputAccessoryView).toNot(beNil())
                }
                it("has a MessagesCollectionView") {
                    expect(controller.messagesCollectionView).toNot(beNil())
                }
                it("sets the CollectionView's layout to be an instance of MessagesCollectionViewFlowLayout") {
                    expect(controller.messagesCollectionView.collectionViewLayout).to(beAnInstanceOf(MessagesCollectionViewFlowLayout.self))
                }
            }
            context("after viewDidLoad") {
                beforeEach {
                    controller.view.layoutIfNeeded()
                }
                it("sets automaticallyAdjustsScrollViewInsets to false") {
                    expect(controller.automaticallyAdjustsScrollViewInsets).to(beFalse())
                }
                it("sets extendedLayoutIncludesOpaqueBars to true") {
                    expect(controller.extendedLayoutIncludesOpaqueBars).to(beTrue())
                }
                it("sets the background color to be white") {
                    expect(controller.view.backgroundColor).to(be(UIColor.white))
                }
                it("sets keyboardDismissMode to .interactive") {
                    let dismissMode = controller.messagesCollectionView.keyboardDismissMode
                    expect(dismissMode).to(equal(UIScrollView.KeyboardDismissMode.interactive))
                }
                it("sets alwaysBounceVertical to true") {
                    expect(controller.messagesCollectionView.alwaysBounceVertical).to(beTrue())
                }
            }
        }

        describe("subviews setup") {
            it("should add messagesCollectionView as a subview of root view") {
                let subviews = controller.view.subviews
                let hasView = subviews.contains(controller.messagesCollectionView)
                expect(hasView).to(beTrue())
            }
        }

        describe("delegate and datasource setup") {
            beforeEach {
                controller.view.layoutIfNeeded()
            }
            it("should set messagesCollectionView.dataSource") {
                let delegate = controller.messagesCollectionView.delegate
                expect(delegate).to(be(controller))
            }
            it("should set messagesCollectionView.delegate") {
                let dataSource = controller.messagesCollectionView.dataSource
                expect(dataSource).to(be(controller))
            }
        }

        describe("the top contentInset") {
            context("when controller is root view controller") {

            }
            context("when controller is nested in a UINavigationController") {

            }
        }

        describe("the bottom contentInset") {
            context("when keyboard is showing") {
                it("should be the height of the MessageInputBar + keyboard") {

                }
            }
            context("when keyboard is not showing") {
                it("should be the height of the MessageInputBar") {

                }
            }
        }

        describe("scrolling behavior when keyboard begins editing") {
            context("scrollsToBottomOnKeyboardBeginsEditing is true") {
                it("should scroll to bottom") {

                }
            }
            context("scrollsToBottomOnKeyboardBeginsEditing is false") {
                it("should not scroll to bottom") {

                }
            }
        }

        describe("calling messagesCollectionView.scrollToBottom()") {
            context("all messages are visible") {
                it("should scroll to bottom") {

                }
            }
            context("not all messages are visible") {
                it("should scroll to bottom") {

                }
            }
        }
    }
}
