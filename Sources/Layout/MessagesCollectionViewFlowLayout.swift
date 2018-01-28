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

    /// A type property representing the `MessagesCollectionViewLayoutAttributes` to be used.
    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }

    /// The width of an item in the `MessageCollectionViewCell`.
    internal var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    /// Font to be used by `TextMessageCell` for `MessageData.text(String)` case.
    ///
    /// The default value of this property is `UIFont.preferredFont(forTextStyle: .body)`
    open var messageLabelFont: UIFont {
        didSet {
            emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)
        }
    }

    /// Font to be used by `TextMessageCell` for `MessageData.emoji(String)` case.
    ///
    /// The default value of this property is 2x the `messageLabelFont`.
    internal var emojiLabelFont: UIFont

    /// Determines the maximum number of `MessageCollectionViewCell` attributes to cache.
    ///
    /// The default value of this property is 500.
    open var attributesCacheMaxSize: Int = 500

    typealias MessageID = String
    
    /// The cache for `MessageIntermediateLayoutAttributes`.
    /// The key is the `messageId` of the `MessageType`.
    fileprivate var layoutContextCache: [MessageID: MessageCellLayoutContext] = [:]

    var currentLayoutContext: MessageCellLayoutContext!

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
}

// MARK: - Cache Invalidation

extension MessagesCollectionViewFlowLayout {

    /// Removes the cached layout information for a given `MessageType` using the `messageId`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` whose cached layout information is to be removed.
    public func removeCachedAttributes(for message: MessageType) {
        removeCachedAttributes(for: message.messageId)
    }

    /// Removes the cached layout information for a `MessageType` given its `messageId`.
    ///
    /// - Parameters:
    ///   - messageId: The `messageId` for the `MessageType` whose cached layout information is to be removed.
    public func removeCachedAttributes(for messageId: String) {
        layoutContextCache.removeValue(forKey: messageId)
    }

    /// Removes the cached layout information for all `MessageType`s.
    public func removeAllCachedAttributes() {
        layoutContextCache.removeAll()
    }

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

    /// Invalidates the layout and removes all cached attributes on device orientation change
    @objc
    private func handleOrientationChange(_ notification: Notification) {
        removeAllCachedAttributes()
        invalidateLayout()
    }
}

// MARK: - MessagesCollectionViewLayoutAttributes

extension MessagesCollectionViewFlowLayout {

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

    private func configure(attributes: MessagesCollectionViewLayoutAttributes) {

        let indexPath = attributes.indexPath
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let context = cellLayoutContext(for: message, at: indexPath)

        attributes.avatarSize = context.avatarSize!
        attributes.avatarPosition = context.avatarPosition!

        attributes.messageContainerPadding = context.messageContainerPadding!
        attributes.messageContainerSize = context.messageContainerSize!
        attributes.messageLabelInsets = context.messageLabelInsets!

        attributes.topLabelAlignment = context.topLabelAlignment!
        attributes.topLabelSize = context.topLabelSize!

        attributes.bottomLabelAlignment = context.bottomLabelAlignment!
        attributes.bottomLabelSize = context.bottomLabelSize!

        switch message.data {
        case .emoji:
            attributes.messageLabelFont = emojiLabelFont
        case .text:
            attributes.messageLabelFont = messageLabelFont
        case .attributedText(let text):
            guard let font = text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont else { return }
            attributes.messageLabelFont = font
        default:
            break
        }
    }
}

// MARK: - MessageCellLayoutContext

extension MessagesCollectionViewFlowLayout {

    internal func cellLayoutContext(for message: MessageType, at indexPath: IndexPath) -> MessageCellLayoutContext {
        guard let cachedContext = layoutContextCache[message.messageId] else {
            let newContext = newCellLayoutContext(for: message, at: indexPath)
            let shouldCache = messagesLayoutDelegate.shouldCacheLayoutAttributes(for: message)

            if shouldCache && layoutContextCache.count < attributesCacheMaxSize {
                layoutContextCache[message.messageId] = newContext
            }
            return newContext
        }
        return cachedContext
    }

    internal func newCellLayoutContext(for message: MessageType, at indexPath: IndexPath) -> MessageCellLayoutContext {
        currentLayoutContext = MessageCellLayoutContext()
        currentLayoutContext.avatarPosition = _avatarPosition(for: message, at: indexPath)
        currentLayoutContext.avatarSize = _avatarSize(for: message, at: indexPath)
        currentLayoutContext.messageContainerPadding = _messageContainerPadding(for: message, at: indexPath)
        currentLayoutContext.messageLabelInsets = _messageLabelInsets(for: message, at: indexPath)
        currentLayoutContext.messageContainerMaxWidth = _messageContainerMaxWidth(for: message, at: indexPath)
        currentLayoutContext.messageContainerSize = _messageContainerSize(for: message, at: indexPath)
        currentLayoutContext.topLabelAlignment = _cellTopLabelAlignment(for: message, at: indexPath)
        currentLayoutContext.topLabelMaxWidth = _cellTopLabelMaxWidth(for: message, at: indexPath)
        currentLayoutContext.topLabelSize = _cellTopLabelSize(for: message, at: indexPath)
        currentLayoutContext.bottomLabelAlignment = _cellBottomLabelAlignment(for: message, at: indexPath)
        currentLayoutContext.bottomLabelMaxWidth = _cellBottomLabelMaxWidth(for: message, at: indexPath)
        currentLayoutContext.bottomLabelSize = _cellBottomLabelSize(for: message, at: indexPath)
        currentLayoutContext.itemHeight = _cellContentHeight(for: message, at: indexPath)
        return currentLayoutContext
    }
}

// MARK: - Helpers

extension MessagesCollectionViewFlowLayout {

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
            fatalError(MessageKitError.nilMessagesLayoutDeleagte)
        }
        return messagesLayoutDelegate
    }
}
