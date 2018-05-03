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

class MessagesDisplayDelegateTests: XCTestCase {

    private var sut: MockMessagesViewController!

    override func setUp() {
        super.setUp()

        sut = MockMessagesViewController()
        _ = sut.view
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        sut.view.layoutIfNeeded()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testBackGroundColorDefaultState() {
        XCTAssertEqual(sut.backgroundColor(for: sut.dataProvider.messages[0],
                                           at: IndexPath(item: 0, section: 0),
                                           in: sut.messagesCollectionView),
                       UIColor.outgoingGreen)
        XCTAssertNotEqual(sut.backgroundColor(for: sut.dataProvider.messages[0],
                                              at: IndexPath(item: 0, section: 0),
                                              in: sut.messagesCollectionView),
                          UIColor.incomingGray)
        XCTAssertEqual(sut.backgroundColor(for: sut.dataProvider.messages[1],
                                           at: IndexPath(item: 1, section: 0),
                                           in: sut.messagesCollectionView),
                       UIColor.incomingGray)
        XCTAssertNotEqual(sut.backgroundColor(for: sut.dataProvider.messages[1],
                                              at: IndexPath(item: 1, section: 0),
                                              in: sut.messagesCollectionView),
                          UIColor.outgoingGreen)
    }

    func testBackgroundColorWithoutDataSource_returnsWhiteForDefault() {
        sut.messagesCollectionView.messagesDataSource = nil
        let backgroundColor = sut.backgroundColor(for: sut.dataProvider.messages[0],
                                                  at: IndexPath(item: 0, section: 0),
                                                  in: sut.messagesCollectionView)

        XCTAssertEqual(backgroundColor, .white)
    }

    func testBackgroundColorForMessageWithEmoji_returnsClearForDefault() {
        sut.dataProvider.messages.append(MockMessage(emoji: "🤔",
                                                     sender: sut.dataProvider.currentSender(),
                                                     messageId: "003"))
        let backgroundColor = sut.backgroundColor(for: sut.dataProvider.messages[2],
                                                  at: IndexPath(item: 0, section: 0),
                                                  in: sut.messagesCollectionView)

        XCTAssertEqual(backgroundColor, .clear)
    }

    func testCellTopLabelDefaultState() {
        XCTAssertNil(sut.dataProvider.cellTopLabelAttributedText(for: sut.dataProvider.messages[0],
                                                                 at: IndexPath(item: 0, section: 0)))
    }

    func testMessageBottomLabelDefaultState() {
        XCTAssertNil(sut.dataProvider.messageBottomLabelAttributedText(for: sut.dataProvider.messages[0],
                                                                    at: IndexPath(item: 0, section: 0)))
    }

    func testMessageStyle_returnsBubleTypeForDefault() {
        let type = sut.messageStyle(for: sut.dataProvider.messages[0],
                                    at: IndexPath(item: 0, section: 0),
                                    in: sut.messagesCollectionView)

        let result: Bool
        switch type {
        case .bubble:
            result = true
        default:
            result = false
        }

        XCTAssertTrue(result)
    }

    func testMessageHeaderView_isNotNil() {
        let indexPath = IndexPath(item: 0, section: 1)
        let headerView = sut.messageHeaderView(for: indexPath, in: sut.messagesCollectionView)
        XCTAssertNotNil(headerView)
    }

}

class TextMessageDisplayDelegateTests: XCTestCase {

    private var sut: MockMessagesViewController!

    override func setUp() {
        super.setUp()

        sut = MockMessagesViewController()
        _ = sut.view
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testTextColorFromCurrentSender_returnsWhiteForDefault() {
        let textColor = sut.textColor(for: sut.dataProvider.messages[0],
                                      at: IndexPath(item: 0, section: 0),
                                      in: sut.messagesCollectionView)

        XCTAssertEqual(textColor, .white)
    }

    func testTextColorFromYou_returnsDarkTextForDefault() {
        let textColor = sut.textColor(for: sut.dataProvider.messages[1],
                                      at: IndexPath(item: 0, section: 0),
                                      in: sut.messagesCollectionView)

        XCTAssertEqual(textColor, .darkText)
    }

    func testTextColorWithoutDataSource_returnsDarkTextForDefault() {
        let dataSource = sut.makeDataSource()
        sut.messagesCollectionView.messagesDataSource = dataSource
        let textColor = sut.textColor(for: sut.dataProvider.messages[1],
                                      at: IndexPath(item: 0, section: 0),
                                      in: sut.messagesCollectionView)

        XCTAssertEqual(textColor, .darkText)
    }

    func testEnableDetectors_returnsEmptyForDefault() {
        let detectors = sut.enabledDetectors(for: sut.dataProvider.messages[1],
                                             at: IndexPath(item: 0, section: 0),
                                             in: sut.messagesCollectionView)
        let expectedDetectors: [DetectorType] = []

        XCTAssertEqual(detectors, expectedDetectors)
    }

}

private class MockMessagesViewController: MessagesViewController, MessagesDisplayDelegate, MessagesLayoutDelegate {

    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }

    var dataProvider: MockMessagesDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = makeDataSource()
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = dataProvider
        messagesCollectionView.messagesLayoutDelegate = self

    }

    fileprivate func makeDataSource() -> MockMessagesDataSource {
        let dataSource = MockMessagesDataSource()
        dataSource.messages.append(MockMessage(text: "Text 1",
                                               sender: dataSource.senders[0],
                                               messageId: "001"))
        dataSource.messages.append(MockMessage(text: "Text 2",
                                               sender: dataSource.senders[1],
                                               messageId: "002"))

        return dataSource
    }

    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        return LocationMessageSnapshotOptions()
    }
}
