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

    private var messageInputBarCopy: MessageInputBar?

    private var isFirstLayout: Bool = true

    override open var canBecomeFirstResponder: Bool {
        return true
    }

    override open var inputAccessoryView: UIView? {
        return messageInputBar
    }

    open override var shouldAutorotate: Bool {
        return false
    }

    // MARK: - View Life Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        messagesCollectionView.keyboardDismissMode = .interactive

        setupSubviews()
        setupConstraints()
        registerReusableViews()
        setupDelegates()

    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstLayout {
            setupMessageInputBarCopy()
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeMessageInputBarCopy()
    }

    open override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            addKeyboardObservers()
            messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
            isFirstLayout = false
        }
    }

    // MARK: - Initializers

    deinit {
        removeKeyboardObservers()
    }

    // MARK: - Methods

    private func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }

    private func registerReusableViews() {

        messagesCollectionView.register(TextMessageCell.self,
                                        forCellWithReuseIdentifier: "TextMessageCell")

        messagesCollectionView.register(MediaMessageCell.self,
                                        forCellWithReuseIdentifier: "MediaMessageCell")

        messagesCollectionView.register(LocationMessageCell.self,
                                        forCellWithReuseIdentifier: "LocationMessageCell")

        messagesCollectionView.register(MessageFooterView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                        withReuseIdentifier: "MessageFooterView")

        messagesCollectionView.register(MessageHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: "MessageHeaderView")

        messagesCollectionView.register(MessageDateHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: "MessageDateHeaderView")

    }

    private func setupSubviews() {
        view.addSubview(messagesCollectionView)
    }

    private func setupConstraints() {
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let top = messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
        let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([top, bottom, trailing, leading])
    }

    // MARK: - MessageInputBar
    // Fixes bug where MessageInputBar text renders after viewDidAppear

    private func setupMessageInputBarCopy() {
        messageInputBarCopy = messageInputBar.createCopy()
        guard let copy = messageInputBarCopy else { return }
        view.addSubview(copy)
        copy.addConstraints(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

    private func removeMessageInputBarCopy() {
        messageInputBarCopy?.removeFromSuperview()
        messageInputBarCopy = nil
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

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return UICollectionViewCell() }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { fatalError("Please set messagesDataSource") }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch message.data {
        case .text, .attributedText:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextMessageCell", for: indexPath) as? TextMessageCell else {
                fatalError("Unable to dequeue TextMessageCell")
            }
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .photo, .video:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaMessageCell", for: indexPath) as? MediaMessageCell else {
                fatalError("Unable to dequeue MediaMessageCell")
            }
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .location:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationMessageCell", for: indexPath) as? LocationMessageCell else {
                fatalError("Unable to dequeue LocationMessageCell")
            }
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }

    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return UICollectionReusableView() }
        guard let dataSource = messagesCollectionView.messagesDataSource else { return UICollectionReusableView() }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else { return UICollectionReusableView() }

        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch kind {
        case UICollectionElementKindSectionHeader:
            return displayDelegate.messageHeaderView(for: message, at: indexPath, in: messagesCollectionView) ?? MessageHeaderView()
        case UICollectionElementKindSectionFooter:
            return displayDelegate.messageFooterView(for: message, at: indexPath, in: messagesCollectionView) ?? MessageFooterView()
        default:
            fatalError("Unrecognized element of kind: \(kind)")
        }

    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return messagesLayoutDelegate.headerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return messagesLayoutDelegate.footerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }

}

// MARK: - Keyboard Handling

extension MessagesViewController {

    fileprivate func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidChangeState), name: .UIKeyboardWillChangeFrame, object: nil)
    }

    fileprivate func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
    }

    func handleKeyboardDidChangeState(_ notification: Notification) {

        guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        if (keyboardEndFrame.origin.y + keyboardEndFrame.size.height) > view.frame.size.height {
            // Hardware keyboard is found
            messagesCollectionView.contentInset.bottom = view.frame.size.height - keyboardEndFrame.origin.y
        } else {
            //Software keyboard is found
            let bottomInset = keyboardEndFrame.height > messageInputBar.frame.height ? keyboardEndFrame.height : messageInputBar.frame.height
            messagesCollectionView.contentInset.bottom = bottomInset
        }
        
    }
    
}
