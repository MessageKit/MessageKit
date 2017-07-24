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
        
        tabBarController?.tabBar.isHidden = true
        
        setupSubviews()
        setupConstraints()
        
        setupMessagesCollectionView()
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        view.addSubview(messagesCollectionView)
        view.addSubview(messageInputBar)
    }
    
    func setupMessagesCollectionView() {
        messagesCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }
    
    func setupConstraints() {

        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
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
        print(collectionView.numberOfSections)
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }

}

// MARK: - UICollectionViewDataSource Conformance

extension MessagesViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messagesCollectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let messageCount = messagesCollectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
        return messageCount > 0 ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return cell }
        
        guard let messageType = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: collectionView) else { return cell }
        
        return cell
    }

}















