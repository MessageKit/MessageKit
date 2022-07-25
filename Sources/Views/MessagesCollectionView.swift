// MIT License
//
// Copyright (c) 2017-2020 MessageKit
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

import Foundation
import UIKit

open class MessagesCollectionView: UICollectionView {
  // MARK: Lifecycle

  // MARK: - Initializers

  public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    backgroundColor = .collectionViewBackground
    registerReusableViews()
    setupGestureRecognizers()
  }

  required public init?(coder _: NSCoder) {
    super.init(frame: .zero, collectionViewLayout: MessagesCollectionViewFlowLayout())
  }

  public convenience init() {
    self.init(frame: .zero, collectionViewLayout: MessagesCollectionViewFlowLayout())
  }

  // MARK: Open

  // MARK: - Properties

  open weak var messagesDataSource: MessagesDataSource?

  open weak var messagesDisplayDelegate: MessagesDisplayDelegate?

  open weak var messagesLayoutDelegate: MessagesLayoutDelegate?

  open weak var messageCellDelegate: MessageCellDelegate?

  open var isTypingIndicatorHidden: Bool {
    messagesCollectionViewFlowLayout.isTypingIndicatorViewHidden
  }

  open var messagesCollectionViewFlowLayout: MessagesCollectionViewFlowLayout {
    guard let layout = collectionViewLayout as? MessagesCollectionViewFlowLayout else {
      fatalError(MessageKitError.layoutUsedOnForeignType)
    }
    return layout
  }

  @objc
  open func handleTapGesture(_ gesture: UIGestureRecognizer) {
    guard gesture.state == .ended else { return }

    let touchLocation = gesture.location(in: self)
    guard let indexPath = indexPathForItem(at: touchLocation) else { return }

    let cell = cellForItem(at: indexPath) as? MessageCollectionViewCell
    cell?.handleTapGesture(gesture)
  }

  // MARK: Public

  // NOTE: It's possible for small content size this wouldn't work - https://github.com/MessageKit/MessageKit/issues/725
  public func scrollToLastItem(at pos: UICollectionView.ScrollPosition = .bottom, animated: Bool = true) {
    guard let indexPath = indexPathForLastItem else { return }

    scrollToItem(at: indexPath, at: pos, animated: animated)
  }

  public func reloadDataAndKeepOffset() {
    // stop scrolling
    setContentOffset(contentOffset, animated: false)

    // calculate the offset and reloadData
    let beforeContentSize = contentSize
    reloadData()
    layoutIfNeeded()
    let afterContentSize = contentSize

    // reset the contentOffset after data is updated
    let newOffset = CGPoint(
      x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
      y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
    setContentOffset(newOffset, animated: false)
  }

  /// A method that by default checks if the section is the last in the
  /// `messagesCollectionView` and that `isTypingIndicatorViewHidden`
  /// is FALSE
  ///
  /// - Parameter section
  /// - Returns: A Boolean indicating if the TypingIndicator should be presented at the given section
  public func isSectionReservedForTypingIndicator(_ section: Int) -> Bool {
    messagesCollectionViewFlowLayout.isSectionReservedForTypingIndicator(section)
  }

  // MARK: - View Register/Dequeue

  /// Registers a particular cell using its reuse-identifier
  public func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellWithReuseIdentifier: String(describing: T.self))
  }

  /// Registers a reusable view for a specific SectionKind
  public func register<T: UICollectionReusableView>(_ reusableViewClass: T.Type, forSupplementaryViewOfKind kind: String) {
    register(
      reusableViewClass,
      forSupplementaryViewOfKind: kind,
      withReuseIdentifier: String(describing: T.self))
  }

  /// Registers a nib with reusable view for a specific SectionKind
  public func register<T: UICollectionReusableView>(
    _ nib: UINib? = UINib(nibName: String(describing: T.self), bundle: nil),
    headerFooterClassOfNib _: T.Type,
    forSupplementaryViewOfKind kind: String)
  {
    register(
      nib,
      forSupplementaryViewOfKind: kind,
      withReuseIdentifier: String(describing: T.self))
  }

  /// Generically dequeues a cell of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
  public func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(String(describing: T.self))")
    }
    return cell
  }

  /// Generically dequeues a header of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
  public func dequeueReusableHeaderView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: String(describing: T.self),
      for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }

  /// Generically dequeues a footer of the correct type allowing you to avoid scattering your code with guard-let-else-fatal
  public func dequeueReusableFooterView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: String(describing: T.self),
      for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }

  // MARK: Internal

  /// Display the date of message by swiping left.
  /// The default value of this property is `false`.
  internal var showMessageTimestampOnSwipeLeft = false

  // MARK: - Typing Indicator API

  /// Notifies the layout that the typing indicator will change state
  ///
  /// - Parameters:
  ///   - isHidden: A Boolean value that is to be the new state of the typing indicator
  internal func setTypingIndicatorViewHidden(_ isHidden: Bool) {
    messagesCollectionViewFlowLayout.setTypingIndicatorViewHidden(isHidden)
  }

  // MARK: Private

  private var indexPathForLastItem: IndexPath? {
    guard numberOfSections > 0 else { return nil }

    for offset in 1 ... numberOfSections {
      let section = numberOfSections - offset
      let lastItem = numberOfItems(inSection: section) - 1
      if lastItem >= 0 {
        return IndexPath(item: lastItem, section: section)
      }
    }
    return nil
  }

  // MARK: - Methods

  private func registerReusableViews() {
    register(TextMessageCell.self)
    register(MediaMessageCell.self)
    register(LocationMessageCell.self)
    register(AudioMessageCell.self)
    register(ContactMessageCell.self)
    register(TypingIndicatorCell.self)
    register(LinkPreviewMessageCell.self)
    register(MessageReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    register(MessageReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
  }

  private func setupGestureRecognizers() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    tapGesture.delaysTouchesBegan = true
    addGestureRecognizer(tapGesture)
  }
}
