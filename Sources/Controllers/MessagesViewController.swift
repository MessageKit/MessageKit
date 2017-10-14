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

    open var messagesCollectionView = MessagesCollectionView()

    open var messageInputBar = MessageInputBar()
    
    open var scrollsToBottomOnFirstLayout: Bool = false

    open var scrollsToBottomOnKeybordBeginsEditing: Bool = false

    private var isFirstLayout: Bool = true

    open override var canBecomeFirstResponder: Bool {
        return true
    }

    open override var inputAccessoryView: UIView? {
        return messageInputBar
    }

    open override var shouldAutorotate: Bool {
        return false
    }

    // MARK: - View Life Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        messagesCollectionView.keyboardDismissMode = .interactive

        setupSubviews()
        setupConstraints()
        registerReusableViews()
        setupDelegates()

		self.addMenuControllerObservers()
    }
	
	fileprivate func addMenuControllerObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.menuControllerWillShow(aNotification:)), name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.menuControllerDidHide(aNotification:)), name: NSNotification.Name.UIMenuControllerDidHideMenu, object: nil)
	}
	
	fileprivate func removeMenuControllerObservers() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerDidHideMenu, object: nil)
	}
	
	fileprivate var targetedCell:UICollectionViewCell?
	fileprivate var targetedFrame = CGRect.zero
	@objc func menuControllerWillShow(aNotification:Notification) {
		if let currentMenuController = aNotification.object as? UIMenuController,
			let currentTargetedCell = targetedCell {
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
			currentMenuController.setMenuVisible(false, animated: false)
			currentMenuController.setTargetRect(self.targetedFrame, in: currentTargetedCell)
			currentMenuController.setMenuVisible(true, animated: true)
			self.messagesCollectionView.isUserInteractionEnabled = false
		}
	}
	
	@objc func menuControllerDidHide(aNotification:Notification) {
		NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.menuControllerWillShow(aNotification:)), name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
		self.messagesCollectionView.isUserInteractionEnabled = true
		self.targetedCell = nil
	}

    open override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }

            addKeyboardObservers()
            messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
            messagesCollectionView.scrollIndicatorInsets.bottom = messageInputBar.frame.height
            
            //Scroll to bottom at first load
            if scrollsToBottomOnFirstLayout {
                messagesCollectionView.scrollToBottom(animated: false)
            }
        }
    }

    // MARK: - Initializers

    deinit {
        removeKeyboardObservers()
		removeMenuControllerObservers()
    }

    // MARK: - Methods

    private func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }

    private func registerReusableViews() {

        messagesCollectionView.register(TextMessageCell.self)
        messagesCollectionView.register(MediaMessageCell.self)
        messagesCollectionView.register(LocationMessageCell.self)

        messagesCollectionView.register(MessageFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter)
        messagesCollectionView.register(MessageHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
        messagesCollectionView.register(MessageDateHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)

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
}

// MARK: - UICollectionViewDelegate

extension MessagesViewController: UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
		
		guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return false }
		let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
		
		switch message.data {
		case .text, .attributedText, .photo:
			if let selectedTextMessageCell = collectionView.cellForItem(at: indexPath) as? TextMessageCell {
				self.targetedFrame = selectedTextMessageCell.messageContainerView.frame
				self.targetedCell = selectedTextMessageCell
				return true
			}
			else if let selectedMediaMessageCell = collectionView.cellForItem(at: indexPath) as? MediaMessageCell {
				self.targetedFrame = selectedMediaMessageCell.messageContainerView.frame
				self.targetedCell = selectedMediaMessageCell
				return true
			}
		default:
			break
		}
		
		return false
	}
	
	public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
		return (action == NSSelectorFromString("copy:"))
	}
	
	public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
		
		guard let messagesDataSource = messagesCollectionView.messagesDataSource else { fatalError("Please set messagesDataSource") }
		let pasteBoard = UIPasteboard.general
		let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
		
		
		switch message.data {
		case .text, .attributedText:
			switch message.data {
			case .text(let text):
				pasteBoard.string = text
			case .attributedText(let text):
				pasteBoard.string = text.string
			default:
				break
			}
		case .photo:
			switch message.data {
			case .photo(let image):
				pasteBoard.image = image
			default:
				break
			}
		default:
			break
		}
	}
}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout Conformance

extension MessagesViewController: UICollectionViewDelegateFlowLayout {

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }

}

// MARK: - UICollectionViewDataSource Conformance

extension MessagesViewController: UICollectionViewDataSource {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else { return 0 }

        // Each message is its own section
        return collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else { return 0 }

        let messageCount = collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
        // There will only ever be 1 message per section
        return messageCount > 0 ? 1 : 0

    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("Managed collectionView: \(collectionView.debugDescription) is not a MessagesCollectionView.")
        }

        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch message.data {
        case .text, .attributedText, .emoji:
            let cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .photo, .video:
    	    let cell = messagesCollectionView.dequeueReusableCell(MediaMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .location:
    	    let cell = messagesCollectionView.dequeueReusableCell(LocationMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }

    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("Managed collectionView: \(collectionView.debugDescription) is not a MessagesCollectionView.")
        }

        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesDisplayDelegate has not been set.")
        }

        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch kind {
        case UICollectionElementKindSectionHeader:
            return displayDelegate.messageHeaderView(for: message, at: indexPath, in: messagesCollectionView)
        case UICollectionElementKindSectionFooter:
            return displayDelegate.messageFooterView(for: message, at: indexPath, in: messagesCollectionView)
        default:
            fatalError("Unrecognized element of kind: \(kind)")
        }

    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        // Could pose a problem if subclass behaviors allows more than one item per section
        let indexPath = IndexPath(item: 0, section: section)
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        return messagesLayoutDelegate.headerViewSize(for: message, at: indexPath, in: messagesCollectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidBeginEditing), name: .UITextViewTextDidBeginEditing, object: messageInputBar.inputTextView)
    }

    fileprivate func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidBeginEditing, object: messageInputBar.inputTextView)
    }

    @objc func handleTextViewDidBeginEditing(_ notification: Notification) {
        if scrollsToBottomOnKeybordBeginsEditing {
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    @objc func handleKeyboardDidChangeState(_ notification: Notification) {

        guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        if (keyboardEndFrame.origin.y + keyboardEndFrame.size.height) > UIScreen.main.bounds.height {
            // Hardware keyboard is found
            let bottomInset = view.frame.size.height - keyboardEndFrame.origin.y
            messagesCollectionView.contentInset.bottom = bottomInset
            messagesCollectionView.scrollIndicatorInsets.bottom = bottomInset

        } else {
            //Software keyboard is found
            let bottomInset = keyboardEndFrame.height > messageInputBar.frame.height ? keyboardEndFrame.height : messageInputBar.frame.height
            messagesCollectionView.contentInset.bottom = bottomInset
            messagesCollectionView.scrollIndicatorInsets.bottom = bottomInset
        }
        
    }
    
}
