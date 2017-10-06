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

    fileprivate var messagesCollectionView: MessagesCollectionView? {
        return collectionView as? MessagesCollectionView
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

        guard let messagesCollectionView = messagesCollectionView else { return }
        guard let dataSource = messagesCollectionView.messagesDataSource else { return }

        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let messagePadding = messageContainerPadding(for: message, at: indexPath)
        let messageInsets = messageLabelInsets(for: message, at: indexPath)
        let topLabelInsets = cellTopLabelInsets(for: message, at: indexPath)
        let bottomLabelInsets = cellBottomLabelInsets(for: message, at: indexPath)

        // First we set all the sizes so we can pass the attributes object around to calculate the origins
        attributes.messageContainerFrame = CGRect(origin: .zero, size: messageContainerSize(for: message, at: indexPath))
        attributes.cellTopLabelFrame = CGRect(origin: .zero, size: cellTopLabelSize(for: message, at: indexPath))
        attributes.cellBottomLabelFrame = CGRect(origin: .zero, size: cellBottomLabelSize(for: message, at: indexPath))
        attributes.avatarFrame = CGRect(origin: .zero, size: avatarSize(for: message, at: indexPath))

        switch message.data {
        case .emoji:
            attributes.messageLabelFont = emojiLabelFont
        default:
            attributes.messageLabelFont = messageLabelFont
        }

        attributes.messagePadding = messagePadding
        attributes.messageLabelInsets = messageInsets
        attributes.cellTopLabelInsets = topLabelInsets
        attributes.cellBottomLabelInsets = bottomLabelInsets
        attributes.avatarHorizontalAlignment = avatarHorizontalAlignment(for: message)

        let layoutDelegate = messagesCollectionView.messagesLayoutDelegate
        let avatarAlignment = layoutDelegate?.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView) ?? .messageBottom

        // Now we set the origins for the frames using the attributes object that contains the calculated sizes
        attributes.messageContainerFrame.origin = messageContainerOrigin(for: attributes)
        attributes.cellTopLabelFrame.origin = cellTopLabelOrigin(for: message, and: attributes)
        attributes.cellBottomLabelFrame.origin = cellBottomLabelOrigin(for: message, and: attributes)
        attributes.avatarFrame.origin = avatarOrigin(for: attributes, with: avatarAlignment)

    }

    // MARK: - Invalidation Context

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

        return collectionView?.bounds.width != newBounds.width || collectionView?.bounds.height != newBounds.height

    }

    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else { return context }
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = shouldInvalidateLayout(forBoundsChange: newBounds)
        return flowLayoutContext
    }

}

extension MessagesCollectionViewFlowLayout {

    // MARK: - Avatar Calculations

    /// The horizontal alignment for the message: .cellTrailing or .cellLeading
    fileprivate func avatarHorizontalAlignment(for message: MessageType) -> AvatarHorizontalAlignment {

        if avatarAlwaysTrailing { return .cellTrailing }
        if avatarAlwaysLeading { return .cellLeading }

        guard let messagesCollectionView = messagesCollectionView else { return .cellLeading }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .cellLeading }

        return messagesDataSource.isFromCurrentSender(message: message) ? .cellTrailing : .cellLeading
    }

    /// The size of the avatar view.
    fileprivate func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }

        return layoutDelegate.avatarSize(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// The origin for the avatar view.
    fileprivate func avatarOrigin(for attributes: MessagesCollectionViewLayoutAttributes, with avatarAlignment: AvatarAlignment) -> CGPoint {

        var origin = CGPoint.zero

        let contentWidth = attributes.frame.size.width
        let avatarWidth = attributes.avatarFrame.size.width

        switch attributes.avatarHorizontalAlignment {
        case .cellLeading:
            origin.x = 0
        case .cellTrailing:
            origin.x = contentWidth - avatarWidth
        }

        let contentHeight = attributes.frame.height
        let avatarHeight = attributes.avatarFrame.height
        let cellTopLabelHeight = attributes.cellTopLabelFrame.height
        let cellBottomLabelHeight = attributes.cellBottomLabelFrame.height
        let messageContainerHeight = attributes.messageContainerFrame.height
        let messagePadding = attributes.messagePadding

        switch avatarAlignment {
        case .cellTop:
            origin.y = 0
        case .cellBottom:
            origin.y = contentHeight - avatarHeight
        case .messageTop:
            origin.y = cellTopLabelHeight + messagePadding.top
        case .messageBottom:
            origin.y = contentHeight - avatarHeight - cellBottomLabelHeight - messagePadding.bottom
        case .messageCenter:
            let messageMidY = messageContainerHeight / 2
            let avatarMidY = avatarHeight / 2
            origin.y = cellTopLabelHeight + messagePadding.top + messageMidY - avatarMidY
        }

        return origin

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

    // MARK: - Message Container Calculations

    fileprivate func messageContainerPadding(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        return layoutDelegate.messagePadding(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// The insets for the text of the MessageLabel
    private func messageLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        return layoutDelegate.messageLabelInset(for: message, at: indexPath, in: messagesCollectionView)
    }

    /// The max width available for the message container.
    private func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let avatarWidth = avatarSize(for: message, at: indexPath).width
        let messagePadding = messageContainerPadding(for: message, at: indexPath)
        let messageInsets = messageLabelInsets(for: message, at: indexPath)

        let messageHorizontalPadding = messagePadding.left + messagePadding.right
        let messageHorizontalInsets = messageInsets.left + messageInsets.right

        let availableWidth = itemWidth - avatarWidth - messageHorizontalPadding - messageHorizontalInsets

        return availableWidth
    }

    /// The size for the message container.
    fileprivate func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
        let messageInsets = messageLabelInsets(for: message, at: indexPath)
        let messageHorizontalInsets = messageInsets.left + messageInsets.right
        let messageVerticalInsets = messageInsets.top + messageInsets.bottom

        var messageContainerSize: CGSize = .zero

        switch message.data {
        case .text(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: messageLabelFont)
            messageContainerSize.width += messageHorizontalInsets
            messageContainerSize.height += messageVerticalInsets
        case .attributedText(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth)
            messageContainerSize.width += messageHorizontalInsets
            messageContainerSize.height += messageVerticalInsets
        case .photo, .video:
            guard let messagesCollectionView = messagesCollectionView else { return .zero }
            guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate as? MediaMessageLayoutDelegate else { return .zero }
            let width = layoutDelegate.widthForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = layoutDelegate.heightForMedia(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .location:
            guard let messagesCollectionView = messagesCollectionView else { return .zero }
            guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate as? LocationMessageLayoutDelegate else { return .zero }
            let width = layoutDelegate.widthForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            let height = layoutDelegate.heightForLocation(message: message, at: indexPath, with: maxWidth, in: messagesCollectionView)
            messageContainerSize = CGSize(width: width, height: height)
        case .emoji(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: emojiLabelFont)
            messageContainerSize.width += messageHorizontalInsets
            messageContainerSize.height += messageVerticalInsets
        }

        return messageContainerSize
    }

    /// The origin for the message container.
    fileprivate func messageContainerOrigin(for attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        let avatarWidth = attributes.avatarFrame.width

        var origin = CGPoint.zero

        switch attributes.avatarHorizontalAlignment {
        case .cellLeading:
            origin.x = avatarWidth + attributes.messagePadding.left
            origin.y = attributes.cellTopLabelFrame.height + attributes.messagePadding.top
        case .cellTrailing:
            origin.x = attributes.frame.width - avatarWidth - attributes.messageContainerFrame.width - attributes.messagePadding.right
            origin.y = attributes.cellTopLabelFrame.height + attributes.messagePadding.top
        }

        return origin

    }

    // MARK: - Cell Top Label Calculations

    /// The insets for the cell's top label.
    private func cellTopLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        let labelAlignment = layoutDelegate.cellTopLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
        return labelAlignment.insets
    }

    /// The max width available for the cell top label.
    private func topLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return 0 }

        let labelHorizontal = layoutDelegate.cellTopLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarVertical = layoutDelegate.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarHorizontal = avatarHorizontalAlignment(for: message)
        let topLabelHorizontalInsets = labelHorizontal.insets.left + labelHorizontal.insets.right

        let avatarWidth = layoutDelegate.avatarSize(for: message, at: indexPath, in: messagesCollectionView).width

        switch (labelHorizontal, avatarHorizontal, avatarVertical) {

        case (.cellLeading, .cellTrailing, .cellTop), (.cellTrailing, .cellLeading, .cellTop):
            return itemWidth - avatarWidth - topLabelHorizontalInsets

        case (.cellLeading, _, _), (.cellTrailing, _, _):
            return itemWidth - topLabelHorizontalInsets

        case (.cellCenter, .cellLeading, .cellTop), (.cellCenter, .cellTrailing, .cellTop):
            return itemWidth - (avatarWidth * 2) - topLabelHorizontalInsets

        case (.cellCenter, .cellLeading, _), (.cellCenter, .cellTrailing, _):
            return itemWidth - topLabelHorizontalInsets

        case (.messageTrailing, .cellLeading, .cellTop), (.messageLeading, .cellTrailing, .cellTop):
            return messageContainerSize(for: message, at: indexPath).width - topLabelHorizontalInsets

        case (.messageLeading, .cellLeading, _), (.messageTrailing, .cellTrailing, _):
            return itemWidth - avatarWidth - topLabelHorizontalInsets

        case (.messageLeading, .cellTrailing, _), (.messageTrailing, .cellLeading, _):
            return messageContainerSize(for: message, at: indexPath).width + avatarWidth - topLabelHorizontalInsets
        }
    }

    /// The size of the cell top label.
    fileprivate func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let topLabelText = dataSource.cellTopLabelAttributedText(for: message, at: indexPath) else { return .zero }

        let maxWidth = topLabelMaxWidth(for: message, at: indexPath)
        var size = labelSize(for: topLabelText, considering: maxWidth)

        let topLabelInsets = cellTopLabelInsets(for: message, at: indexPath)
        let topLabelHorizontalInsets = topLabelInsets.left + topLabelInsets.right
        let topLabelVerticalInsets = topLabelInsets.top + topLabelInsets.bottom

        size.width += topLabelHorizontalInsets
        size.height += topLabelVerticalInsets

        return size

    }

    /// The origin for the cell top label.
    fileprivate func cellTopLabelOrigin(for message: MessageType, and attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }

        let labelAlignment = layoutDelegate.cellTopLabelAlignment(for: message, at: attributes.indexPath, in: messagesCollectionView)
        let avatarAlignment = avatarHorizontalAlignment(for: message)

        var origin = CGPoint.zero

        switch (labelAlignment, avatarAlignment) {
        case (.cellLeading, _):
            origin.x = 0
        case (.cellCenter, _):
            origin.x = attributes.frame.width / 2 - (attributes.cellTopLabelFrame.width / 2)
        case (.cellTrailing, _):
            origin.x = attributes.frame.width - attributes.cellTopLabelFrame.width
        case (.messageLeading, .cellLeading):
            origin.x = attributes.avatarFrame.width + attributes.messagePadding.left
        case (.messageLeading, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - attributes.messagePadding.right - attributes.messageContainerFrame.width
        case (.messageTrailing, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - attributes.messagePadding.right - attributes.cellTopLabelFrame.width
        case (.messageTrailing, .cellLeading):
            origin.x = attributes.frame.width - attributes.messagePadding.right - attributes.cellTopLabelFrame.width
        }

        return origin

    }

    // MARK: - Cell Bottom Label Calculations

    /// The insets for the cell's top label.
    private func cellBottomLabelInsets(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }
        let labelAlignment = layoutDelegate.cellBottomLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
        return labelAlignment.insets
    }

    /// The max with available for the cell bottom label.
    private func bottomLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return 0 }

        let labelHorizontal = layoutDelegate.cellBottomLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarVertical = layoutDelegate.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarHorizontal = avatarHorizontalAlignment(for: message)
        let bottomLabelHorizontalInsets = labelHorizontal.insets.left + labelHorizontal.insets.right

        let avatarWidth = layoutDelegate.avatarSize(for: message, at: indexPath, in: messagesCollectionView).width

        switch (labelHorizontal, avatarHorizontal, avatarVertical) {

        case (.cellLeading, .cellTrailing, .cellBottom), (.cellTrailing, .cellLeading, .cellBottom):
            return itemWidth - avatarWidth - bottomLabelHorizontalInsets

        case (.cellLeading, _, _), (.cellTrailing, _, _):
            return itemWidth - bottomLabelHorizontalInsets

        case (.cellCenter, .cellLeading, .cellBottom), (.cellCenter, .cellTrailing, .cellBottom):
            return itemWidth - (avatarWidth * 2) - bottomLabelHorizontalInsets

        case (.cellCenter, .cellLeading, _), (.cellCenter, .cellTrailing, _):
            return itemWidth - bottomLabelHorizontalInsets

        case (.messageTrailing, .cellLeading, .cellBottom), (.messageLeading, .cellTrailing, .cellBottom):
            return messageContainerSize(for: message, at: indexPath).width - bottomLabelHorizontalInsets

        case (.messageLeading, .cellLeading, _), (.messageTrailing, .cellTrailing, _):
            return itemWidth - avatarWidth - bottomLabelHorizontalInsets

        case (.messageLeading, .cellTrailing, _), (.messageTrailing, .cellLeading, _):
            return messageContainerSize(for: message, at: indexPath).width + avatarWidth - bottomLabelHorizontalInsets

        }
    }

    /// The size for the cell bottom label.
    fileprivate func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .zero }
        guard let bottomLabelText = dataSource.cellBottomLabelAttributedText(for: message, at: indexPath) else { return .zero }

        let maxWidth = bottomLabelMaxWidth(for: message, at: indexPath)
        var size = labelSize(for: bottomLabelText, considering: maxWidth)

        let bottomLabelInsets = cellBottomLabelInsets(for: message, at: indexPath)
        let bottomLabelHorizontalInsets = bottomLabelInsets.left + bottomLabelInsets.right
        let bottomLabelVerticalInsets = bottomLabelInsets.top + bottomLabelInsets.bottom

        size.width += bottomLabelHorizontalInsets
        size.height += bottomLabelVerticalInsets

        return size

    }

    /// The origin for the cell bottom label.
    fileprivate func cellBottomLabelOrigin(for message: MessageType, and attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return .zero }

        let labelAlignment = layoutDelegate.cellBottomLabelAlignment(for: message, at: attributes.indexPath, in: messagesCollectionView)
        let avatarAlignment = avatarHorizontalAlignment(for: message)

        var origin = CGPoint(x: 0, y: attributes.frame.height - attributes.cellBottomLabelFrame.height)

        switch (labelAlignment, avatarAlignment) {
        case (.cellLeading, _):
            origin.x = 0
        case (.cellCenter, _):
            origin.x = attributes.frame.width / 2 - (attributes.cellBottomLabelFrame.width / 2)
        case (.cellTrailing, _):
            origin.x = attributes.frame.width - attributes.cellBottomLabelFrame.width
        case (.messageLeading, .cellLeading):
            origin.x = attributes.avatarFrame.width + attributes.messagePadding.left
        case (.messageLeading, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - attributes.messagePadding.right - attributes.messageContainerFrame.width
        case (.messageTrailing, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - attributes.messagePadding.right - attributes.cellBottomLabelFrame.width
        case (.messageTrailing, .cellLeading):
            origin.x = attributes.avatarFrame.width + attributes.messagePadding.left + attributes.messageContainerFrame.width - attributes.cellBottomLabelFrame.width
        }

        return origin

    }

    // MARK: - Cell Size Calculations

    /// The minimum height for the cell.
    private func minimumCellHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return 0 }

        let avatarAlignment = layoutDelegate.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView)

        let topLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
        let avatarHeight = avatarSize(for: message, at: indexPath).height
        let bottomLabelHeight = cellBottomLabelSize(for: message, at: indexPath).height
        let messagePadding = messageContainerPadding(for: message, at: indexPath)
        let messagePaddingVertical = messagePadding.top + messagePadding.bottom

        switch avatarAlignment {
        case .cellTop:
            return max(avatarHeight, topLabelHeight) + bottomLabelHeight + messagePaddingVertical
        case .cellBottom:
            return max(avatarHeight, bottomLabelHeight) + topLabelHeight + messagePaddingVertical
        case .messageTop, .messageCenter, .messageBottom:
            return topLabelHeight + avatarHeight + bottomLabelHeight + messagePaddingVertical
        }

    }

    /// The calculated height of the cell not considering the minimum height.
    private func estimatedCellHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let messageContainerHeight = messageContainerSize(for: message, at: indexPath).height
        let cellTopLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
        let cellBottomLabelHeight = cellBottomLabelSize(for: message, at: indexPath).height
        let messagePadding = messageContainerPadding(for: message, at: indexPath)
        let messagePaddingVertical = messagePadding.top + messagePadding.bottom

        return messageContainerHeight + cellBottomLabelHeight + cellTopLabelHeight + messagePaddingVertical

    }

    /// The size for the cell considering all cell contents.
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .zero }

        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        let minimumHeight = minimumCellHeight(for: message, at: indexPath)
        let estimatedHeight = estimatedCellHeight(for: message, at: indexPath)

        let itemHeight = estimatedHeight > minimumHeight ? estimatedHeight : minimumHeight

        return CGSize(width: itemWidth, height: itemHeight)

    }

}
