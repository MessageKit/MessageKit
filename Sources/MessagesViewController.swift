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

open class MessagesViewController: UIViewController {
    
    // MARK: - Properties
    
    open var messagesCollectionView: MessagesCollectionView = {
        let flowLayout = MessagesCollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        messagesCollectionView.backgroundColor = .gray // color for testing
        return messagesCollectionView
    }()
    
    open var messageInputBar: MessageInputBar = {
        
        let messageInputBar = MessageInputBar(frame: .zero)
        messageInputBar.backgroundColor = .lightGray // color for testing
        return messageInputBar
    }()
    
    // MARK: - View Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupSubviews()
        setupConstraints()
        
        messagesCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        messagesCollectionView.register(MessageReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        messagesCollectionView.register(MessageReusableFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        
        if #available(iOS 10.0, *) {
            messagesCollectionView.isPrefetchingEnabled = false
        }
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        view.addSubview(messagesCollectionView)
        view.addSubview(messageInputBar)
    }
    
    func setupConstraints() {

        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: messageInputBar, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))

        messageInputBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: messageInputBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messageInputBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messageInputBar, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messageInputBar, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48))

    }

}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout Conformance

extension MessagesViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }

}

// MARK: - UICollectionViewDataSource Conformance

extension MessagesViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else { return 0 }
        // Each message is its own section
        return collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else { return 0 }
        let messageCount = collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
        // There will only ever be 1 message per section
        return messageCount > 0 ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MessageCollectionViewCell
        
        if let messagesCollectionView = collectionView as? MessagesCollectionView, let dataSource = messagesCollectionView.messagesDataSource {
            
            let message = dataSource.messageForItem(at: indexPath, in: collectionView)
            let isOutgoingMessage = dataSource.isFromCurrentSender(message: message)
            
            // Configure message here
            
            cell.configure(with: message)
            
        }
        
        return cell

    }
    
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//        case UICollectionElementKindSectionHeader:
//            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! MessageReusableHeaderView
//        case UICollectionElementKindSectionFooter:
//            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! MessageReusableFooterView
//        default:
//            fatalError("Invalid identifier String for viewForSupplementaryElementOfKind")
//        }
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard let layout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
//        return CGSize(width: layout.itemWidth, height: 4)
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        guard let layout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
//        return CGSize(width: layout.itemWidth, height: 4)
//    }

}















