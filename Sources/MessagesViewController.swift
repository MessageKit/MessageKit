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
		view.addSubview(messagesCollectionView)
	}

	private func setupConstraints() {

		messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal,
		                                      toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal,
		                                      toItem: view, attribute: .leading, multiplier: 1, constant: 0))

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal,
		                                      toItem: view, attribute: .trailing, multiplier: 1, constant: 0))

		view.addConstraint(NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal,
		                                      toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -46))

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
        guard let keyboardEndSizeValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardEndSizeValue.cgRectValue
        let keyboard = self.view.convert(keyboardFrame, from: self.view.window)
        let height = self.view.frame.size.height
        let messageInputBarHeight = inputAccessoryView?.bounds.size.height ?? 0
        let keyboardHeight = keyboardFrame.height - messageInputBarHeight
        
        if (keyboard.origin.y + keyboard.size.height) > height {
            // Hardware keyboard is found
            messagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        } else {
            // Software keyboard is found
            messagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        messagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
