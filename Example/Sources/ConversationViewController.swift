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

    var messageList: [MockMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        messageList = SampleData().getMessages()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
    }
}

// MARK: - MessagesDataSource

extension ConversationViewController: MessagesDataSource {

    func currentSender() -> Sender {
        return SampleData().getCurrentSender()
    }

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

}

// MARK: - MessagesDisplayDataSource

extension ConversationViewController: MessagesDisplayDataSource {

    func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
        return SampleData().getAvatarFor(sender: message.sender)
    }

    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return .messageTop
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let lightGray = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        let bubbleBorder = MessageBorder(cornerRadius: 15, color: UIColor.clear, width: 0, fillColor: lightGray)
        return .bubble(border: bubbleBorder, withTail: randomTailStyle())
    }

    func messageHeaderView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageHeaderView? {
        return messagesCollectionView.dequeueMessageHeaderView(for: indexPath)
    }

    func messageFooterView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageFooterView? {
        return messagesCollectionView.dequeueMessageFooterView(for: indexPath)
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption2)])
    }

}

extension ConversationViewController {
    fileprivate func randomTailStyle() -> MessageBubbleTailStyle {
        let lightGray = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        let tailBorderNoColor = MessageBorder(cornerRadius: 0, color: nil, width: 0, fillColor: lightGray)
        let tailBorderColored = MessageBorder(cornerRadius: 0, color: UIColor.lightGray, width: 1, fillColor: UIColor.orange)
        let randomStyle = Int(arc4random_uniform(UInt32(MessageBubbleTailStyle.styleCount)))
        let isColoredBorder = Int(arc4random_uniform(2)) == 1

        switch randomStyle {
        case 0: return .triangle(corner: randomCorner(), border: isColoredBorder ? tailBorderColored : tailBorderNoColor)
        case 1: return .tailCurved(corner: randomCorner(), border: isColoredBorder ? tailBorderColored : tailBorderNoColor)
        default: assert(false); break
        }
    }

    fileprivate func randomCorner() -> UIRectCorner {
        var corners: [UIRectCorner] = [.bottomLeft, .bottomRight, .topLeft, .topRight]
        let random = Int(arc4random_uniform(4))
        return corners[random]
    }
}

// MARK: - MessagesLayoutDelegate

extension ConversationViewController: MessagesLayoutDelegate {

    func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: messagesCollectionView.bounds.width, height: 4)
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
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

    func didTapTopLabel(in cell: MessageCollectionViewCell) {
        print("Top label tapped")
    }

    func didTapBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

}

// MARK: - MessageInputBarDelegate

extension ConversationViewController: MessageInputBarDelegate {

    func sendButtonPressed(sender: UIButton, textView: UITextView) {
        guard let message = textView.text else { return }
        messageList.append(MockMessage(text: message, sender: currentSender(), messageId: UUID().uuidString))
        textView.resignFirstResponder()
        textView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}
