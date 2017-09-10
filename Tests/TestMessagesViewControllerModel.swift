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
        self.messagesCollectionView.messagesDataSource = self
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
