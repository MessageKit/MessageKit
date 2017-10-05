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
import CoreLocation
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
        XCTAssertEqual(sut.messagesCollectionView.delegate as? MessagesViewController,
                       sut.messagesCollectionView.dataSource as? MessagesViewController)
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
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource

        XCTAssertEqual(sut.messagesCollectionView.numberOfSections, 0)
    }

    func testNumberOfSection_IsNumberOfMessages() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages = makeMessages(for: messagesDataSource.senders)

        let count = sut.messagesCollectionView.numberOfSections
        let expectedCount = messagesDataSource.numberOfMessages(in: sut.messagesCollectionView)

        XCTAssertEqual(count, expectedCount)
    }

    func testNumberOfItemInSection_IsOne() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages = makeMessages(for: messagesDataSource.senders)

        XCTAssertEqual(sut.messagesCollectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(sut.messagesCollectionView.numberOfItems(inSection: 1), 1)
    }

    func testCellForItemWithTextData_ReturnsTextMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(text: "Test",
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is TextMessageCell)
    }

    func testCellForItemWithAttributedTextData_ReturnsTextMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attriutedString = NSAttributedString(string: "Test", attributes: attributes)
        messagesDataSource.messages.append(MockMessage(attributedText: attriutedString,
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is TextMessageCell)
    }

    func testCellForItemWithPhotoData_ReturnsMediaMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(image: UIImage(),
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is MediaMessageCell)
    }

    func testCellForItemWithVideoData_ReturnsMediaMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(thumbnail: UIImage(),
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is MediaMessageCell)
    }

    func testCellForItemWithLocationData_ReturnsLocationMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(location: CLLocation(latitude: 60.0, longitude: 70.0),
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is LocationMessageCell)
    }

    // MARK: - Assistants

    private func makeMessages(for senders: [Sender]) -> [MessageType] {
        return [MockMessage(text: "Text 1", sender: senders[0], messageId: "test_id_1"),
                MockMessage(text: "Text 2", sender: senders[1], messageId: "test_id_2")]
    }

}

extension MessagesViewControllerTests {

    fileprivate class MockMessagesDisplayDelegate: MessagesDisplayDelegate { }

}
