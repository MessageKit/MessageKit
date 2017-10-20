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

open class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties

    open var messageLabelFont: UIFont {
        didSet {
            emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)
        }
    }

    private var emojiLabelFont: UIFont

    open var avatarAlwaysLeading: Bool {
        willSet {
            if newValue {
                avatarAlwaysTrailing = false
            }
        }
    }

    open var avatarAlwaysTrailing: Bool {
        willSet {
            if newValue {
                avatarAlwaysLeading = false
            }
        }
    }

    open var attributesCacheMaxSize: Int = 500

    typealias MessageID = String

    fileprivate var intermediateAttributesCache: [MessageID: MessageIntermediateLayoutAttributes] = [:]

    fileprivate var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError("MessagesCollectionViewFlowLayout is being used on a foreign type.")
        }
        return messagesCollectionView
    }

    fileprivate var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessagesDataSource has not been set.")
        }
        return messagesDataSource
    }

    fileprivate var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError("MessagesLayoutDeleagte has not been set.")
        }
        return messagesLayoutDelegate
    }

    fileprivate var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }

    // MARK: - Initializers

    public override init() {

        messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
        emojiLabelFont = messageLabelFont.withSize(2 * messageLabelFont.pointSize)

        avatarAlwaysLeading = false
        avatarAlwaysTrailing = false

        super.init()

        sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    // MARK: - Layout Attributes

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

    // MARK: - Invalidation Context

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if collectionView?.bounds.width != newBounds.width {
            intermediateAttributesCache = [:]
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

    public func clearCachedAttributes(for message: MessageType) {
        intermediateAttributesCache.removeValue(forKey: message.messageId)
    }

}

extension MessagesCollectionViewFlowLayout {

    // MARK: - Avatar Calculations

    /// The horizontal alignment for the message: .cellTrailing or .cellLeading
    fileprivate func avatarHorizontalAlignment(for message: MessageType) -> AvatarHorizontalAlignment {

        if avatarAlwaysTrailing { return .cellTrailing }
        if avatarAlwaysLeading { return .cellLeading }

        return messagesDataSource.isFromCurrentSender(message: message) ? .cellTrailing : .cellLeading
    }

    // MARK: - Label Size Calculations

    /// The size required fit a NSAttributedString considering a constrained max width.
    fileprivate func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {

        let estimatedHeight = attributedText.height(considering: maxWidth)
        let estimatedWidth = attributedText.width(considering: estimatedHeight)

        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

        return CGSize(width: finalWidth, height: finalHeight)
    }

    /// The size required to fit a String considering a constrained max width.
    fileprivate func labelSize(for text: String, considering maxWidth: CGFloat, and font: UIFont) -> CGSize {

        let estimatedHeight = text.height(considering: maxWidth, and: font)
        let estimatedWidth = text.width(considering: estimatedHeight, and: font)

        let finalHeight = estimatedHeight.rounded(.up)
        let finalWidth = estimatedWidth > maxWidth ? maxWidth : estimatedWidth.rounded(.up)

        return CGSize(width: finalWidth, height: finalHeight)
    }

    // MARK: - Cell Sizing

    /// The size for the cell considering all cell contents.
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let attributes = messageIntermediateLayoutAttributes(for: indexPath)
        return CGSize(width: itemWidth, height: attributes.itemHeight)
    }

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

    // MARK: - AvatarView Size [ A - C ]

    // A
    private func avatarHorizontalAlignment(for attributes: MessageIntermediateLayoutAttributes) -> AvatarHorizontalAlignment {
        return avatarHorizontalAlignment(for: attributes.message)
    }
    // B
    private func avatarSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        return messagesLayoutDelegate.avatarSize(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }
    // C
    private func avatarVerticalAlignment(for attributes: MessageIntermediateLayoutAttributes) -> AvatarAlignment {
        return messagesLayoutDelegate.avatarAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }

    // MARK: - MessageContainerView Size [ D - G ]

    // D
    private func messageContainerPadding(for attributes: MessageIntermediateLayoutAttributes) -> UIEdgeInsets {
        return messagesLayoutDelegate.messagePadding(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }

    // E
    private func messageLabelInsets(for attributes: MessageIntermediateLayoutAttributes) -> UIEdgeInsets {
        // Maybe check the message type here since insets only apply to text messages
        return messagesLayoutDelegate.messageLabelInset(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }

    // F
    private func messageContainerMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {

        switch attributes.message.data {
        case .text, .attributedText:
            return itemWidth - attributes.avatarSize.width - attributes.messageHorizontalPadding - attributes.messageLabelHorizontalInsets
        default:
            return itemWidth - attributes.avatarSize.width - attributes.messageHorizontalPadding
        }

    }

    // G
    private func messageContainerSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {

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

    // MARK: - Cell Bottom Label Size [ H - K ]

    // H
    private func cellBottomLabelText(for attributes: MessageIntermediateLayoutAttributes) -> NSAttributedString? {
        return messagesDataSource.cellBottomLabelAttributedText(for: attributes.message, at: attributes.indexPath)
    }

    // I
    private func cellBottomLabelAlignment(for attributes: MessageIntermediateLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellBottomLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }

    // J
    private func cellBottomLabelMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {

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
    private func cellBottomLabelSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        guard let bottomLabelText = attributes.cellBottomLabelText else { return .zero }

        var bottomLabelSize = labelSize(for: bottomLabelText, considering: attributes.cellBottomLabelMaxWidth)
        bottomLabelSize.width += attributes.cellBottomLabelHorizontalInsets
        bottomLabelSize.height += attributes.cellBottomLabelVerticalInsets

        return bottomLabelSize

    }

    // MARK: - Cell Top Label Sizing [ L - O ]

    // L
    private func cellTopLabelText(for attributes: MessageIntermediateLayoutAttributes) -> NSAttributedString? {
        return messagesDataSource.cellTopLabelAttributedText(for: attributes.message, at: attributes.indexPath)
    }

    // M
    private func cellTopLabelAlignment(for attributes: MessageIntermediateLayoutAttributes) -> LabelAlignment {
        return messagesLayoutDelegate.cellTopLabelAlignment(for: attributes.message, at: attributes.indexPath, in: messagesCollectionView)
    }

    // N
    private func cellTopLabelMaxWidth(for attributes: MessageIntermediateLayoutAttributes) -> CGFloat {

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
    private func cellTopLabelSize(for attributes: MessageIntermediateLayoutAttributes) -> CGSize {
        guard let topLabelText = attributes.cellTopLabelText else { return .zero }

        var topLabelSize = labelSize(for: topLabelText, considering: attributes.cellTopLabelMaxWidth)
        topLabelSize.width += attributes.cellTopLabelHorizontalInsets
        topLabelSize.height += attributes.cellTopLabelVerticalInsets

        return topLabelSize
    }

    // MARK: - Cell Height [ P ]

    // P
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

    // MARK: - Origins [ Q - T ]

    // Q
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
    private func cellBottomLabelOrigin(for attributes: MessageIntermediateLayoutAttributes, and contentFrame: CGRect) -> CGPoint {

        guard attributes.cellBottomLabelSize != .zero else { return .zero }

        var origin = CGPoint(x: 0, y: contentFrame.height - attributes.cellBottomLabelSize.height)

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
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerPadding.right - attributes.cellBottomLabelSize.width
        case (.messageTrailing, .cellTrailing):
            origin.x = contentFrame.width - attributes.avatarSize.width - attributes.messageContainerPadding.right - attributes.cellBottomLabelSize.width
        case (.messageTrailing, .cellLeading):
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left + attributes.messageContainerSize.width - attributes.cellBottomLabelSize.width
        }

        return origin

    }

    // T
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


