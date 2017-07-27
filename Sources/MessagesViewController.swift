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
    
    open var messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MessagesCollectionViewFlowLayout())
    
    open var messageInputBar = MessageInputBar()
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open var inputAccessoryView: UIView? {
        messageInputBar.bounds.size = CGSize(width: messagesCollectionView.frame.width, height: 48)
        return messageInputBar
    }
    
    // MARK: - View Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupSubviews()
        setupConstraints()
        registerReusableViews()
        setupDelegates()

    }
    
    // MARK: - Methods
    
    func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }
    
    func registerReusableViews() {
        messagesCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")
    }
    
    func setupSubviews() {
        view.addSubview(messagesCollectionView)
    }
    
    func setupConstraints() {

        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -48))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))

    }
    
    func addKeyboardObservers() {
    
        NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: .UIKeyboardWillHide, object: nil)
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCollectionViewCell
        
        if let messagesCollectionView = collectionView as? MessagesCollectionView,
           let dataSource = messagesCollectionView.messagesDataSource,
           let displayDataSource = messagesCollectionView.messagesDisplayDataSource {
            
            let message = dataSource.messageForItem(at: indexPath, in: collectionView)
            let messageColor = displayDataSource.messageColorFor(message, at: indexPath, in: collectionView)
            let avatar = displayDataSource.avatarForMessage(message, at: indexPath, in: collectionView)
            
            cell.avatarImageView.image = avatar.image(highlighted: false)
            cell.avatarImageView.highlightedImage = avatar.image(highlighted: true)
            cell.messageContainerView.backgroundColor = messageColor
            cell.configure(with: message)

        }
        
        return cell

    }

}















