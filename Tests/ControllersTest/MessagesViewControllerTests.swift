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
import CoreLocation
@testable import MessageKit

class MessagesViewControllerTests: XCTestCase {

    var sut: MessagesViewController!
    // swiftlint:disable weak_delegate
    private var layoutDelegate = MockLayoutDelegate()
    // swiftlint:enable weak_delegate

    // MARK: - Overridden Methods

    override func setUp() {
        super.setUp()

        sut = MessagesViewController()
        sut.messagesCollectionView.messagesLayoutDelegate = layoutDelegate
        sut.messagesCollectionView.messagesDisplayDelegate = layoutDelegate
        _ = sut.view
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        sut.view.layoutIfNeeded()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    // MARK: - Test

    func testMessageCollectionViewLayout_isMessageCollectionViewLayout() {
        XCTAssertNotNil(sut.messagesCollectionView.collectionViewLayout)
        XCTAssertTrue(sut.messagesCollectionView.collectionViewLayout is MessagesCollectionViewFlowLayout)
    }

    func testMessageCollectionView_hasMessageCollectionFlowLayoutAfterViewDidLoad() {
        let layout = sut.messagesCollectionView.collectionViewLayout

        XCTAssertNotNil(layout)
        XCTAssertTrue(layout is MessagesCollectionViewFlowLayout)
    }

    func testViewDidLoad_shouldSetDelegateAndDataSourceToTheSameObject() {
        XCTAssertEqual(sut.messagesCollectionView.delegate as? MessagesViewController,
                       sut.messagesCollectionView.dataSource as? MessagesViewController)
    }

    func testNumberOfSectionWithoutData_isZero() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource

        XCTAssertEqual(sut.messagesCollectionView.numberOfSections, 0)
    }

    func testNumberOfSection_isNumberOfMessages() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages = makeMessages(for: messagesDataSource.senders)

        sut.messagesCollectionView.reloadData()

        let count = sut.messagesCollectionView.numberOfSections
        let expectedCount = messagesDataSource.numberOfSections(in: sut.messagesCollectionView)

        XCTAssertEqual(count, expectedCount)
    }

    func testNumberOfItemInSection_isOne() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages = makeMessages(for: messagesDataSource.senders)

        sut.messagesCollectionView.reloadData()

        XCTAssertEqual(sut.messagesCollectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(sut.messagesCollectionView.numberOfItems(inSection: 1), 1)
    }

    func testCellForItemWithTextData_returnsTextMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(text: "Test",
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        sut.messagesCollectionView.reloadData()

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is TextMessageCell)
    }

    func testCellForItemWithAttributedTextData_returnsTextMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attriutedString = NSAttributedString(string: "Test", attributes: attributes)
        messagesDataSource.messages.append(MockMessage(attributedText: attriutedString,
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        sut.messagesCollectionView.reloadData()

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is TextMessageCell)
    }

    func testCellForItemWithPhotoData_returnsMediaMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(image: UIImage(),
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        sut.messagesCollectionView.reloadData()

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is MediaMessageCell)
    }

    func testCellForItemWithVideoData_returnsMediaMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(thumbnail: UIImage(),
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        sut.messagesCollectionView.reloadData()

        let cell = sut.messagesCollectionView.dataSource?.collectionView(sut.messagesCollectionView,
                                                                         cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell is MediaMessageCell)
    }

    func testCellForItemWithLocationData_returnsLocationMessageCell() {
        let messagesDataSource = MockMessagesDataSource()
        sut.messagesCollectionView.messagesDataSource = messagesDataSource
        messagesDataSource.messages.append(MockMessage(location: CLLocation(latitude: 60.0, longitude: 70.0),
                                                       sender: messagesDataSource.senders[0],
                                                       messageId: "test_id"))

        sut.messagesCollectionView.reloadData()

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

private class MockLayoutDelegate: MessagesLayoutDelegate, MessagesDisplayDelegate {

    // MARK: - LocationMessageLayoutDelegate

    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0.0
    }

    func heightForMedia(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10.0
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        return LocationMessageSnapshotOptions()
    }
}
