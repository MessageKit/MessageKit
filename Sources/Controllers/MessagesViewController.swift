// MIT License
//
// Copyright (c) 2017-2022 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import Foundation
import InputBarAccessoryView
import UIKit

/// A subclass of `UIViewController` with a `MessagesCollectionView` object
/// that is used to display conversation interfaces.
open class MessagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  // MARK: Lifecycle

  deinit {
    removeMenuControllerObservers()
    clearMemoryCache()
  }

  // MARK: Open

  /// The `MessagesCollectionView` managed by the messages view controller object.
  open var messagesCollectionView = MessagesCollectionView()

  /// The `InputBarAccessoryView` used as the `inputAccessoryView` in the view controller.
  open lazy var messageInputBar = InputBarAccessoryView()

  /// Display the date of message by swiping left.
  /// The default value of this property is `false`.
  open var showMessageTimestampOnSwipeLeft = false {
    didSet {
      messagesCollectionView.showMessageTimestampOnSwipeLeft = showMessageTimestampOnSwipeLeft
      if showMessageTimestampOnSwipeLeft {
        addPanGesture()
      } else {
        removePanGesture()
      }
    }
  }

  /// A CGFloat value that adds to (or, if negative, subtracts from) the automatically
  /// computed value of `messagesCollectionView.contentInset.bottom`. Meant to be used
  /// as a measure of last resort when the built-in algorithm does not produce the right
  /// value for your app. Please let us know when you end up having to use this property.
  open var additionalBottomInset: CGFloat = 0 {
    didSet {
      updateMessageCollectionViewBottomInset()
    }
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupDefaults()
    setupSubviews()
    setupConstraints()
    setupInputBar(for: inputBarType)
    setupDelegates()
    addObservers()
    addKeyboardObservers()
    addMenuControllerObservers()
    /// Layout input container view and update messagesCollectionViewInsets
    view.layoutIfNeeded()
  }

  open override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    updateMessageCollectionViewBottomInset()
  }

  // MARK: - UICollectionViewDataSource

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let collectionView = collectionView as? MessagesCollectionView else {
      fatalError(MessageKitError.notMessagesCollectionView)
    }
    let sections = collectionView.messagesDataSource?.numberOfSections(in: collectionView) ?? 0
    return collectionView.isTypingIndicatorHidden ? sections : sections + 1
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let collectionView = collectionView as? MessagesCollectionView else {
      fatalError(MessageKitError.notMessagesCollectionView)
    }
    if isSectionReservedForTypingIndicator(section) {
      return 1
    }
    return collectionView.messagesDataSource?.numberOfItems(inSection: section, in: collectionView) ?? 0
  }

  /// Notes:
  /// - If you override this method, remember to call MessagesDataSource's customCell(for:at:in:)
  /// for MessageKind.custom messages, if necessary.
  ///
  /// - If you are using the typing indicator you will need to ensure that the section is not
  /// reserved for it with `isSectionReservedForTypingIndicator` defined in
  /// `MessagesCollectionViewFlowLayout`
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
      fatalError(MessageKitError.notMessagesCollectionView)
    }

    guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
      fatalError(MessageKitError.nilMessagesDataSource)
    }

    if isSectionReservedForTypingIndicator(indexPath.section) {
      return messagesDataSource.typingIndicator(at: indexPath, in: messagesCollectionView)
    }

    let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

    switch message.kind {
    case .text, .attributedText, .emoji:
      if let cell = messagesDataSource.textCell(for: message, at: indexPath, in: messagesCollectionView) {
        return cell
      } else {
        let cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        return cell
      }
    case .photo, .video:
      if let cell = messagesDataSource.photoCell(for: message, at: indexPath, in: messagesCollectionView) {
        return cell
      } else {
        let cell = messagesCollectionView.dequeueReusableCell(MediaMessageCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        return cell
      }
    case .location:
      if let cell = messagesDataSource.locationCell(for: message, at: indexPath, in: messagesCollectionView) {
        return cell
      } else {
        let cell = messagesCollectionView.dequeueReusableCell(LocationMessageCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        return cell
      }
    case .audio:
      if let cell = messagesDataSource.audioCell(for: message, at: indexPath, in: messagesCollectionView) {
        return cell
      } else {
        let cell = messagesCollectionView.dequeueReusableCell(AudioMessageCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        return cell
      }
    case .contact:
      if let cell = messagesDataSource.contactCell(for: message, at: indexPath, in: messagesCollectionView) {
        return cell
      } else {
        let cell = messagesCollectionView.dequeueReusableCell(ContactMessageCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        return cell
      }
    case .linkPreview:
      let cell = messagesCollectionView.dequeueReusableCell(LinkPreviewMessageCell.self, for: indexPath)
      cell.configure(with: message, at: indexPath, and: messagesCollectionView)
      return cell
    case .custom:
      return messagesDataSource.customCell(for: message, at: indexPath, in: messagesCollectionView)
    }
  }

  open func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath)
    -> UICollectionReusableView
  {
    guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
      fatalError(MessageKitError.notMessagesCollectionView)
    }

    guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
      fatalError(MessageKitError.nilMessagesDisplayDelegate)
    }

    switch kind {
    case UICollectionView.elementKindSectionHeader:
      return displayDelegate.messageHeaderView(for: indexPath, in: messagesCollectionView)
    case UICollectionView.elementKindSectionFooter:
      return displayDelegate.messageFooterView(for: indexPath, in: messagesCollectionView)
    default:
      fatalError(MessageKitError.unrecognizedSectionKind)
    }
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  open func collectionView(
    _: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
    return messagesFlowLayout.sizeForItem(at: indexPath)
  }

  open func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int)
    -> CGSize
  {
    guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
      fatalError(MessageKitError.notMessagesCollectionView)
    }
    guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
      fatalError(MessageKitError.nilMessagesLayoutDelegate)
    }
    if isSectionReservedForTypingIndicator(section) {
      return .zero
    }
    return layoutDelegate.headerViewSize(for: section, in: messagesCollectionView)
  }

  open func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
    guard let cell = cell as? TypingIndicatorCell else { return }
    cell.typingBubble.startAnimating()
  }

  open func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int)
    -> CGSize
  {
    guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
      fatalError(MessageKitError.notMessagesCollectionView)
    }
    guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
      fatalError(MessageKitError.nilMessagesLayoutDelegate)
    }
    if isSectionReservedForTypingIndicator(section) {
      return .zero
    }
    return layoutDelegate.footerViewSize(for: section, in: messagesCollectionView)
  }

  open func collectionView(_: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return false }

    if isSectionReservedForTypingIndicator(indexPath.section) {
      return false
    }

    let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

    switch message.kind {
    case .text, .attributedText, .emoji, .photo:
      selectedIndexPathForMenu = indexPath
      return true
    default:
      return false
    }
  }

  open func collectionView(
    _: UICollectionView,
    canPerformAction action: Selector,
    forItemAt indexPath: IndexPath,
    withSender _: Any?)
    -> Bool
  {
    if isSectionReservedForTypingIndicator(indexPath.section) {
      return false
    }
    return (action == NSSelectorFromString("copy:"))
  }

  open func collectionView(_: UICollectionView, performAction _: Selector, forItemAt indexPath: IndexPath, withSender _: Any?) {
    guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
      fatalError(MessageKitError.nilMessagesDataSource)
    }
    let pasteBoard = UIPasteboard.general
    let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

    switch message.kind {
    case .text(let text), .emoji(let text):
      pasteBoard.string = text
    case .attributedText(let attributedText):
      pasteBoard.string = attributedText.string
    case .photo(let mediaItem):
      pasteBoard.image = mediaItem.image ?? mediaItem.placeholderImage
    default:
      break
    }
  }

  // MARK: Public

  public var selectedIndexPathForMenu: IndexPath?

  // MARK: Internal

  // MARK: - Internal properties

  internal let state: State = .init()

  // MARK: Private

  // MARK: - Private methods

  private func setupDefaults() {
    extendedLayoutIncludesOpaqueBars = true
    view.backgroundColor = .collectionViewBackground
    messagesCollectionView.keyboardDismissMode = .interactive
    messagesCollectionView.alwaysBounceVertical = true
    messagesCollectionView.backgroundColor = .collectionViewBackground
  }

  private func setupSubviews() {
    view.addSubviews(messagesCollectionView, inputContainerView)
  }

  private func setupConstraints() {
    messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    /// Constraints of inputContainerView are managed by keyboardManager
    inputContainerView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
      messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }

  private func setupDelegates() {
    messagesCollectionView.delegate = self
    messagesCollectionView.dataSource = self
  }

  private func setupInputBar(for kind: MessageInputBarKind) {
    inputContainerView.subviews.forEach { $0.removeFromSuperview() }

    func pinViewToInputContainer(_ view: UIView) {
      view.translatesAutoresizingMaskIntoConstraints = false
      inputContainerView.addSubviews(view)

      NSLayoutConstraint.activate([
        view.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
        view.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor),
        view.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
      ])
    }

    switch kind {
    case .messageInputBar:
      pinViewToInputContainer(messageInputBar)
    case .custom(let view):
      pinViewToInputContainer(view)
    }
  }

  private func addObservers() {
    NotificationCenter.default
      .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.clearMemoryCache()
      }
      .store(in: &disposeBag)

    state.$inputBarType
      .subscribe(on: DispatchQueue.global())
      .dropFirst()
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] newType in
        self?.setupInputBar(for: newType)
      })
      .store(in: &disposeBag)
  }

  private func clearMemoryCache() {
    MessageStyle.bubbleImageCache.removeAllObjects()
  }
}
