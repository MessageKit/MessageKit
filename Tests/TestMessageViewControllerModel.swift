//
//  TestMessageViewControllerModel.swift
//  MessageKit
//
//  Created by Dan Leonard on 8/14/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//
// *** Class used for testing `MessagesDisplayDataSource` in MessagesDisplayDataSourceTests it can be used for other tests but please make sure that all tests pass after you have made changes.
//

import Foundation
class TestMessagesViewControllerModel: MessagesViewController, MessagesDisplayDataSource {
    
    var messageList: [TestMessage] = []
    
    static let sender1 = Sender(id: "1", displayName: "Dan")
    static let sender2 = Sender(id: "2", displayName: "jobs")
    
    let testMessage1 = TestMessage(text: "Hi", sender: sender1, messageId: "asdf")
    let testMessage2 = TestMessage(text: "sup", sender: sender2, messageId: "dddf")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageList = [testMessage1, testMessage2]
        messagesCollectionView.messagesDisplayDataSource = self
    }
}

// - MARK: MessagesDataSource conformace
extension TestMessagesViewControllerModel: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: "1", displayName: "Dan")
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
}
