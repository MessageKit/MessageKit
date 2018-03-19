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
import AVFoundation

/// The layout object used by `MessagesCollectionView` to determine the size of all
/// framework provided `MessageCollectionViewCell` subclasses.
open class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }

    /// The width of an item in the `MessagesCollectionView`.
    internal var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    /// The font to be used by `TextMessageCell` for `MessageData.text(String)` case.
    ///
    /// Note: The default value of this property is `UIFont.preferredFont(forTextStyle: .body)`
    open var messageLabelFont: UIFont {
        didSet {
            emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)
        }
    }

    /// The font to be used by `TextMessageCell` for `MessageData.emoji(String)` case.
    ///
    /// Note: The default value of this property is 2x the `messageLabelFont`.
    internal var emojiLabelFont: UIFont


    // MARK: - Layout

    open var incomingAvatarSize = CGSize(width: 30, height: 30) {
        didSet { removeAllCachedAttributes() }
    }

    open var outgoingAvatarSize = CGSize(width: 30, height: 30) {
        didSet { removeAllCachedAttributes() }
    }

    open var incomingAvatarPosition = AvatarPosition(vertical: .messageBottom) {
        didSet { removeAllCachedAttributes() }
    }

    open var outgoingAvatarPosition = AvatarPosition(vertical: .messageBottom) {
        didSet { removeAllCachedAttributes() }
    }

    open var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14) {
        didSet { removeAllCachedAttributes() }
    }

    open var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18) {
        didSet { removeAllCachedAttributes() }
    }

    open var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30) {
        didSet { removeAllCachedAttributes() }
    }

    open var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4) {
        didSet { removeAllCachedAttributes() }
    }

    open var incomingCellTopLabelAlignment = LabelAlignment.messageLeading(.zero) {
        didSet { removeAllCachedAttributes() }
    }

    open var outgoingCellTopLabelAlignment = LabelAlignment.messageTrailing(.zero) {
        didSet { removeAllCachedAttributes() }
    }

    open var incomingCellBottomLabelAlignment = LabelAlignment.messageTrailing(.zero) {
        didSet { removeAllCachedAttributes() }
    }

    open var outgoingCellBottomLabelAlignment = LabelAlignment.messageLeading(.zero) {
        didSet { removeAllCachedAttributes() }
    }

    internal var attributedTextSizeCache = NSCache<NSNumber, NSValue>()

    /// Determines the maximum number of `MessageCollectionViewCell` attributes to cache.
    ///
    /// Note: The default value of this property is 500.
    open var attributesCacheMaxSize: Int = 500 {
        didSet {
            attributedTextSizeCache.countLimit = attributesCacheMaxSize
        }
    }

    /// The `MessageCellLayoutContext` for the current cell.
    internal var currentLayoutContext: MessageCellLayoutContext!

    // MARK: - Initializers

    public override init() {

        messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
        emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)

        super.init()

        sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        NotificationCenter.default.addObserver(self, selector: #selector(MessagesCollectionViewFlowLayout.handleOrientationChange(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Open

    // MARK: - Attributes

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else { return nil }

        attributesArray.forEach { attributes in
            if attributes.representedElementCategory == UICollectionElementCategory.cell {
                configure(attributes: attributes)
            }
        }

        return attributesArray
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else { return nil }

        if attributes.representedElementCategory == UICollectionElementCategory.cell {
            configure(attributes: attributes)
        }

        return attributes

    }

    // MARK: - Layout Invalidation

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if collectionView?.bounds.width != newBounds.width {
            removeAllCachedAttributes()
            return true
        } else {
            return false
        }
    }

    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else { return context }
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = shouldInvalidateLayout(forBoundsChange: newBounds)
        return flowLayoutContext
    }

    // MARK: - Avatar Size

    internal func avatarPosition(for message: MessageType, at indexPath: IndexPath) -> AvatarPosition {
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        var position = isFromCurrentSender ? outgoingAvatarPosition : incomingAvatarPosition

        switch position.horizontal {
        case .cellTrailing, .cellLeading:
            break
        case .natural:
            position.horizontal = messagesDataSource.isFromCurrentSender(message: message) ? .cellTrailing : .cellLeading
        }
        return position
    }

    internal func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAvatarSize : incomingAvatarSize
    }

    // MARK: - Cell Top Label Size


    internal func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellTopLabelAlignment : incomingCellTopLabelAlignment
    }

    /// Returns the size of the `MessageCollectionViewCell`'s top label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method sizes the label to fit.
    open func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let text = messagesDataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        guard let topLabelText = text else { return .zero }
        let maxWidth = cellTopLabelMaxWidth(for: message, at: indexPath)
        return labelSize(for: topLabelText, considering: maxWidth)
    }

    /// Returns the maximum width of the `MessageCollectionViewCell`'s top label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func cellTopLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let alignment = cellTopLabelAlignment(for: message, at: indexPath)
        let position = avatarPosition(for: message, at: indexPath)
        let avatarWidth = avatarSize(for: message, at: indexPath).width
        let containerSize = messageContainerSize(for: message, at: indexPath)
        let messagePadding = messageContainerPadding(for: message, at: indexPath)

        let avatarHorizontal = position.horizontal
        let avatarVertical = position.vertical

        switch (alignment, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellTop ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellTop ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = containerSize.width + messagePadding.left - alignment.insets.horizontal
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = containerSize.width + messagePadding.right - alignment.insets.horizontal
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - messagePadding.left - alignment.insets.horizontal

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - messagePadding.right - alignment.insets.horizontal

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
    }

    // MARK: - Cell Bottom Label Size

    internal func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellBottomLabelAlignment : incomingCellBottomLabelAlignment
    }

    /// Returns the size of the `MessageCollectionViewCell`'s bottom label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    ///
    /// - Note: The default implementation of this method sizes the label to fit.
    open func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let text = messagesDataSource.cellBottomLabelAttributedText(for: message, at: indexPath)
        guard let bottomLabelText = text else { return .zero }
        let maxWidth = cellBottomLabelMaxWidth(for: message, at: indexPath)
        return labelSize(for: bottomLabelText, considering: maxWidth)
    }

    /// Returns the maximum width of the `MessageCollectionViewCell`'s bottom label
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func cellBottomLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let alignment = cellBottomLabelAlignment(for: message, at: indexPath)
        let avatarWidth = avatarSize(for: message, at: indexPath).width
        let containerSize = messageContainerSize(for: message, at: indexPath)
        let messagePadding = messageContainerPadding(for: message, at: indexPath)
        let position = avatarPosition(for: message, at: indexPath)

        let avatarHorizontal = position.horizontal
        let avatarVertical = position.vertical

        switch (alignment, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellBottom ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - alignment.insets.horizontal
            return avatarVertical != .cellBottom ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = containerSize.width + messagePadding.left - alignment.insets.horizontal
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = containerSize.width + messagePadding.right - alignment.insets.horizontal
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - messagePadding.left - alignment.insets.horizontal

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - messagePadding.right - alignment.insets.horizontal

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
    }

    // MARK: - Message Container Size

    internal func messageLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }

    internal func messageContainerPadding(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessagePadding : incomingMessagePadding
    }

    /// Returns the maximum width of the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let avatarWidth = avatarSize(for: message, at: indexPath).width
        let messagePadding = messageContainerPadding(for: message, at: indexPath)

        switch message.data {
        case .text, .attributedText:
            let messageInsets = messageLabelInsets(for: message, at: indexPath)
            return itemWidth - avatarWidth - messagePadding.horizontal - messageInsets.horizontal
        default:
            return itemWidth - avatarWidth - messagePadding.horizontal
        }
    }

    /// Returns the size of the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for the `MessageType` at a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)

        var messageContainerSize: CGSize = .zero

        switch message.data {
        case .text(let text):
            let messageInsets = messageLabelInsets(for: message, at: indexPath)
            let attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
            messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
            messageContainerSize.width += messageInsets.horizontal
            messageContainerSize.height += messageInsets.vertical
        case .attributedText(let text):
            let messageInsets = messageLabelInsets(for: message, at: indexPath)
            messageContainerSize = labelSize(for: text, considering: maxWidth)
            messageContainerSize.width += messageInsets.horizontal
            messageContainerSize.height += messageInsets.vertical
        case .emoji(let text):
            let messageInsets = messageLabelInsets(for: message, at: indexPath)
            let attributedText = NSAttributedString(string: text, attributes: [.font: emojiLabelFont])
            messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
            messageContainerSize.width += messageInsets.horizontal
            messageContainerSize.height += messageInsets.vertical
        case .photo, .video:
            let width = messagesLayoutDelegate.widthForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .location:
            let width = messagesLayoutDelegate.widthForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .custom:
            fatalError(MessageKitError.customDataUnresolvedSize)
        }

        return messageContainerSize
    }

    // MARK: - Cell Size

    /// Returns the height of a `MessageCollectionViewCell`'s content at a given `IndexPath`
    ///
    /// - Parameters:
    ///   - message: The `MessageType` for the given `IndexPath`.
    ///   - indexPath: The `IndexPath` for the given `MessageType`.
    open func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let avatarVerticalPosition = avatarPosition(for: message, at: indexPath).vertical
        let avatarHeight = avatarSize(for: message, at: indexPath).height
        let messageContainerHeight = messageContainerSize(for: message, at: indexPath).height
        let bottomLabelHeight = cellBottomLabelSize(for: message, at: indexPath).height
        let topLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
        let messageVerticalPadding = messageContainerPadding(for: message, at: indexPath).vertical

        var cellHeight: CGFloat = 0

        switch avatarVerticalPosition {
        case .cellTop:
            cellHeight += max(avatarHeight, topLabelHeight)
            cellHeight += bottomLabelHeight
            cellHeight += messageContainerHeight
            cellHeight += messageVerticalPadding
        case .cellBottom:
            cellHeight += max(avatarHeight, bottomLabelHeight)
            cellHeight += topLabelHeight
            cellHeight += messageContainerHeight
            cellHeight += messageVerticalPadding
        case .messageTop, .messageCenter, .messageBottom:
            cellHeight += max(avatarHeight, messageContainerHeight)
            cellHeight += messageVerticalPadding
            cellHeight += topLabelHeight
            cellHeight += bottomLabelHeight
        }

        return cellHeight
    }

    /// Returns the size for the `MessageCollectionViewCell` at a given `IndexPath`
    /// considering all of the cell's content.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` of the cell.
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let itemHeight = cellContentHeight(for: message, at: indexPath)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Cache Invalidation

extension MessagesCollectionViewFlowLayout {

    /// Removes the cached layout information for all `MessageType`s.
    public func removeAllCachedAttributes() {
        attributedTextSizeCache.removeAllObjects()
    }

    @objc
    private func handleOrientationChange(_ notification: Notification) {
        removeAllCachedAttributes()
        invalidateLayout()
    }
}

// MARK: - MessagesCollectionViewLayoutAttributes

extension MessagesCollectionViewFlowLayout {

    private func configure(attributes: MessagesCollectionViewLayoutAttributes) {

        let indexPath = attributes.indexPath
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        attributes.avatarSize = avatarSize(for: message, at: indexPath)
        attributes.avatarPosition = avatarPosition(for: message, at: indexPath)

        attributes.messageContainerPadding = messageContainerPadding(for: message, at: indexPath)
        attributes.messageContainerSize = messageContainerSize(for: message, at: indexPath)
        attributes.messageLabelInsets = messageLabelInsets(for: message, at: indexPath)

        attributes.topLabelAlignment = cellTopLabelAlignment(for: message, at: indexPath)
        attributes.topLabelSize = cellTopLabelSize(for: message, at: indexPath)

        attributes.bottomLabelAlignment = cellBottomLabelAlignment(for: message, at: indexPath)
        attributes.bottomLabelSize = cellBottomLabelSize(for: message, at: indexPath)

        switch message.data {
        case .emoji:
            attributes.messageLabelFont = emojiLabelFont
        case .text:
            attributes.messageLabelFont = messageLabelFont
        case .attributedText(let text):
            guard !text.string.isEmpty else { return }
            guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
            attributes.messageLabelFont = font
        default:
            break
        }
    }
}

// MARK: - Helpers

extension MessagesCollectionViewFlowLayout {

    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {

        guard let cachedSize = attributedTextSizeCache.object(forKey: attributedText.hash as NSNumber)?.cgSizeValue else {
            let estimatedHeight = attributedText.height(considering: maxWidth)
            let estimatedWidth = attributedText.width(considering: estimatedHeight)

            let finalHeight = estimatedHeight.rounded(.up)
            let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

            let size = CGSize(width: finalWidth, height: finalHeight)
            attributedTextSizeCache.setObject(size as NSValue, forKey: attributedText.hash as NSNumber)
            return size
        }

        return cachedSize
    }

    /// Convenience property for accessing the layout object's `MessagesCollectionView`.
    internal var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.layoutUsedOnForeignType)
        }
        return messagesCollectionView
    }

    /// Convenience property for unwrapping the `MessagesCollectionView`'s `MessagesDataSource`.
    internal var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return messagesDataSource
    }

    /// Convenience property for unwrapping the `MessagesCollectionView`'s `MessagesLayoutDelegate`.
    internal var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDelegate)
        }
        return messagesLayoutDelegate
    }
}
