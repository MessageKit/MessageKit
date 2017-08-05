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

import UIKit
import MessageKit

class ConversationViewController: MessagesViewController {

    var messages: [MessageType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        addSampleData()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self

        tabBarController?.tabBar.isHidden = true
    }

    func addSampleData() {

        let sender1 = Sender(id: "123456", displayName: "Bobby")
        let sender2 = Sender(id: "654321", displayName: "Steven")
        let sender3 = Sender(id: "777999", displayName: "Omar")

        let msg1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit." +
            "Pellentesque venenatis, ante et hendrerit rutrum" +
        "Quam erat vehicula metus, et condimentum ante tellus augue."

        let msg2 = "Cras efficitur bibendum mauris sed ultrices." +
        "Phasellus tellus nisl, ullamcorper quis erat."

        let msg3 = "Maecenas."

        let msg4 = "Pellentesque venenatis, ante et hendrerit rutrum" +
        "Quam erat vehicula metus, et condimentum ante tellus augue."

        let msg5 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit." +
            "Pellentesque venenatis, ante et hendrerit rutrum" +
        "Quam erat vehicula metus, et condimentum ante tellus augue."

        messages.append(MockMessage(text: msg2, sender: sender2, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg4, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg5, sender: sender3, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg1, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg3, sender: sender1, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg3, sender: sender1, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg2, sender: sender2, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg2, sender: sender2, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg1, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg3, sender: sender1, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg2, sender: sender2, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg4, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg5, sender: sender3, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg4, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg5, sender: sender3, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg4, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg5, sender: sender3, id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg1, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg1, sender: currentSender(), id: NSUUID().uuidString))
        messages.append(MockMessage(text: msg3, sender: sender1, id: NSUUID().uuidString))

    }

}

// MARK: - MessagesDataSource

extension ConversationViewController: MessagesDataSource {

    func currentSender() -> Sender {
        return Sender(id: "123", displayName: "Steven")
    }

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

<<<<<<< HEAD
}

// MARK: - MessagesDisplayDataSource

extension ConversationViewController: MessagesDisplayDataSource {

    func avatarForMessage(_ message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
=======
    func avatarForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> AvatarView {
>>>>>>> Fix failing test and minor changes
        let image = isFromCurrentSender(message: message) ? #imageLiteral(resourceName: "Steve-Jobs") : #imageLiteral(resourceName: "Tim-Cook")
        return AvatarView(image: image)
    }

    func headerForMessage(_ message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageHeaderView? {
        return messagesCollectionView.dequeueMessageHeaderView(for: indexPath)
    }

    func footerForMessage(_ message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageFooterView? {
        return messagesCollectionView.dequeueMessageFooterView(for: indexPath)
    }

}

// MARK: - MessagesLayoutDelegate

extension ConversationViewController: MessagesLayoutDelegate {

    func headerSizeFor(_ message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: messagesCollectionView.bounds.width, height: 4)
    }

    func footerSizeFor(_ message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: messagesCollectionView.bounds.width, height: 4)
    }

}

// MARK: - MessageCellDelegate

extension ConversationViewController: MessageCellDelegate {

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }

}

// MARK: - MessageInputBarDelegate

extension ConversationViewController: MessageInputBarDelegate {

    func sendButtonPressed(sender: UIButton, textView: UITextView) {

        guard let message = textView.text else { return }

        messages.append(MockMessage(text: message, sender: currentSender(), id: NSUUID().uuidString))

        messagesCollectionView.reloadData()

    }

}
