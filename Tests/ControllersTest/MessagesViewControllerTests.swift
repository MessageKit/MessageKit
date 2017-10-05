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

import XCTest
@testable import MessageKit

class MessagesViewControllerTests: XCTestCase {

    var sut: MessagesViewController!

    // MARK: - Overridden Methods

    override func setUp() {
        super.setUp()

        sut = MessagesViewController()
        _ = sut.view
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: - Test

    func testMessageCollectionViewNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.messageInputBar)
    }

    func testMessageCollectionViewHasMessageCollectionFlowLayoutAfterViewDidLoad() {
        let layout = sut.messagesCollectionView.collectionViewLayout

        XCTAssertNotNil(layout)
        XCTAssertTrue(layout is MessagesCollectionViewFlowLayout)
    }

    func testMessageInputBarNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.messageInputBar)
    }

    func testViewDidLoadShouldSetBackgroundColorToWhite() {
        XCTAssertEqual(sut.view.backgroundColor, UIColor.white)
    }

    func testViewDidLoadShouldAddMessageCollectionViewInSubviews() {
        let messageColelctionViews = sut.view.subviews.filter { $0 is MessagesCollectionView }

        XCTAssertEqual(messageColelctionViews.count, 1)
    }

    func testViewDidLoadShouldSetAutomaticallyAdjustsScrollViewInsetsToFalse() {
        XCTAssertFalse(sut.automaticallyAdjustsScrollViewInsets)
    }

    func testViewDidLoadShouldSetCollectionViewDelegate() {
        let delegate = sut.messagesCollectionView.delegate

        XCTAssertNotNil(delegate)
        XCTAssertTrue(delegate is MessagesViewController)
    }

    func testViewDidLoadShouldSetCollectionViewDataSource() {
        let dataSource = sut.messagesCollectionView.dataSource

        XCTAssertNotNil(dataSource)
        XCTAssertTrue(dataSource is MessagesViewController)
    }

    func testViewDidLoadShouldSetDelegateAndDataSourceToTheSameObject() {
        let delegate = sut.messagesCollectionView.delegate
        let dataSource = sut.messagesCollectionView.dataSource

        XCTAssertEqual(delegate as? MessagesViewController,
                       dataSource as? MessagesViewController)
    }

    func testShouldAutorotateIsFalse() {
        XCTAssertFalse(sut.shouldAutorotate)
    }

    func testInputAccessoryViewShouldReturnMessageInputBarAfterViewDidLoad() {
        let inputAccessoryView = sut.inputAccessoryView

        XCTAssertNotNil(inputAccessoryView)
        XCTAssertEqual(inputAccessoryView, sut.messageInputBar)
    }

    func testCaBecomeFirstResponderIsTrue() {
        XCTAssertTrue(sut.canBecomeFirstResponder)
    }

    func testNumberOfSectionWithoutData_IsZero() {
        let messagesCollectionView = sut.messagesCollectionView
        let messagesDataSource = MockMessagesDataSource()
        messagesCollectionView.messagesDataSource = messagesDataSource

        XCTAssertEqual(messagesCollectionView.numberOfSections, 0)
    }

    func testNumberOfSection_IsNumberOfMessages() {
        let messagesCollectionView = sut.messagesCollectionView
        let messagesDataSource = MockMessagesDataSource()
        messagesCollectionView.messagesDataSource = messagesDataSource

        messagesDataSource.messages = makeMessages(for: messagesDataSource.senders)

        let count = messagesCollectionView.numberOfSections
        let expectedCount = messagesDataSource.numberOfMessages(in: messagesCollectionView)

        XCTAssertEqual(count, expectedCount)
    }

    func testNumberOfItemInSection_IsOne() {
        let messagesCollectionView = sut.messagesCollectionView
        let messagesDataSource = MockMessagesDataSource()
        messagesCollectionView.messagesDataSource = messagesDataSource

        messagesDataSource.messages = makeMessages(for: messagesDataSource.senders)

        XCTAssertEqual(messagesCollectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(messagesCollectionView.numberOfItems(inSection: 1), 1)
    }

    // MARK: - Assistants

    private func makeMessages(for senders: [Sender]) -> [MessageType] {
        return [MockMessage(text: "Text 1", sender: senders[0], messageId: "001"),
                MockMessage(text: "Text 2", sender: senders[1], messageId: "002")]
    }

}
