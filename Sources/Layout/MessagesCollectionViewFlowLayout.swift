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

    // MARK: - Properties [Public]

    /// Font to be used by `TextMessageCell` for `MessageData.text(String)` case.
    ///
    /// The default value of this property is `UIFont.preferredFont(forTextStyle: .body)`
    open var messageLabelFont: UIFont {
        didSet {
            emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)
        }
    }

    /// Determines the maximum number of `MessageCollectionViewCell` attributes to cache.
    ///
    /// The default value of this property is 500.
    open var attributesCacheMaxSize: Int = 500
    
    /// A type property representing the `MessagesCollectionViewLayoutAttributes` to be used.
    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }
    
    // MARK: - Properties [Private]
    
    /// Font to be used by `TextMessageCell` for `MessageData.emoji(String)` case.
    ///
    /// The default value of this property is 2x the `messageLabelFont`.
    private var emojiLabelFont: UIFont

    typealias MessageID = String
    
    /// The cache for `MessageIntermediateLayoutAttributes`.
    /// The key is the `messageId` of the `MessageType`.
    fileprivate var intermediateAttributesCache: [MessageID: MessageIntermediateLayoutAttributes] = [:]
    
    /// Convenience property for accessing the layout object's `MessagesCollectionView`.
    fileprivate var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.layoutUsedOnForeignType)
        }
        return messagesCollectionView
    }

    /// Convenience property for unwrapping the `MessagesCollectionView`'s `MessagesDataSource`.
    fileprivate var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return messagesDataSource
    }

    /// Convenience property for unwrapping the `MessagesCollectionView`'s `MessagesLayoutDelegate`.
    fileprivate var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDeleagte)
        }
        return messagesLayoutDelegate
    }

    /// The width of an item in the `MessageCollectionViewCell`.
    fileprivate var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    // MARK: - Initializers [Public]

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

    /// Invalidates the layout and removes all cached attributes on device orientation change
    @objc
    private func handleOrientationChange(_ notification: Notification) {
        removeAllCachedAttributes()
        invalidateLayout()
    }

    // MARK: - Methods [Public]
    
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
        intermediateAttributesCache.removeValue(forKey: messageId)
    }
    
    /// Removes the cached layout information for all `MessageType`s.
    public func removeAllCachedAttributes() {
        intermediateAttributesCache.removeAll()
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
    
    /// The size for the `MessageCollectionViewCell` considering all of the cell's contents.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` of the cell.
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let attributes = messageIntermediateLayoutAttributes(for: indexPath)
        return CGSize(width: itemWidth, height: attributes.itemHeight)
    }

}

// MARK: - Calculating MessageIntermediateLayoutAttributes

fileprivate extension MessagesCollectionViewFlowLayout {
    
    /// Returns the cached `MessageIntermediateLayoutAttributes` for a given `IndexPath` (if any).
    /// If no cached attributes exist, new attributes will be created.
    /// - Parameters:
    ///   - indexPath: The `IndexPath` used to retrieve the `MessageType`.
    func messageIntermediateLayoutAttributes(for indexPath: IndexPath) -> MessageIntermediateLayoutAttributes {
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if let intermediateAttributes = intermediateAttributesCache[message.messageId] {
            return intermediateAttributes
        } else {
            let newAttributes = createMessageIntermediateLayoutAttributes(for: message, at: indexPath)

            let shouldCache = messagesLayoutDelegate.shouldCacheLayoutAttributes(for: message) && intermediateAttributesCache.count < attributesCacheMaxSize
            
            if shouldCache {
                intermediateAttributesCache[message.messageId] = newAttributes
            }
            return newAttributes
        }
        
    }
    
    /// Returns newly created `MessageIntermediateAttributes` for a given `MessageType` and `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` representing the attributes.
    ///   - indexPath: The current `IndexPath` of the `MessageCollectionViewCell`.
    func createMessageIntermediateLayoutAttributes(for message: MessageType, at indexPath: IndexPath) -> MessageIntermediateLayoutAttributes {
        
        let attributes = MessageIntermediateLayoutAttributes(message: message, indexPath: indexPath)
        
        // None of these are dependent on other attributes
        attributes.avatarPosition = avatarPosition(for: attributes)
        attributes.avatarSize = avatarSize(for: attributes)
        attributes.messageContainerPadding = messageContainerPadding(for: attributes)
        attributes.messageLabelInsets = messageLabelInsets(for: attributes)
        
        // MessageContainerView
        attributes.messageContainerMaxWidth = messageContainerMaxWidth(for: attributes)
        attributes.messageContainerSize = messageContainerSize(for: attributes)
        
        // Cell Bottom Label
        attributes.bottomLabelAlignment = cellBottomLabelAlignment(for: attributes)
        attributes.bottomLabelMaxWidth = cellBottomLabelMaxWidth(for: attributes)
        attributes.bottomLabelSize = cellBottomLabelSize(for: attributes)
        
        // Cell Top Label
        attributes.topLabelAlignment = cellTopLabelAlignment(for: attributes)
        attributes.topLabelMaxWidth = cellTopLabelMaxWidth(for: attributes)
        attributes.topLabelSize = cellTopLabelSize(for: attributes)
        
        // Cell Height
        attributes.itemHeight = cellHeight(for: attributes)
        
        return attributes
    }
    
    /// Configures the `MessagesCollectionViewLayoutAttributes` by applying the layout information
    /// from `MessageIntermediateLayoutAttributes` and calculating the origins of the cell's contents.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageCollectionViewLayoutAttributes` to apply the layout information to.
    private func configure(attributes: MessagesCollectionViewLayoutAttributes) {
        
        let intermediateAttributes = messageIntermediateLayoutAttributes(for: attributes.indexPath)
        
        intermediateAttributes.cellFrame = attributes.frame
        
        attributes.messageContainerFrame = intermediateAttributes.messageContainerFrame
        attributes.topLabelFrame = intermediateAttributes.topLabelFrame
        attributes.bottomLabelFrame = intermediateAttributes.bottomLabelFrame
        attributes.avatarFrame = intermediateAttributes.avatarFrame
        attributes.messageLabelInsets = intermediateAttributes.messageLabelInsets
        
        switch intermediateAttributes.message.data {
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

// MARK: - Avatar Calculations [ A - C ]

fileprivate extension MessagesCollectionViewFlowLayout {
    
    // A
    
    /// Returns the `AvatarPosition` for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func avatarPosition(for attributes: MessageIntermediateLayoutAttributes) -> AvatarPosition {
        var position = messagesLayoutDelegate.avatarPosition(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
        
        switch position.horizontal {
        case .cellTrailing, .cellLeading:
            break
        case .natural:
            position.horizontal = messagesDataSource.isFromCurrentSender(message: attributes.message) ? .cellTrailing : .cellLeading
        }

        return position
    }

    // B
    
    /// Returns the size of the `AvatarView` for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func avatarSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        return messagesLayoutDelegate.avatarSize(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
}

// MARK: - General Label Size Calculations

private extension MessagesCollectionViewFlowLayout {
    
    /// Returns the size required fit a NSAttributedString considering a constrained max width.
    ///
    /// - Parameters:
    ///   - attributedText: The `NSAttributedString` used to calculate a size that fits.
    ///   - maxWidth: The max width available for the label.
    func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        
        let estimatedHeight = attributedText.height(considering: maxWidth)
        let estimatedWidth = attributedText.width(considering: estimatedHeight)
        
        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
    
    /// Returns the size required to fit a String considering a constrained max width.
    ///
    /// - Parameters:
    ///   - text: The `String` used to calculate a size that fits.
    ///   - maxWidth: The max width available for the label.
    func labelSize(for text: String, considering maxWidth: CGFloat, and font: UIFont) -> CGSize {
        
        let estimatedHeight = text.height(considering: maxWidth, and: font)
        let estimatedWidth = text.width(considering: estimatedHeight, and: font)
        
        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
    
}

// MARK: - MessageContainerView Calculations [ D - G ]

private extension MessagesCollectionViewFlowLayout {
    
    // D
    
    /// Returns the padding to be used around the `MessageContainerView` for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func messageContainerPadding(for attributes: MessageIntermediateLayoutAttributes) -> UIEdgeInsets {
        return messagesLayoutDelegate.messagePadding(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    // E
    
    /// Returns the insets for the text of a `MessageLabel` in ` TextMessageCell`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func messageLabelInsets(for attributes: MessageIntermediateLayoutAttributes) -> UIEdgeInsets {
        // Maybe check the message type here since insets only apply to text messages
        return messagesLayoutDelegate.messageLabelInset(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    // F
    
    /// Returns the max available width for the `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating the max width.
    func messageContainerMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {
        
        switch attributes.message.data {
        case .text, .attributedText:
            return itemWidth - attributes.avatarSize.width - attributes.messageHorizontalPadding - attributes.messageLabelHorizontalInsets
        default:
            return itemWidth - attributes.avatarSize.width - attributes.messageHorizontalPadding
        }
        
    }
    
    // G
    
    /// Returns the size of the `MessageContainerView`
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating the `MessageContainerView` size.
    func messageContainerSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        
        let message = attributes.message
        let indexPath = attributes.indexPath
        let maxWidth = attributes.messageContainerMaxWidth
        
        var messageContainerSize: CGSize = .zero
        
        switch attributes.message.data {
        case .text(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: messageLabelFont)
            messageContainerSize.width += attributes.messageLabelHorizontalInsets
            messageContainerSize.height += attributes.messageLabelVerticalInsets
        case .attributedText(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth)
            messageContainerSize.width += attributes.messageLabelHorizontalInsets
            messageContainerSize.height += attributes.messageLabelVerticalInsets
        case .emoji(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: emojiLabelFont)
            messageContainerSize.width += attributes.messageLabelHorizontalInsets
            messageContainerSize.height += attributes.messageLabelVerticalInsets
        case .photo, .video:
            let width = messagesLayoutDelegate.widthForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .location:
            let width = messagesLayoutDelegate.widthForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = messagesLayoutDelegate.heightForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        }
        
        return messageContainerSize
        
    }
    
}

// MARK: - Cell Bottom Label Calculations  [ I - K ]

private extension MessagesCollectionViewFlowLayout {
    
    // I
    
    /// Returns the alignment of the cell's bottom label.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func cellBottomLabelAlignment(for attributes: MessageIntermediateLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellBottomLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    // J
    
    /// Returns the max available width for the cell's bottom label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating the max width.
    func cellBottomLabelMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {
        
        let labelHorizontal = attributes.bottomLabelAlignment
        let avatarHorizontal = attributes.avatarPosition.horizontal
        let avatarVertical = attributes.avatarPosition.vertical
        let avatarWidth = attributes.avatarSize.width

        switch (labelHorizontal, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - attributes.bottomLabelHorizontalPadding
            return avatarVertical != .cellBottom ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - attributes.bottomLabelHorizontalPadding
            return avatarVertical != .cellBottom ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.left - attributes.bottomLabelHorizontalPadding
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.right - attributes.bottomLabelHorizontalPadding
            return avatarVertical == .cellBottom ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.left - attributes.bottomLabelHorizontalPadding

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.right - attributes.bottomLabelHorizontalPadding

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
        
    }
    
    // K
    
    /// Returns the size of the cell's bottom label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating label's size.
    func cellBottomLabelSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        
        let text = messagesDataSource.cellBottomLabelAttributedText(for: attributes.message, at: attributes.indexPath)
        
        guard let bottomLabelText = text else { return .zero }
        return labelSize(for: bottomLabelText, considering: attributes.bottomLabelMaxWidth)
    }

}

// MARK: - Cell Top Label Size Calculations [ L - N ]

private extension MessagesCollectionViewFlowLayout {
    
    // L
    
    /// Returns the alignment of the cell's top label.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func cellTopLabelAlignment(for attributes: MessageIntermediateLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellTopLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    // M
    
    /// Returns the max available width for the cell's top label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating the max width.
    func cellTopLabelMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {
        
        let labelHorizontal = attributes.topLabelAlignment
        let avatarHorizontal = attributes.avatarPosition.horizontal
        let avatarVertical = attributes.avatarPosition.vertical
        let avatarWidth = attributes.avatarSize.width
        
        switch (labelHorizontal, avatarHorizontal) {

        case (.cellLeading, _), (.cellTrailing, _):
            let width = itemWidth - attributes.topLabelHorizontalPadding
            return avatarVertical != .cellTop ? width : width - avatarWidth

        case (.cellCenter, _):
            let width = itemWidth - attributes.topLabelHorizontalPadding
            return avatarVertical != .cellTop ? width : width - (avatarWidth * 2)

        case (.messageTrailing, .cellLeading):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.left - attributes.topLabelHorizontalPadding
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellTrailing):
            let width = attributes.messageContainerSize.width + attributes.messageContainerPadding.right - attributes.topLabelHorizontalPadding
            return avatarVertical == .cellTop ? width : width + avatarWidth

        case (.messageLeading, .cellLeading):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.left - attributes.topLabelHorizontalPadding

        case (.messageTrailing, .cellTrailing):
            return itemWidth - avatarWidth - attributes.messageContainerPadding.right - attributes.topLabelHorizontalPadding

        case (_, .natural):
            fatalError(MessageKitError.avatarPositionUnresolved)
        }
        
    }
    
    // N
    
    /// Returns the size of the cell's top label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating label's size.
    func cellTopLabelSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        
        let text = messagesDataSource.cellTopLabelAttributedText(for: attributes.message, at: attributes.indexPath)
        
        guard let topLabelText = text else { return .zero }

        return labelSize(for: topLabelText, considering: attributes.topLabelMaxWidth)

    }
    
}

// MARK: - Cell Sizing

private extension MessagesCollectionViewFlowLayout {
    
    // P
    
    /// The height of a `MessageCollectionViewCell`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to use to determine the height of the cell.
    private func cellHeight(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {
        
        var cellHeight: CGFloat = 0
        
        switch attributes.avatarPosition.vertical {
        case .cellTop:
            cellHeight += max(attributes.avatarSize.height, attributes.topLabelSize.height)
            cellHeight += attributes.bottomLabelSize.height
            cellHeight += attributes.messageContainerSize.height
            cellHeight += attributes.messageVerticalPadding
        case .cellBottom:
            cellHeight += max(attributes.avatarSize.height, attributes.bottomLabelSize.height)
            cellHeight += attributes.topLabelSize.height
            cellHeight += attributes.messageContainerSize.height
            cellHeight += attributes.messageVerticalPadding
        case .messageTop, .messageCenter, .messageBottom:
            cellHeight += max(attributes.avatarSize.height, attributes.messageContainerSize.height)
            cellHeight += attributes.messageVerticalPadding
            cellHeight += attributes.topLabelSize.height
            cellHeight += attributes.bottomLabelSize.height
        }
        
        return cellHeight
    }
    
}
