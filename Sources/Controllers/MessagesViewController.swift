/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

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

open class MessagesViewController: UIViewController,
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - Properties [Public]

    /// The `MessagesCollectionView` managed by the messages view controller object.
    open var messagesCollectionView = MessagesCollectionView()

    /// The `MessageInputBar` used as the `inputAccessoryView` in the view controller.
    open var messageInputBar = MessageInputBar()

    /// A Boolean value that determines whether the `MessagesCollectionView` scrolls to the
    /// bottom whenever the `InputTextView` begins editing.
    ///
    /// The default value of this property is `false`.
    open var scrollsToBottomOnKeybordBeginsEditing: Bool = false
    
    /// A Boolean value that determines whether the `MessagesCollectionView`
    /// maintains it's current position when the height of the `MessageInputBar` changes.
    ///
    /// The default value of this property is `false`.
    open var maintainPositionOnKeyboardFrameChanged: Bool = false

    open override var canBecomeFirstResponder: Bool {
        return true
    }

    open override var inputAccessoryView: UIView? {
        return messageInputBar
    }

    open override var shouldAutorotate: Bool {
        return false
    }

    /// A Boolean value used to determine if `viewDidLayoutSubviews()` has been called.
    private var isFirstLayout: Bool = true
    
    /// Indicated selected indexPath when handle menu action
    var selectedIndexPathForMenu: IndexPath?

    var messageCollectionViewBottomInset: CGFloat = 0 {
        didSet {
            messagesCollectionView.contentInset.bottom = messageCollectionViewBottomInset
            messagesCollectionView.scrollIndicatorInsets.bottom = messageCollectionViewBottomInset
        }
    }

    // MARK: - View Life Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupSubviews()
        setupConstraints()
        registerReusableViews()
        setupDelegates()
        addMenuControllerObservers()
    }

    open override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
            messageCollectionViewBottomInset = keyboardOffsetFrame.height
        }
        adjustScrollViewInset()
    }

    // MARK: - Initializers

    deinit {
        removeKeyboardObservers()
        removeMenuControllerObservers()
    }

    // MARK: - Methods [Private]

    /// Sets the default values for the MessagesViewController
    private func setupDefaults() {
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        messagesCollectionView.keyboardDismissMode = .interactive
        messagesCollectionView.alwaysBounceVertical = true
    }

    /// Sets the delegate and dataSource of the messagesCollectionView property.
    private func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }

    /// Adds the messagesCollectionView to the controllers root view.
    private func setupSubviews() {
        view.addSubview(messagesCollectionView)
    }

    /// Registers all cells and supplementary views of the messagesCollectionView property.
    private func registerReusableViews() {
        messagesCollectionView.register(TextMessageCell.self)
        messagesCollectionView.register(MediaMessageCell.self)
        messagesCollectionView.register(LocationMessageCell.self)

        messagesCollectionView.register(MessageFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter)
        messagesCollectionView.register(MessageHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
        messagesCollectionView.register(MessageDateHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
    }

    /// Sets the constraints of the `MessagesCollectionView`.
    private func setupConstraints() {
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
        let bottom = messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        } else {
            let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        }
    }

    // MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        return collectionView.messagesDataSource?.numberOfMessages(in: collectionView) ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = collectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let message = dataSource.message(for: section, in: collectionView)
        return dataSource.numberOfItems(for: message, in: section, in: collectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let message = dataSource.message(for: indexPath.section, in: collectionView)
        return dataSource.messageCell(at: indexPath, for: message, in: collectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let message = dataSource.message(for: indexPath.section, in: messagesCollectionView)

        switch kind {
        case UICollectionElementKindSectionHeader:
            return dataSource.messageHeaderView(for: message, at: indexPath, in: collectionView)
        case UICollectionElementKindSectionFooter:
            return dataSource.messageFooterView(for: message, at: indexPath, in: collectionView)
        default:
            fatalError(MessageKitError.unrecognizedSectionKind)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDeleagte)
        }
        let message = dataSource.message(for: section, in: messagesCollectionView)
        return layoutDelegate.headerViewSize(for: message, in: section, in: messagesCollectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDeleagte)
        }
        let message = dataSource.message(for: section, in: messagesCollectionView)
        return layoutDelegate.footerViewSize(for: message, in: section, in: messagesCollectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return false }
        let message = messagesDataSource.message(for: indexPath.section, in: messagesCollectionView)

        switch message.messageData(for: indexPath) {
        case .text, .attributedText, .emoji, .photo:
            selectedIndexPathForMenu = indexPath
            return true
        default:
            return false
        }
    }

    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return (action == NSSelectorFromString("copy:"))
    }

    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let pasteBoard = UIPasteboard.general
        let message = messagesDataSource.message(for: indexPath.section, in: messagesCollectionView)

        switch message.messageData(for: indexPath) {
        case .text(let text), .emoji(let text):
            pasteBoard.string = text
        case .attributedText(let attributedText):
            pasteBoard.string = attributedText.string
        case .photo(let image):
            pasteBoard.image = image
        default:
            break
        }
    }
}
