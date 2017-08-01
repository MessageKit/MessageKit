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

	open override func viewDidLoad() {
		super.viewDidLoad()

		automaticallyAdjustsScrollViewInsets = false

		setupSubviews()
		setupConstraints()
		registerReusableViews()
		setupDelegates()

        //messageInputBar.inputTextView.delegate = self

        inputAccessoryView?.autoresizingMask = .flexibleHeight

	}

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesCollectionView.scrollToBottom(animated: true)
    }

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// depends on inputAccessoryView frame thus must be called here
		addKeyboardObservers()
        messagesCollectionView.scrollToBottom(animated: false)
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeKeyboardObservers()
	}

	// MARK: - Methods

	private func setupDelegates() {
		messagesCollectionView.delegate = self
		messagesCollectionView.dataSource = self
	}

	private func registerReusableViews() {
		messagesCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")
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
		                                      toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -48))

	}

}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout Conformance

//swiftlint:disable line_length

extension MessagesViewController: UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
		return messagesFlowLayout.sizeForItem(at: indexPath)
	}

}

//swiftlint:enable line_length

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

    //swiftlint:disable line_length

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCollectionViewCell ?? MessageCollectionViewCell()

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

    //swiftlint:enable line_length

}

// MARK: - Keyboard methods
extension MessagesViewController {

	fileprivate func addKeyboardObservers() {

		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)

	}

	fileprivate func removeKeyboardObservers() {

		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)

	}

	func handleKeyboardWillHide(_ notification: Notification) {

		messagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	}

	func handleKeyboardWillChangeFrame(_ notification: Notification) {

		guard let keyboardSizeValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }

		let keyboardRect = keyboardSizeValue.cgRectValue
		let messageInputBarHeight = inputAccessoryView?.bounds.size.height ?? 0
		let keyboardHeight = keyboardRect.height - messageInputBarHeight
		messagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

	}

}
