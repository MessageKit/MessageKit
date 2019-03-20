//
//  CoredataChatViewController.swift
//  ChatExample
//
//  Created by Gumdal, Raj Pawan on 20/03/19.
//  Copyright © 2019 MessageKit. All rights reserved.
//

import Foundation
import MapKit
import MessageKit
import MessageInputBar
import CoreData

class CoredataChatViewController: MessagesViewController {
    let refreshControl = UIRefreshControl()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    private lazy var chatUser:ChatSender = {
        // From: https://medium.com/swift-programming/how-to-do-proper-lazy-loading-in-swift-b8bc57dbc7b9
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatSender")
        var anUser:ChatSender?
        request.predicate = NSPredicate(format: "senderID != %@", "001")    // 001 is the ID of the current user!! So, we try to first sender here for demo purpose who is not me!
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                anUser = data as? ChatSender
                break
            }
        } catch {
            print("Failed")
        }
        
        if (anUser == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "ChatSender", in: context)
            anUser = NSManagedObject(entity: entity!, insertInto: context) as? ChatSender
            anUser?.senderID = "007"
            anUser?.displayName = "Bot"
            /*do {
             try context.save()
             } catch {
             print("Failed saving")
             }*/
        }
        return anUser!
    }()
    private lazy var currentUser:ChatSender = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatSender")
        var anUser:ChatSender?
        request.predicate = NSPredicate(format: "senderID = %@", "001")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                anUser = data as? ChatSender
                break
            }
        } catch {
            print("Failed")
        }
        
        if (anUser == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "ChatSender", in: context)
            anUser = NSManagedObject(entity: entity!, insertInto: context) as? ChatSender
            anUser?.senderID = "001"
            anUser?.displayName = "Human"
            /*do {
             try context.save()
             } catch {
             print("Failed saving")
             }*/
        }
        return anUser!
    }()
    
    private lazy var messagesFetchedResultsController:NSFetchedResultsController<ChatMessage> = {
        let request: NSFetchRequest<ChatMessage> = ChatMessage.fetchRequest()
        let sort = NSSortDescriptor(key: "chatMessageSentDate", ascending: true)
        request.sortDescriptors = [sort]
        //        request.fetchBatchSize = 20
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MockSocket.shared.connect(with: [SampleData.shared.steven, SampleData.shared.wu])
            .onNewMessage { [weak self] message in
                var textResponse : String? = nil
                switch message.kind {
                case .text(let textValue):
                    textResponse = textValue
                default:
                    textResponse = nil
                }
                if (nil != textResponse) {
                    let creatingChatUser = self!.chatUser // Creating this to avoid a crash later!!
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "ChatMessage", in: context)
                    let mkEntity = NSEntityDescription.entity(forEntityName: "ChatMessageKind", in: context)
                    let responseMessage = NSManagedObject(entity: entity!, insertInto: context) as? ChatMessage
                    responseMessage?.chatMessageID = UUID().uuidString
                    responseMessage?.chatMessageSentDate = Date() as NSDate
                    let responseMK:MessageKind = MessageKind.text(textResponse!)
                    let responseMessageKindManagedObject:ChatMessageKind = NSManagedObject (entity: mkEntity!, insertInto: context) as! ChatMessageKind
                    responseMessageKindManagedObject.kind = responseMK
                    responseMessage?.chatMessageKind = responseMessageKindManagedObject
                    responseMessage?.chatMessageSender = self!.chatUser
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MockSocket.shared.disconnect()
    }

    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshChat), for: .valueChanged)
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.tintColor = .primaryColor
    }
    
    @objc func refreshChat() {
        
    }
}

extension CoredataChatViewController : MessagesDataSource {
    //  MARK: - MessagesDataSource
    func currentSender() -> Sender {
        let theCurrentSender:ChatSender = self.currentUser
        return theCurrentSender.sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messagesFetchedResultsController.fetchedObjects![indexPath.section] as! MessageType
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return (self.messagesFetchedResultsController.fetchedObjects?.count)!
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

extension CoredataChatViewController : MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {}
    
    func didTapMessage(in cell: MessageCollectionViewCell) {}
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {}
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {}
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {}
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {}
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {}
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {}
}


// MARK: - MessageInputBarDelegate
extension CoredataChatViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ChatMessage", in: context)
                let message = NSManagedObject(entity: entity!, insertInto: context) as? ChatMessage
                message?.chatMessageID = UUID().uuidString
                message?.chatMessageSentDate = Date() as NSDate
                let mk:MessageKind = MessageKind.text(str)
                let mkEntity = NSEntityDescription.entity(forEntityName: "ChatMessageKind", in: context)
                let messageKindManagedObject:ChatMessageKind = NSManagedObject (entity: mkEntity!, insertInto: context) as! ChatMessageKind
                messageKindManagedObject.kind = mk
                message?.chatMessageKind = messageKindManagedObject
                message?.chatMessageSender = self.currentUser
                let creatingChatUser = self.chatUser // Creating this to avoid a crash later!!
                
                // Save context:
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            } /*else if let img = component as? UIImage {
             let message = MockMessage(image: img, sender: currentSender(), messageId: UUID().uuidString, date: Date())
             insertMessage(message)
             }*/
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

extension CoredataChatViewController: NSFetchedResultsControllerDelegate {
    //    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (type == .insert) {
            messagesCollectionView.performBatchUpdates({
                messagesCollectionView.insertSections([self.messagesFetchedResultsController.fetchedObjects!.count - 1])
                if self.messagesFetchedResultsController.fetchedObjects!.count >= 2 {
                    messagesCollectionView.reloadSections([self.messagesFetchedResultsController.fetchedObjects!.count - 2])
                }
            }, completion: { [weak self] _ in
                if self?.isLastSectionVisible() == true {
                    self?.messagesCollectionView.scrollToBottom(animated: true)
                }
            })
        }
    }
    func isLastSectionVisible() -> Bool {
        
        guard !self.messagesFetchedResultsController.fetchedObjects!.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: self.messagesFetchedResultsController.fetchedObjects!.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}

extension CoredataChatViewController : MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

extension CoredataChatViewController : MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primaryColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        let firstName = sender.displayName.components(separatedBy: " ").first
        let lastName = sender.displayName.components(separatedBy: " ").first
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
}

