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
        messagesCollectionView.messagesLayoutDelegate = self

        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messageLabelDelegate = self
        messageInputBar.delegate = self
        //setupInputBar()
    }
    
    func setupInputBar() {
        // Makes buttons with various 'hooks'
        
        let items = [
            makeButton(named: "ic_camera").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            },
            makeButton(named: "ic_library").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            },
            makeButton(named: "ic_at"),
            makeButton(named: "ic_hashtag"),
            .flexibleSpace,
            messageInputBar.sendButton
                .configure {
                    $0.layer.cornerRadius = 8
                    $0.layer.borderWidth = 1.5
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.setTitleColor(UIColor(colorLiteralRed: 15/255, green: 135/255, blue: 255/255, alpha: 1.0), for: .normal)
                    $0.setTitleColor(.white, for: .highlighted)
                    $0.setSize(CGSize(width: 52, height: 30), animated: false)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                }.onEnabled {
                    $0.layer.borderColor = UIColor(colorLiteralRed: 15/255, green: 135/255, blue: 255/255, alpha: 1.0).cgColor
                }.onSelected {
                    $0.backgroundColor = UIColor(colorLiteralRed: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
                }.onDeselected {
                    $0.backgroundColor = .white
            }
        ]
        
        //We can change the container insets if we want
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)

        // Adjust the padding
        messageInputBar.padding.top = 8
        messageInputBar.padding.bottom = 8
        messageInputBar.textViewPadding.bottom = 8

        // Since we moved the send button to the bottom stack lets set the right stack width to 0
        messageInputBar.setRightStackViewWidthContant(to: 0, animated: false)
        
        // Finally set the items
        messageInputBar.setStackViewItems(items, forStack: .bottom, animated: false)
    }
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 40, height: 40), animated: false)
                $0.layer.cornerRadius = 8
                $0.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            }.onKeyboardEditingBegins {
                $0.setSize(CGSize(width: 30, height: 30), animated: true)
            }.onKeyboardEditingEnds {
                $0.setSize(CGSize(width: 40, height: 40), animated: true)
            }.onSelected {
                $0.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
                $0.tintColor = .white
            }.onDeselected {
                $0.backgroundColor = .white
                $0.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
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
        return .messageBottom
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
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

// MARK: - MessagesLayoutDelegate

extension ConversationViewController: MessagesLayoutDelegate {

    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {

        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
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

// MARK: - MessageLabelDelegate

extension ConversationViewController: MessageLabelDelegate {

    func didSelectAddress(_ addressComponents: [String : String]) {
        print("Address Selected: \(addressComponents)")
    }

    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }

    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }

    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }

}

// MARK: - MessageInputBarDelegate

extension ConversationViewController: MessageInputBarDelegate {

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        messageList.append(MockMessage(text: text, sender: currentSender(), messageId: UUID().uuidString))
        inputBar.inputTextView.text = String()
        messagesCollectionView.reloadData()
    }

}
