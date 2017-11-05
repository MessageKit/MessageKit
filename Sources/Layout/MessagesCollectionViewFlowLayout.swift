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
import AVFoundation

/// The layout object used by `MessagesCollectionView` to determine the size of all
/// framework provided `MessagesCollectionViewCell` subclasses.
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

    /// A Boolean value that determines if the `AvatarView` is always on the leading
    /// side of a MessageCollectionViewCell.
    ///
    /// Setting this property to `true` causes `avatarAlwaysTrailing` to be set to `false`.
    ///
    /// The default value of this property is `false`.
    open var avatarAlwaysLeading: Bool {
        willSet {
            if newValue {
                avatarAlwaysTrailing = false
            }
        }
    }

    /// A Boolean value that determines if the `AvatarView` is always on the trailing
    /// side of a `MessageCollectionViewCell`.
    ///
    /// Setting this property to `true` causes `avatarAlwaysLeading` to be set to `false`.
    ///
    /// The default value of this property is `false`.
    open var avatarAlwaysTrailing: Bool {
        willSet {
            if newValue {
                avatarAlwaysLeading = false
            }
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

    /// The cache for `MessageIntermediateLayoutAttributes`.
    /// The key is the `messageId` of the `MessageType`.
    fileprivate var intermediateAttributesCache: [MessageID: MessageIntermediateLayoutAttributes] = [:]
    typealias MessageID = String
    
    /// Convenience property for accessing the layout object's `MessagesCollectionView`.
    fileprivate var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("MessagesCollectionViewFlowLayout is being used on a foreign type.")
        }
        return messagesCollectionView
    }

    /// Convenience property for unwrapping the `MessagesCollectionView`'s `MessagesDataSource`.
    fileprivate var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }
        return messagesDataSource
    }

    /// Convenience property for unwrapping the `MessagesCollectionView`'s `MessagesLayoutDelegate`.
    fileprivate var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError("MessagesLayoutDeleagte has not been set.")
        }
        return messagesLayoutDelegate
    }

    /// The width of an item in the `MessagesCollectionViewCell`.
    fileprivate var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    // MARK: - Initializers [Public]

    public override init() {

        messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
        emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)

        avatarAlwaysLeading = false
        avatarAlwaysTrailing = false

        super.init()

        sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: .UIDeviceOrientationDidChange, object: nil)
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
            
            if intermediateAttributesCache.count < attributesCacheMaxSize {
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
        attributes.avatarVertical = avatarVerticalAlignment(for: attributes)
        attributes.avatarHorizontal = avatarHorizontalAlignment(for: attributes)
        attributes.avatarSize = avatarSize(for: attributes)
        attributes.messageContainerPadding = messageContainerPadding(for: attributes)
        attributes.messageLabelInsets = messageLabelInsets(for: attributes)
        
        // MessageContainerView
        attributes.messageContainerMaxWidth = messageContainerMaxWidth(for: attributes)
        attributes.messageContainerSize = messageContainerSize(for: attributes)
        
        // Cell Bottom Label
        attributes.cellBottomLabelText = cellBottomLabelText(for: attributes) // little concerned about storing text here TODO
        attributes.cellBottomLabelAlignment = cellBottomLabelAlignment(for: attributes)
        attributes.cellBottomLabelMaxWidth = cellBottomLabelMaxWidth(for: attributes)
        attributes.cellBottomLabelSize = cellBottomLabelSize(for: attributes)
        
        // Cell Top Label
        attributes.cellTopLabelText = cellTopLabelText(for: attributes) // little concerned about storing text here TODO
        attributes.cellTopLabelAlignment = cellTopLabelAlignment(for: attributes)
        attributes.cellTopLabelMaxWidth = cellTopLabelMaxWidth(for: attributes)
        attributes.cellTopLabelSize = cellTopLabelSize(for: attributes)
        
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
        
        let messageOrigin = messageContainerOrigin(for: intermediateAttributes, and: attributes.frame)
        attributes.messageContainerFrame = CGRect(origin: messageOrigin, size: intermediateAttributes.messageContainerSize)
        
        let avaOrigin = avatarOrigin(for: intermediateAttributes, and: attributes.frame)
        attributes.avatarFrame = CGRect(origin: avaOrigin, size: intermediateAttributes.avatarSize)
        
        let topLabelOrigin = cellTopLabelOrigin(for: intermediateAttributes, and: attributes.frame)
        attributes.cellTopLabelFrame = CGRect(origin: topLabelOrigin, size: intermediateAttributes.cellTopLabelSize)
        
        let bottomLabelOrigin = cellBottomLabelOrigin(for: intermediateAttributes, and: attributes.frame)
        attributes.cellBottomLabelFrame = CGRect(origin: bottomLabelOrigin, size: intermediateAttributes.cellBottomLabelSize)
        
        switch intermediateAttributes.message.data {
        case .emoji:
            attributes.messageLabelFont = emojiLabelFont
        default:
            attributes.messageLabelFont = messageLabelFont
        }
        
        attributes.avatarHorizontalAlignment = intermediateAttributes.avatarHorizontal
        attributes.messagePadding = intermediateAttributes.messageContainerPadding
        attributes.messageLabelInsets = intermediateAttributes.messageLabelInsets
        attributes.cellTopLabelInsets = intermediateAttributes.cellTopLabelAlignment.insets
        attributes.cellBottomLabelInsets = intermediateAttributes.cellBottomLabelAlignment.insets
        
    }
    
}

// MARK: - Avatar Calculations [ A - C ]

fileprivate extension MessagesCollectionViewFlowLayout {
    
    // A
    
    /// Returns the horizontal alignment of the `AvatarView` for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func avatarHorizontalAlignment(for attributes: MessageIntermediateLayoutAttributes) -> AvatarHorizontalAlignment {
        
        if avatarAlwaysTrailing { return .cellTrailing }
        if avatarAlwaysLeading { return .cellLeading }
        
        return messagesDataSource.isFromCurrentSender(message: attributes.message) ? .cellTrailing : .cellLeading

    }
    
    // B
    
    /// Returns the size of the `AvatarView` for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func avatarSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        return messagesLayoutDelegate.avatarSize(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    // C
    
    /// Returns the vertical alignment of the `AvatarView` for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func avatarVerticalAlignment(for attributes: MessageIntermediateLayoutAttributes) -> AvatarAlignment {
        return messagesLayoutDelegate.avatarAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
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
            guard let layoutDelegate = messagesLayoutDelegate as? MediaMessageLayoutDelegate else {
                fatalError("Layout object attempting to size media message type and MediaMessageLayoutDelegate is not set.")
            }
            let width = layoutDelegate.widthForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = layoutDelegate.heightForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .location:
            guard let layoutDelegate = messagesLayoutDelegate as? LocationMessageLayoutDelegate else {
                fatalError("Layout object attempting to size location message type and LocationMessageLayoutDelegate is not set.")
            }
            let width = layoutDelegate.widthForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = layoutDelegate.heightForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        }
        
        return messageContainerSize
        
    }
    
}

// MARK: - Cell Bottom Label Calculations  [ H - K ]

private extension MessagesCollectionViewFlowLayout {
    
    // H
    
    /// Returns the attributed text for the cell's bottom label.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func cellBottomLabelText(for attributes: MessageIntermediateLayoutAttributes) -> NSAttributedString? {
        return messagesDataSource.cellBottomLabelAttributedText(for: attributes.message, at: attributes.indexPath)
    }
    
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
        
        guard attributes.cellBottomLabelText != nil else { return 0 }
        
        let labelHorizontal = attributes.cellBottomLabelAlignment
        let avatarHorizontal = attributes.avatarHorizontal
        let avatarVertical = attributes.avatarVertical
        let avatarWidth = attributes.avatarSize.width
        
        switch (labelHorizontal, avatarHorizontal, avatarVertical) {
            
        case (.cellLeading, .cellTrailing, .cellBottom), (.cellTrailing, .cellLeading, .cellBottom):
            return itemWidth - avatarWidth - attributes.cellBottomLabelHorizontalInsets
            
        case (.cellLeading, _, _), (.cellTrailing, _, _):
            return itemWidth - attributes.cellBottomLabelHorizontalInsets
            
        case (.cellCenter, .cellLeading, .cellBottom), (.cellCenter, .cellTrailing, .cellBottom):
            return itemWidth - (avatarWidth * 2) - attributes.cellBottomLabelHorizontalInsets
            
        case (.cellCenter, .cellLeading, _), (.cellCenter, .cellTrailing, _):
            return itemWidth - attributes.cellBottomLabelHorizontalInsets
            
        case (.messageTrailing, .cellLeading, .cellBottom), (.messageLeading, .cellTrailing, .cellBottom):
            return attributes.messageContainerSize.width - attributes.cellBottomLabelHorizontalInsets
            
        case (.messageLeading, .cellLeading, _), (.messageTrailing, .cellTrailing, _):
            return itemWidth - avatarWidth - attributes.cellBottomLabelHorizontalInsets
            
        case (.messageLeading, .cellTrailing, _), (.messageTrailing, .cellLeading, _):
            return attributes.messageContainerSize.width + avatarWidth - attributes.cellBottomLabelHorizontalInsets
        }
        
    }
    
    // K
    
    /// Returns the size of the cell's bottom label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating label's size.
    func cellBottomLabelSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        guard let bottomLabelText = attributes.cellBottomLabelText else { return .zero }
        
        var bottomLabelSize = labelSize(for: bottomLabelText, considering: attributes.cellBottomLabelMaxWidth)
        bottomLabelSize.width += attributes.cellBottomLabelHorizontalInsets
        bottomLabelSize.height += attributes.cellBottomLabelVerticalInsets
        
        return bottomLabelSize
        
    }

}

// MARK: - Cell Top Label Size Calculations [ L - O ]

private extension MessagesCollectionViewFlowLayout {
    
    // L
    
    /// Returns the attributed text for the cell's top label.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func cellTopLabelText(for attributes: MessageIntermediateLayoutAttributes) -> NSAttributedString? {
        return messagesDataSource.cellTopLabelAttributedText(for: attributes.message, at: attributes.indexPath)
    }
    
    // M
    
    /// Returns the alignment of the cell's top label.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` containing the `MessageType` object.
    func cellTopLabelAlignment(for attributes: MessageIntermediateLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellTopLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    
    // N
    
    /// Returns the max available width for the cell's top label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating the max width.
    func cellTopLabelMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {
        
        guard attributes.cellTopLabelText != nil else { return 0 }
        
        let labelHorizontal = attributes.cellTopLabelAlignment
        let avatarHorizontal = attributes.avatarHorizontal
        let avatarVertical = attributes.avatarVertical
        let avatarWidth = attributes.avatarSize.width
        
        switch (labelHorizontal, avatarHorizontal, avatarVertical) {
            
        case (.cellLeading, .cellTrailing, .cellTop), (.cellTrailing, .cellLeading, .cellTop):
            return itemWidth - avatarWidth - attributes.cellTopLabelHorizontalInsets
            
        case (.cellLeading, _, _), (.cellTrailing, _, _):
            return itemWidth - attributes.cellTopLabelHorizontalInsets
            
        case (.cellCenter, .cellLeading, .cellTop), (.cellCenter, .cellTrailing, .cellTop):
            return itemWidth - (avatarWidth * 2) - attributes.cellTopLabelHorizontalInsets
            
        case (.cellCenter, .cellLeading, _), (.cellCenter, .cellTrailing, _):
            return itemWidth - attributes.cellTopLabelHorizontalInsets
            
        case (.messageTrailing, .cellLeading, .cellTop), (.messageLeading, .cellTrailing, .cellTop):
            return attributes.messageContainerSize.width - attributes.cellTopLabelHorizontalInsets
            
        case (.messageLeading, .cellLeading, _), (.messageTrailing, .cellTrailing, _):
            return itemWidth - avatarWidth - attributes.cellTopLabelHorizontalInsets
            
        case (.messageLeading, .cellTrailing, _), (.messageTrailing, .cellLeading, _):
            return attributes.messageContainerSize.width + avatarWidth - attributes.cellTopLabelHorizontalInsets
        }
        
    }
    
    // O
    
    /// Returns the size of the cell's top label considering the specified layout information.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating label's size.
    func cellTopLabelSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        guard let topLabelText = attributes.cellTopLabelText else { return .zero }
        
        var topLabelSize = labelSize(for: topLabelText, considering: attributes.cellTopLabelMaxWidth)
        topLabelSize.width += attributes.cellTopLabelHorizontalInsets
        topLabelSize.height += attributes.cellTopLabelVerticalInsets
        
        return topLabelSize
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
        
        switch attributes.avatarVertical {
        case .cellTop:
            cellHeight += max(attributes.avatarSize.height, attributes.cellTopLabelSize.height)
            cellHeight += attributes.cellBottomLabelSize.height
            cellHeight += attributes.messageContainerSize.height
            cellHeight += attributes.messageVerticalPadding
        case .cellBottom:
            cellHeight += max(attributes.avatarSize.height, attributes.cellBottomLabelSize.height)
            cellHeight += attributes.cellTopLabelSize.height
            cellHeight += attributes.messageContainerSize.height
            cellHeight += attributes.messageVerticalPadding
        case .messageTop, .messageCenter, .messageBottom:
            cellHeight += max(attributes.avatarSize.height, attributes.messageContainerSize.height)
            cellHeight += attributes.messageVerticalPadding
            cellHeight += attributes.cellTopLabelSize.height
            cellHeight += attributes.cellBottomLabelSize.height
        }
        
        return cellHeight
    }
    
}

// MARK: - Cell Content Origin Calculations [ Q - T ]

fileprivate extension MessagesCollectionViewFlowLayout {
    
    // Q
    
    /// Returns the origin point for the `AvatarView`'s frame.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating origin.
    private func avatarOrigin(for attributes: MessageIntermediateLayoutAttributes, and contentFrame: CGRect) -> CGPoint {
        
        guard attributes.avatarSize != .zero else { return .zero }
        
        var origin = CGPoint.zero
        
        switch attributes.avatarHorizontal {
        case .cellLeading:
            origin.x = 0
        case .cellTrailing:
            origin.x = contentFrame.width - attributes.avatarSize.width
        }
        
        switch attributes.avatarVertical {
        case .cellTop:
            origin.y = 0
        case .cellBottom:
            origin.y = contentFrame.height - attributes.avatarSize.height
        case .messageTop:
            origin.y = attributes.cellTopLabelSize.height + attributes.messageContainerPadding.top
        case .messageBottom:
            origin.y = contentFrame.height - attributes.avatarSize.height - attributes.cellBottomLabelSize.height - attributes.messageContainerPadding.bottom
        case .messageCenter:
            let messageMidY = attributes.messageContainerSize.height / 2
            let avatarMidY = attributes.avatarSize.height / 2
            origin.y = attributes.cellTopLabelSize.height + attributes.messageContainerPadding.top + messageMidY - avatarMidY
        }
        
        return origin
    }
    
    // R
    
    /// Returns the origin point for the `MessageContainerView`'s frame.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating origin.
    private func messageContainerOrigin(for attributes: MessageIntermediateLayoutAttributes, and contentFrame: CGRect) -> CGPoint {
        
        guard attributes.messageContainerSize != .zero else { return .zero }
        
        var origin = CGPoint.zero
        
        switch attributes.avatarHorizontal {
        case .cellLeading:
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left
            origin.y = attributes.cellTopLabelSize.height + attributes.messageContainerPadding.top
        case .cellTrailing:
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerSize.width - attributes.messageContainerPadding.right
            origin.y = attributes.cellTopLabelSize.height + attributes.messageContainerPadding.top
        }
        
        return origin
        
    }
    
    // S
    
    /// Returns the origin point for the cell's bottom label's frame.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating origin.
    private func cellBottomLabelOrigin(for attributes: MessageIntermediateLayoutAttributes, and contentFrame: CGRect) -> CGPoint {
        
        guard attributes.cellBottomLabelSize != .zero else { return .zero }
        
        var origin = CGPoint(x: 0, y: attributes.cellTopLabelSize.height + attributes.messageContainerSize.height + attributes.messageVerticalPadding)
        
        switch (attributes.cellBottomLabelAlignment, attributes.avatarHorizontal) {
        case (.cellLeading, _):
            origin.x = 0
        case (.cellCenter, _):
            origin.x = contentFrame.width / 2 - (attributes.cellBottomLabelSize.width / 2)
        case (.cellTrailing, _):
            origin.x = contentFrame.width - attributes.cellBottomLabelSize.width
        case (.messageLeading, .cellLeading):
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left
        case (.messageLeading, .cellTrailing):
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerPadding.right - attributes.messageContainerSize.width
        case (.messageTrailing, .cellTrailing):
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerPadding.right - attributes.cellBottomLabelSize.width
        case (.messageTrailing, .cellLeading):
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left + attributes.messageContainerSize.width - attributes.cellBottomLabelSize.width
        }
        
        return origin
        
    }
    
    // T
    
    /// Returns the origin point for the cell's top label's frame.
    ///
    /// - Parameters:
    ///   - attributes: The `MessageIntermediateLayoutAttributes` to consider when calculating origin.
    fileprivate func cellTopLabelOrigin(for attributes: MessageIntermediateLayoutAttributes, and contentFrame: CGRect) -> CGPoint {
        
        guard attributes.cellTopLabelSize != .zero else { return .zero }
        
        var origin = CGPoint.zero
        
        switch (attributes.cellTopLabelAlignment, attributes.avatarHorizontal) {
        case (.cellLeading, _):
            origin.x = 0
        case (.cellCenter, _):
            origin.x = contentFrame.width / 2 - (attributes.cellTopLabelSize.width / 2)
        case (.cellTrailing, _):
            origin.x = contentFrame.width - attributes.cellTopLabelSize.width
        case (.messageLeading, .cellLeading):
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left
        case (.messageLeading, .cellTrailing):
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerPadding.right - attributes.messageContainerSize.width
        case (.messageTrailing, .cellTrailing):
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerPadding.right - attributes.cellTopLabelSize.width
        case (.messageTrailing, .cellLeading):
            origin.x = contentFrame.width - attributes.messageContainerPadding.right - attributes.cellTopLabelSize.width
        }
        
        return origin
        
    }

}

