/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

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
import AVFoundation

/// The layout object used by `MessagesCollectionView` to determine the size of all
/// framework provided `MessageCollectionViewCell` subclasses.
open class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }
    
    /// The `MessagesCollectionView` that owns this layout object.
    public var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.layoutUsedOnForeignType)
        }
        return messagesCollectionView
    }
    
    /// The `MessagesDataSource` for the layout's collection view.
    public var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return messagesDataSource
    }
    
    /// The `MessagesLayoutDelegate` for the layout's collection view.
    public var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDelegate)
        }
        return messagesLayoutDelegate
    }

    public var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    open override var collectionViewContentSize: CGSize {
        let size = super.collectionViewContentSize

        guard !isTypingIndicatorViewHidden, let delegate = messagesCollectionView.messagesLayoutDelegate else { return size }
        let typingIndicatorSize = delegate.typingIndicatorViewSize(in: messagesCollectionView)
        let inset = delegate.typingIndicatorViewTopInset(in: messagesCollectionView) + 5
        return CGSize(
            width: size.width,
            height: size.height + typingIndicatorSize.height + inset
        )
    }

    public private(set) var isTypingIndicatorViewHidden: Bool = true

    // MARK: - Initializers

    public override init() {
        super.init()
        setupView()
        setupObserver()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    private func setupView() {
        sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesCollectionViewFlowLayout.handleOrientationChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    // MARK: - Typing Indicator API

    /// Sets the typing indicator sate by inserting/deleting the `TypingIndicatorView`
    ///
    /// - Parameters:
    ///   - isHidden: A Boolean value that is to be the new state of the typing indicator
    ///   - animated: A Boolean value determining if the insertion is to be animated
    ///   - updates: A block of code that will be executed during `performBatchUpdates`
    ///              when `animated` is `TRUE` or before the `completion` block executes
    ///              when `animated` is `FALSE`
    ///   - completion: A completion block to execute after the insertion/deletion
    open func setTypingIndicatorViewHidden(_ isHidden: Bool, animated: Bool, whilePerforming updates: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {

        guard isTypingIndicatorViewHidden != isHidden else { return }
        isTypingIndicatorViewHidden = isHidden

        let ctx = UICollectionViewFlowLayoutInvalidationContext()
        ctx.invalidateSupplementaryElements(
            ofKind: MessagesCollectionView.elementKindTypingIndicator,
            at: [indexPathForTypingIndicatorView()]
        )

        if animated {
            messagesCollectionView.performBatchUpdates({ [weak self] in
                updates?()
                self?.invalidateLayout(with: ctx)
            }, completion: completion)
        } else {
            updates?()
            invalidateLayout(with: ctx)
            completion?(true)
        }
    }

    private func adjustBottomInsetForTypingIndicatorView() {
        guard let delegate = messagesCollectionView.messagesLayoutDelegate else { return }
        let height = delegate.typingIndicatorViewSize(in: messagesCollectionView).height
        let inset = delegate.typingIndicatorViewTopInset(in: messagesCollectionView)
        let totalHeight = height + inset
        let delta = isTypingIndicatorViewHidden ? -totalHeight : totalHeight
        messagesCollectionView.contentInset.bottom += delta
    }

    // MARK: - Attributes

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else {
            return nil
        }
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            if let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: MessagesCollectionView.elementKindTypingIndicator, at: attributes.indexPath) as? MessagesCollectionViewLayoutAttributes {
                attributesArray.append(supplementaryAttributes)
            }
            let cellSizeCalculator = cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributesArray
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else {
            return nil
        }
        if attributes.representedElementCategory == .cell {
            let cellSizeCalculator = cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributes
    }

    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case MessagesCollectionView.elementKindTypingIndicator:

            guard shouldDisplayTypingIndicatorView(at: indexPath) else { return nil }
            guard let delegate = messagesCollectionView.messagesLayoutDelegate else { return nil }
            let size = delegate.typingIndicatorViewSize(in: messagesCollectionView)
            guard size != .zero else { return nil }
            let inset = delegate.typingIndicatorViewTopInset(in: messagesCollectionView)
            let attributes = MessagesCollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

            if let itemAttributes = layoutAttributesForItem(at: indexPath) {
                attributes.frame = CGRect(x: itemAttributes.frame.origin.x,
                                          y: itemAttributes.frame.maxY + inset,
                                          width: size.width,
                                          height: size.height)
            }
            return attributes
        default:
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }

    public func shouldDisplayTypingIndicatorView(at indexPath: IndexPath) -> Bool {
        let isLastIndexPath = indexPath.section == messagesCollectionView.numberOfSections - 1
        return isLastIndexPath && !isTypingIndicatorViewHidden
    }

    private func indexPathForTypingIndicatorView() -> IndexPath {
        let section = messagesCollectionView.numberOfSections - 2
        return IndexPath(row: 0, section: max(section, 0))
    }

    // MARK: - Layout Invalidation

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.width != newBounds.width
    }

    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else { return context }
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = shouldInvalidateLayout(forBoundsChange: newBounds)
        return flowLayoutContext
    }

    @objc
    private func handleOrientationChange(_ notification: Notification) {
        invalidateLayout()
    }

    open override func indexPathsToInsertForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
        guard elementKind == MessagesCollectionView.elementKindTypingIndicator else {
            return super.indexPathsToInsertForSupplementaryView(ofKind: elementKind)
        }
        return [indexPathForTypingIndicatorView()]
    }

    open override func indexPathsToDeleteForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
        guard elementKind == MessagesCollectionView.elementKindTypingIndicator else {
            return super.indexPathsToDeleteForSupplementaryView(ofKind: elementKind)
        }
        return [indexPathForTypingIndicatorView()]
    }

    // MARK: - Cell Sizing

    lazy open var textMessageSizeCalculator = TextMessageSizeCalculator(layout: self)
    lazy open var attributedTextMessageSizeCalculator = TextMessageSizeCalculator(layout: self)
    lazy open var emojiMessageSizeCalculator: TextMessageSizeCalculator = {
        let sizeCalculator = TextMessageSizeCalculator(layout: self)
        sizeCalculator.messageLabelFont = UIFont.systemFont(ofSize: sizeCalculator.messageLabelFont.pointSize * 2)
        return sizeCalculator
    }()
    lazy open var photoMessageSizeCalculator = MediaMessageSizeCalculator(layout: self)
    lazy open var videoMessageSizeCalculator = MediaMessageSizeCalculator(layout: self)
    lazy open var locationMessageSizeCalculator = LocationMessageSizeCalculator(layout: self)
    lazy open var audioMessageSizeCalculator = AudioMessageSizeCalculator(layout: self)

    /// - Note:
    ///   If you override this method, remember to call MessageLayoutDelegate's customCellSizeCalculator(for:at:in:) method for MessageKind.custom messages, if necessary
    open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.kind {
        case .text:
            return textMessageSizeCalculator
        case .attributedText:
            return attributedTextMessageSizeCalculator
        case .emoji:
            return emojiMessageSizeCalculator
        case .photo:
            return photoMessageSizeCalculator
        case .video:
            return videoMessageSizeCalculator
        case .location:
            return locationMessageSizeCalculator
        case .audio:
            return audioMessageSizeCalculator
        case .custom:
            return messagesLayoutDelegate.customCellSizeCalculator(for: message, at: indexPath, in: messagesCollectionView)
        }
    }

    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let calculator = cellSizeCalculatorForItem(at: indexPath)
        return calculator.sizeForItem(at: indexPath)
    }
    
    /// Set `incomingAvatarSize` of all `MessageSizeCalculator`s
    public func setMessageIncomingAvatarSize(_ newSize: CGSize) {
        messageSizeCalculators().forEach { $0.incomingAvatarSize = newSize }
    }
    
    /// Set `outgoingAvatarSize` of all `MessageSizeCalculator`s
    public func setMessageOutgoingAvatarSize(_ newSize: CGSize) {
        messageSizeCalculators().forEach { $0.outgoingAvatarSize = newSize }
    }
    
    /// Set `incomingAvatarPosition` of all `MessageSizeCalculator`s
    public func setMessageIncomingAvatarPosition(_ newPosition: AvatarPosition) {
        messageSizeCalculators().forEach { $0.incomingAvatarPosition = newPosition }
    }
    
    /// Set `outgoingAvatarPosition` of all `MessageSizeCalculator`s
    public func setMessageOutgoingAvatarPosition(_ newPosition: AvatarPosition) {
        messageSizeCalculators().forEach { $0.outgoingAvatarPosition = newPosition }
    }

    /// Set `avatarLeadingTrailingPadding` of all `MessageSizeCalculator`s
    public func setAvatarLeadingTrailingPadding(_ newPadding: CGFloat) {
        messageSizeCalculators().forEach { $0.avatarLeadingTrailingPadding = newPadding }
    }
    
    /// Set `incomingMessagePadding` of all `MessageSizeCalculator`s
    public func setMessageIncomingMessagePadding(_ newPadding: UIEdgeInsets) {
        messageSizeCalculators().forEach { $0.incomingMessagePadding = newPadding }
    }
    
    /// Set `outgoingMessagePadding` of all `MessageSizeCalculator`s
    public func setMessageOutgoingMessagePadding(_ newPadding: UIEdgeInsets) {
        messageSizeCalculators().forEach { $0.outgoingMessagePadding = newPadding }
    }
    
    /// Set `incomingCellTopLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageIncomingCellTopLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.incomingCellTopLabelAlignment = newAlignment }
    }
    
    /// Set `outgoingCellTopLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageOutgoingCellTopLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.outgoingCellTopLabelAlignment = newAlignment }
    }
    
    /// Set `incomingCellBottomLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageIncomingCellBottomLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.incomingCellBottomLabelAlignment = newAlignment }
    }
    
    /// Set `outgoingCellBottomLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageOutgoingCellBottomLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.outgoingCellBottomLabelAlignment = newAlignment }
    }
    
    /// Set `incomingMessageTopLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageIncomingMessageTopLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.incomingMessageTopLabelAlignment = newAlignment }
    }
    
    /// Set `outgoingMessageTopLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageOutgoingMessageTopLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.outgoingMessageTopLabelAlignment = newAlignment }
    }
    
    /// Set `incomingMessageBottomLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageIncomingMessageBottomLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.incomingMessageBottomLabelAlignment = newAlignment }
    }
    
    /// Set `outgoingMessageBottomLabelAlignment` of all `MessageSizeCalculator`s
    public func setMessageOutgoingMessageBottomLabelAlignment(_ newAlignment: LabelAlignment) {
        messageSizeCalculators().forEach { $0.outgoingMessageBottomLabelAlignment = newAlignment }
    }

    /// Set `incomingAccessoryViewSize` of all `MessageSizeCalculator`s
    public func setMessageIncomingAccessoryViewSize(_ newSize: CGSize) {
        messageSizeCalculators().forEach { $0.incomingAccessoryViewSize = newSize }
    }

    /// Set `outgoingAccessoryViewSize` of all `MessageSizeCalculator`s
    public func setMessageOutgoingAccessoryViewSize(_ newSize: CGSize) {
        messageSizeCalculators().forEach { $0.outgoingAccessoryViewSize = newSize }
    }

    /// Set `incomingAccessoryViewPadding` of all `MessageSizeCalculator`s
    public func setMessageIncomingAccessoryViewPadding(_ newPadding: HorizontalEdgeInsets) {
        messageSizeCalculators().forEach { $0.incomingAccessoryViewPadding = newPadding }
    }

    /// Set `outgoingAccessoryViewPadding` of all `MessageSizeCalculator`s
    public func setMessageOutgoingAccessoryViewPadding(_ newPadding: HorizontalEdgeInsets) {
        messageSizeCalculators().forEach { $0.outgoingAccessoryViewPadding = newPadding }
    }
    
    /// Set `incomingAccessoryViewPosition` of all `MessageSizeCalculator`s
    public func setMessageIncomingAccessoryViewPosition(_ newPosition: AccessoryPosition) {
        messageSizeCalculators().forEach { $0.incomingAccessoryViewPosition = newPosition }
    }
    
    /// Set `outgoingAccessoryViewPosition` of all `MessageSizeCalculator`s
    public func setMessageOutgoingAccessoryViewPosition(_ newPosition: AccessoryPosition) {
        messageSizeCalculators().forEach { $0.outgoingAccessoryViewPosition = newPosition }
    }

    /// Get all `MessageSizeCalculator`s
    open func messageSizeCalculators() -> [MessageSizeCalculator] {
        return [textMessageSizeCalculator,
                attributedTextMessageSizeCalculator,
                emojiMessageSizeCalculator,
                photoMessageSizeCalculator,
                videoMessageSizeCalculator,
                locationMessageSizeCalculator,
                audioMessageSizeCalculator
        ]
    }
    
}
