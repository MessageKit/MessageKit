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
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.dataProvider.messages)
    }

    func testMessageTextColorDefaultState() {
        XCTAssertEqual(sut.textColor(for: sut.dataProvider.messages[0],
                                     at: IndexPath(item: 0, section: 0),
                                     in: sut.messagesCollectionView),
                       UIColor.white)
        XCTAssertEqual(sut.textColor(for: sut.dataProvider.messages[1],
                                     at: IndexPath(item: 1, section: 0),
                                     in: sut.messagesCollectionView),
                       UIColor.darkText)
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

}

extension MessagesDisplayDelegateTests {

    fileprivate class MockMessagesViewController: MessagesViewController, MessagesDisplayDelegate {

        var dataProvider: MockMessagesDataSource!

        override func viewDidLoad() {
            super.viewDidLoad()

            dataProvider = makeDataSource()
            messagesCollectionView.messagesDataSource = dataProvider
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

}
