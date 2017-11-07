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

    func testAvatarDefaultState() {
        XCTAssertNotNil(sut.dataProvider.avatar(for: sut.dataProvider.messages[0],
                                                at: IndexPath(item: 0, section: 0),
                                                in: sut.messagesCollectionView).initals)
    }

    func testCellTopLabelDefaultState() {
        XCTAssertNil(sut.dataProvider.cellTopLabelAttributedText(for: sut.dataProvider.messages[0],
                                                                 at: IndexPath(item: 0, section: 0)))
    }

    func testCellBottomLabelDefaultState() {
        XCTAssertNil(sut.dataProvider.cellBottomLabelAttributedText(for: sut.dataProvider.messages[0],
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

    func testShouldDisplayHeaderWithoutDataSource_returnsFalseForDefault() {
        sut.messagesCollectionView.messagesDataSource = nil

        XCTAssertFalse(sut.shouldDisplayHeader(for: sut.dataProvider.messages[0],
                                               at: IndexPath(item: 0, section: 0),
                                               in: sut.messagesCollectionView))
    }

    func testShouldDisplayHeaderForFirstMessage_returnsFalseForDefault() {
        XCTAssertFalse(sut.shouldDisplayHeader(for: sut.dataProvider.messages[0],
                                               at: IndexPath(item: 0, section: 0),
                                               in: sut.messagesCollectionView))
    }

    func testShouldDisplayHeaderForMessageWithTimeIntervalSinceLastMessageGreatherThanScheduled_returnsTrue() {
        var message = MockMessage(text: "Test", sender: sut.dataProvider.currentSender(), messageId: "003")
        let scheduledInterval = sut.messagesCollectionView.showsDateHeaderAfterTimeInterval
        message.sentDate = Date(timeIntervalSinceNow: scheduledInterval + 300)
        sut.dataProvider.messages.append(message)

        XCTAssertTrue(sut.shouldDisplayHeader(for: sut.dataProvider.messages[2],
                                              at: IndexPath(item: 0, section: 1),
                                              in: sut.messagesCollectionView))
    }

    func testShouldDisplayHeaderForMessageWithTimeIntervalSinceLastMessageEqualThanScheduled_returnsTrue() {
        var message = MockMessage(text: "Test", sender: sut.dataProvider.currentSender(), messageId: "003")
        let scheduledInterval = sut.messagesCollectionView.showsDateHeaderAfterTimeInterval
        message.sentDate = Date(timeIntervalSinceNow: scheduledInterval)
        sut.dataProvider.messages.append(message)

        XCTAssertTrue(sut.shouldDisplayHeader(for: sut.dataProvider.messages[2],
                                              at: IndexPath(item: 0, section: 1),
                                              in: sut.messagesCollectionView))
    }

    func testShouldDisplayHeaderForMessageWithTimeIntervalSinceLastMessageLessThanScheduled_returnsFalse() {
        var message = MockMessage(text: "Test", sender: sut.dataProvider.currentSender(), messageId: "003")
        let scheduledInterval = sut.messagesCollectionView.showsDateHeaderAfterTimeInterval
        message.sentDate = Date(timeIntervalSinceNow: scheduledInterval - 300)
        sut.dataProvider.messages.append(message)

        XCTAssertFalse(sut.shouldDisplayHeader(for: sut.dataProvider.messages[2],
                                               at: IndexPath(item: 0, section: 1),
                                               in: sut.messagesCollectionView))
    }

    func testMessageHeaderView_isNotNil() {
        let headerView = sut.messageHeaderView(for: sut.dataProvider.messages[1],
                                               at: IndexPath(item: 0, section: 1),
                                               in: sut.messagesCollectionView)

        XCTAssertNotNil(headerView)
    }

    func testMessageFooterView_isNotNil() {
        let footerView = sut.messageFooterView(for: sut.dataProvider.messages[1],
                                               at: IndexPath(item: 0, section: 1),
                                               in: sut.messagesCollectionView)

        XCTAssertNotNil(footerView)
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
        sut.messagesCollectionView.messagesDataSource = nil
        let textColor = sut.textColor(for: sut.dataProvider.messages[1],
                                      at: IndexPath(item: 0, section: 0),
                                      in: sut.messagesCollectionView)

        XCTAssertEqual(textColor, .darkText)
    }

    func testEnableDetectors_returnsUrlAddressPhoneNumberAndDateForDefault() {
        let detectors = sut.enabledDetectors(for: sut.dataProvider.messages[1],
                                             at: IndexPath(item: 0, section: 0),
                                             in: sut.messagesCollectionView)
        let expectedDetectors: [DetectorType] = [.url, .address, .phoneNumber, .date]

        XCTAssertEqual(detectors, expectedDetectors)
    }

}

private class MockMessagesViewController: MessagesViewController, MessagesDisplayDelegate, TextMessageDisplayDelegate, MessagesLayoutDelegate {

    var dataProvider: MockMessagesDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        dataProvider = makeDataSource()
        messagesCollectionView.messagesDataSource = dataProvider
        messagesCollectionView.messagesLayoutDelegate = self
    }

    private func makeDataSource() -> MockMessagesDataSource {
        let dataSource = MockMessagesDataSource()
        dataSource.messages.append(MockMessage(text: "Text 1",
                                               sender: dataSource.senders[0],
                                               messageId: "001"))
        dataSource.messages.append(MockMessage(text: "Text 2",
                                               sender: dataSource.senders[1],
                                               messageId: "002"))

        return dataSource
    }

}
