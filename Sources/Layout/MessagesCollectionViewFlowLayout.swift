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
            textMessageAttributesCache.removeAllObjects()
            attributedTextMessageAttributesCache.removeAllObjects()
            emojiMessageAttributesCache.removeAllObjects()
        }
    }

    internal var emojiLabelFont: UIFont

    // MARK: - Layout

    open var textMessageLayout = TextMessageLayout() {
        didSet { textMessageAttributesCache.removeAllObjects() }
    }

    open var attributedTextMessageLayout = TextMessageLayout() {
        didSet { attributedTextMessageAttributesCache.removeAllObjects() }
    }

    open var emojiMessageLayout = TextMessageLayout() {
        didSet { emojiMessageAttributesCache.removeAllObjects() }
    }

    open var photoMessageLayout = MediaMessageLayout() {
        didSet { photoMessageAttributesCache.removeAllObjects() }
    }

    open var videoMessageLayout = MediaMessageLayout() {
        didSet { videoMessageAttributesCache.removeAllObjects() }
    }

    open var locationMessageLayout = MediaMessageLayout() {
        didSet { locationMessageAttributesCache.removeAllObjects() }
    }

    open var customMessageLayout: MessageCellLayout? {
        didSet { customMessageAttributesCache.removeAllObjects() }
    }

    private let textMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()
    private let attributedTextMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()
    private let emojiMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()
    private let photoMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()
    private let videoMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()
    private let locationMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()
    private let customMessageAttributesCache = NSCache<NSString, MessageIntermediateLayoutAttributes>()

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

    // MARK: - Attributes

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else {
            return nil
        }
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            configure(attributes: attributes)
        }
        return attributesArray
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else {
            return nil
        }
        if attributes.representedElementCategory == .cell {
            configure(attributes: attributes)
        }
        return attributes
    }

    private func intermediateLayoutAttributes(for message: MessageType, at indexPath: IndexPath) -> MessageIntermediateLayoutAttributes {

        let cache = attributeCache(for: message.data)
        guard let cachedAttributes = cache.object(forKey: message.messageId as NSString) else {
            let attributes = MessageIntermediateLayoutAttributes()

            attributes.avatarSize = avatarSize(for: message, at: indexPath)
            attributes.avatarPosition = avatarPosition(for: message, at: indexPath)

            attributes.messageContainerPadding = messageContainerPadding(for: message, at: indexPath)
            attributes.messageContainerSize = messageContainerSize(for: message, at: indexPath)

            attributes.topLabelAlignment = cellTopLabelAlignment(for: message, at: indexPath)
            attributes.topLabelSize = cellTopLabelSize(for: message, at: indexPath)

            attributes.bottomLabelAlignment = cellBottomLabelAlignment(for: message, at: indexPath)
            attributes.bottomLabelSize = cellBottomLabelSize(for: message, at: indexPath)

            switch message.data {
            case .emoji:
                attributes.messageLabelFont = emojiLabelFont
                attributes.messageLabelInsets = messageLabelInsets(for: message, at: indexPath)
            case .text:
                attributes.messageLabelFont = messageLabelFont
                attributes.messageLabelInsets = messageLabelInsets(for: message, at: indexPath)
            case .attributedText(let text):
                attributes.messageLabelInsets = messageLabelInsets(for: message, at: indexPath)
                attributes.messageLabelFont = messageLabelFont
                guard !text.string.isEmpty else { return attributes }
                guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return attributes }
                attributes.messageLabelFont = font
            default:
                break
            }

            if messagesLayoutDelegate.shouldCacheLayoutAttributes(for: message) {
                let cache = attributeCache(for: message.data)
                cache.setObject(attributes, forKey: message.messageId as NSString)
            }

            return attributes
        }

        return cachedAttributes
    }

    private func configure(attributes: MessagesCollectionViewLayoutAttributes) {

        let indexPath = attributes.indexPath
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        let intermediateAttributes = intermediateLayoutAttributes(for: message, at: indexPath)

        attributes.avatarSize = intermediateAttributes.avatarSize
        attributes.avatarPosition = intermediateAttributes.avatarPosition

        attributes.messageContainerPadding = intermediateAttributes.messageContainerPadding
        attributes.messageContainerSize = intermediateAttributes.messageContainerSize

        attributes.topLabelAlignment = intermediateAttributes.topLabelAlignment
        attributes.topLabelSize = intermediateAttributes.topLabelSize

        attributes.bottomLabelAlignment = intermediateAttributes.bottomLabelAlignment
        attributes.bottomLabelSize = intermediateAttributes.bottomLabelSize

        switch message.data {
        case .emoji:
            attributes.messageLabelFont = emojiLabelFont
            attributes.messageLabelInsets = intermediateAttributes.messageLabelInsets
        case .text:
            attributes.messageLabelFont = messageLabelFont
            attributes.messageLabelInsets = intermediateAttributes.messageLabelInsets
        case .attributedText(let text):
            attributes.messageLabelInsets = intermediateAttributes.messageLabelInsets
            attributes.messageLabelFont = intermediateAttributes.messageLabelFont
            guard !text.string.isEmpty else { return }
            guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
            attributes.messageLabelFont = font
        default:
            break
        }
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

    /// Removes the cached layout information for all `MessageType`s.
    public func removeAllCachedAttributes() {
        textMessageAttributesCache.removeAllObjects()
        attributedTextMessageAttributesCache.removeAllObjects()
        emojiMessageAttributesCache.removeAllObjects()
        photoMessageAttributesCache.removeAllObjects()
        videoMessageAttributesCache.removeAllObjects()
        locationMessageAttributesCache.removeAllObjects()
        customMessageAttributesCache.removeAllObjects()
    }

    public func removeAllCachedAttributes(for messageType: MessageData) {
        let cache = attributeCache(for: messageType)
        cache.removeAllObjects()
    }

    public func removeCachedAttributes(for message: MessageType) {
        let cache = attributeCache(for: message.data)
        cache.removeObject(forKey: message.messageId as NSString)
    }

    public func removeCachedAttributes(for messageId: String) {
        textMessageAttributesCache.removeObject(forKey: messageId as NSString)
        attributedTextMessageAttributesCache.removeObject(forKey: messageId as NSString)
        emojiMessageAttributesCache.removeObject(forKey: messageId as NSString)
        photoMessageAttributesCache.removeObject(forKey: messageId as NSString)
        videoMessageAttributesCache.removeObject(forKey: messageId as NSString)
        locationMessageAttributesCache.removeObject(forKey: messageId as NSString)
        customMessageAttributesCache.removeObject(forKey: messageId as NSString)
    }

    @objc
    private func handleOrientationChange(_ notification: Notification) {
        removeAllCachedAttributes()
        invalidateLayout()
    }

    // MARK: - Avatar Size

    internal func avatarPosition(for message: MessageType, at indexPath: IndexPath) -> AvatarPosition {
        let layout = layoutForMessage(message: message)
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        var position = isFromCurrentSender ? layout.outgoingAvatarPosition : layout.incomingAvatarPosition

        switch position.horizontal {
        case .cellTrailing, .cellLeading:
            break
        case .natural:
            position.horizontal = isFromCurrentSender ? .cellTrailing : .cellLeading
        }
        return position
    }

    internal func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layout = layoutForMessage(message: message)
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? layout.outgoingAvatarSize : layout.incomingAvatarSize
    }

    // MARK: - Cell Top Label Sizing

    /// Returns the size of the `cellTopLabel` in a `MessageCollectionViewCell`
    /// for a given `MessageType` and `IndexPath`.
    /// - Parameters:
    ///   - message: The `MessageType` object for the cell.
    ///   - indexPath: The `IndexPath` for the cell.
    open func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let text = messagesDataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        guard let topLabelText = text else { return .zero }
        let maxWidth = cellTopLabelMaxWidth(for: message, at: indexPath)
        return labelSize(for: topLabelText, considering: maxWidth)
    }

    internal func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        let layout = layoutForMessage(message: message)
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? layout.outgoingCellTopLabelAlignment : layout.incomingCellTopLabelAlignment
    }

    internal func cellTopLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
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

    // MARK: - Cell Bottom Label Sizing

    /// Returns the size of the `cellBottomLabel` in a `MessageCollectionViewCell`
    /// for a given `MessageType` and `IndexPath`.
    /// - Parameters:
    ///   - message: The `MessageType` object for the cell.
    ///   - indexPath: The `IndexPath` for the cell.
    open func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let text = messagesDataSource.cellBottomLabelAttributedText(for: message, at: indexPath)
        guard let bottomLabelText = text else { return .zero }
        let maxWidth = cellBottomLabelMaxWidth(for: message, at: indexPath)
        return labelSize(for: bottomLabelText, considering: maxWidth)
    }

    internal func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
        let layout = layoutForMessage(message: message)
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? layout.outgoingCellBottomLabelAlignment : layout.incomingCellBottomLabelAlignment
    }

    internal func cellBottomLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

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

    // MARK: - Message Container Sizing

    /// Returns the size of the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for a given `MessageType` and `IndexPath`.
    /// - Parameters:
    ///   - message: The `MessageType` object for the cell.
    ///   - indexPath: The `IndexPath` for the cell.
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
            return customMessageContainerSize(for: message, at: indexPath)
        }

        return messageContainerSize
    }

    /// Returns the size of the `MessageContainerView` in a `MessageCollectionViewCell`
    /// for a given `IndexPath` and `MessageType` where the `MessageData` case is `.custom(Any?)`.
    ///
    /// - Note:
    ///   Override this method to size the `MessageContainerView` for messages with `.custom` `MessageData`.
    ///   The default implementation of this method returns `CGSize.zero`.
    /// - Parameters:
    ///   - message: The `MessageType` object for the cell.
    ///   - indexPath: The `IndexPath` for the cell.
    open func customMessageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return .zero
    }

    internal func messageLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let layout = layoutForMessage(message: message) as? TextMessageLayout else {
            fatalError("Layout is not TextMessageLayout")
        }
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? layout.outgoingMessageLabelInsets : layout.incomingMessageLabelInsets
    }

    internal func messageContainerPadding(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        let layout = layoutForMessage(message: message)
        let isFromCurrentSender = messagesDataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? layout.outgoingMessagePadding : layout.incomingMessagePadding
    }

    internal func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
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

    // MARK: - Cell Sizing

    /// Returns the size of a `MessageCollectionViewCell` at a given `IndexPath`
    /// considering all of the cell's content.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` for the cell.
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let attributes = intermediateLayoutAttributes(for: message, at: indexPath)
        return CGSize(width: itemWidth, height: attributes.itemHeight)
    }
}

// MARK: - Helpers

extension MessagesCollectionViewFlowLayout {

    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let estimatedHeight = attributedText.height(considering: maxWidth)
        let estimatedWidth = attributedText.width(considering: estimatedHeight)

        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

        return CGSize(width: finalWidth, height: finalHeight)
    }

    internal func attributeCache(for messageData: MessageData) -> NSCache<NSString, MessageIntermediateLayoutAttributes> {
        switch messageData {
        case .text: return textMessageAttributesCache
        case .attributedText: return attributedTextMessageAttributesCache
        case .emoji: return emojiMessageAttributesCache
        case .photo: return photoMessageAttributesCache
        case .video: return videoMessageAttributesCache
        case .location: return locationMessageAttributesCache
        case .custom: return customMessageAttributesCache
        }
    }

    internal func layoutForMessage(message: MessageType) -> MessageCellLayout {
        switch message.data {
        case .text: return textMessageLayout
        case .attributedText: return attributedTextMessageLayout
        case .emoji: return emojiMessageLayout
        case .photo: return photoMessageLayout
        case .video: return videoMessageLayout
        case .location: return locationMessageLayout
        case .custom:
            guard let customLayout = customMessageLayout else {
                fatalError("Missing MessageCellLayout for MessageData.custom. Please set customMessageLayout")
            }
            return customLayout
        }
    }

    internal var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.layoutUsedOnForeignType)
        }
        return messagesCollectionView
    }

    internal var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return messagesDataSource
    }

    internal var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDelegate)
        }
        return messagesLayoutDelegate
    }
}
