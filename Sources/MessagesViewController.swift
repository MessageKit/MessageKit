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
		return messageInputBar
	}

    open override var shouldAutorotate: Bool {
        return false
    }

	// MARK: - View Life Cycle

	open override func viewDidLoad() {
		super.viewDidLoad()

		automaticallyAdjustsScrollViewInsets = false

		setupSubviews()
		setupConstraints()
		registerReusableViews()
		setupDelegates()

	}

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesCollectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomBarsHeight, right: 0)
    }

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		addKeyboardObservers()
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

		messagesCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")

        messagesCollectionView.register(MessageHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: "MessageHeader")

        messagesCollectionView.register(MessageFooterView.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                        withReuseIdentifier: "MessageFooter")
	}

	private func setupSubviews() {
		messagesCollectionView.keyboardDismissMode = .interactive
        messagesCollectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomBarsHeight, right: 0)
		view.addSubview(messagesCollectionView)
	}

	private func setupConstraints() {

		messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal,
		                                      toItem: view, attribute: .top, multiplier: 1, constant: 0))

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal,
		                                      toItem: view, attribute: .leading, multiplier: 1, constant: 0))

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal,
		                                      toItem: view, attribute: .trailing, multiplier: 1, constant: 0))

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal,
		                                      toItem: view, attribute: .bottom, multiplier: 1, constant: 0))

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

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCollectionViewCell ?? MessageCollectionViewCell()

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return cell }

        if let cellDelegate = messagesCollectionView.messageCellDelegate {
            if cell.delegate == nil { cell.delegate = cellDelegate }
        }

        if let messageLabelDelegate = messagesCollectionView.messageLabelDelegate {
            if cell.messageLabel.delegate == nil { cell.messageLabel.delegate = messageLabelDelegate }
        }

        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return cell }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        if let displayDataSource = messagesDataSource as? MessagesDisplayDataSource {

            let messageColor = displayDataSource.backgroundColor(for: message, at: indexPath, in: messagesCollectionView)
            let textColor = displayDataSource.textColor(for: message, at: indexPath, in: messagesCollectionView)
            let avatar = displayDataSource.avatar(for: message, at: indexPath, in: messagesCollectionView)
            let topLabelText = displayDataSource.cellTopLabelAttributedText(for: message, at: indexPath)
            let bottomLabelText = displayDataSource.cellBottomLabelAttributedText(for: message, at: indexPath)

            cell.avatarView.set(avatar: avatar)
            cell.messageLabel.textColor = textColor
            cell.messageContainerView.backgroundColor = messageColor
            cell.cellTopLabel.attributedText = topLabelText
            cell.cellBottomLabel.attributedText = bottomLabelText

        }

        cell.configure(with: message)

		return cell

	}

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return UICollectionReusableView() }
        guard let displayDataSource = messagesCollectionView.messagesDataSource as? MessagesDisplayDataSource else { return UICollectionReusableView() }

        let message = displayDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch kind {
        case UICollectionElementKindSectionHeader:
            return displayDataSource.messageHeaderView(for: message, at: indexPath, in: messagesCollectionView) ?? MessageHeaderView()
        case UICollectionElementKindSectionFooter:
            return displayDataSource.messageFooterView(for: message, at: indexPath, in: messagesCollectionView) ?? MessageFooterView()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
    }
    
    fileprivate func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        //This should work for both hardware and software keyboards
        let bottomInset = keyboardFrame.height + bottomLayoutGuide.length
        messagesCollectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        messagesCollectionView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomBarsHeight, right: 0)
    }
    
}

// MARK: - Helpers
extension MessagesViewController {
    /// Accesory view plus bottom layout guide length
    var bottomBarsHeight: CGFloat {
        let accesoryHeight = inputAccessoryView?.bounds.height ?? 0
        return accesoryHeight + bottomLayoutGuide.length
    }
}
