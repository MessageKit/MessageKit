//
//  ViewController.swift
//  CaseStudy-MessageKit
//


import UIKit
import MessageKit
import InputBarAccessoryView

class ViewController: MessagesViewController {
    
    let sender = Sender(senderId: "any_unique_id", displayName: "Vidur Subaiah")
    var messages: [MessageType] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        configureTitleBar()
        configureInputMessageBar()
    }
    
    func configureTitleBar() {
        let titleBarHeight: CGFloat = 40
        let titleBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: titleBarHeight))
        titleBar.backgroundColor = .systemYellow
        titleBar.delegate = self
        
        let titleItem = UINavigationItem()
        titleItem.title = "My Notes"
        
        titleBar.items = [titleItem]
        
        self.view.addSubview(titleBar)
        self.view.frame = CGRect(x: 0, y: titleBarHeight, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - titleBarHeight))
    }
    
    func configureInputMessageBar(){
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        messageInputBar.sendButton.setTitleColor(
          UIColor.systemGray,
          for: .highlighted)
        messageInputBar.backgroundView.backgroundColor = .systemYellow
    }

    func insertMessage(_ message: mockMessage) {
        self.messages.append(message)
      // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([self.messages.count - 1])
            if self.messages.count >= 2 {
                messagesCollectionView.reloadSections([self.messages.count - 2])
            }
        }, completion: { [weak self] _ in
        if self?.isLastSectionVisible() == true {
          self?.messagesCollectionView.scrollToLastItem(animated: true)
        }
      })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !self.messages.isEmpty else { return false }

        let lastIndexPath = IndexPath(item: 0, section: self.messages.count - 1)

        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}

extension ViewController: MessagesDataSource {
   
    var currentSender: SenderType {
        return self.sender
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
    
}

extension ViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        let avatarImage = UIImage(systemName: "pencil.circle.fill")
//        let avatarImageColored = avatarImage?.withTintColor(.systemCyan)
//        let avatar = Avatar(image: avatarImageColored, initials: "VS")
        let avatar = Avatar(image: UIImage(named: "pencil") , initials: "VS")
        avatarView.set(avatar: avatar)
    }
    
    func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        return UIColor.black
    }
    
}

extension ViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = self.sender
            if let str = component as? String {
                let message = mockMessage(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str))
                insertMessage(message)
            }
        }
    }
}

extension ViewController: UINavigationBarDelegate {}

public struct Sender: SenderType {
    
    public let senderId: String

    public let displayName: String
}

public struct mockMessage: MessageType {
    
    public let sender: SenderType
    
    public let messageId: String

    public let sentDate: Date

    public let kind: MessageKind
}
