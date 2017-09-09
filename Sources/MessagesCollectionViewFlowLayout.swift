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

// MARK: - AvatarVerticalAlignment

enum AvatarHorizontalAlignment {
    case cellLeading
    case cellTrailing
}

open class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties

    open var messageLabelFont: UIFont
    open var messageLabelInsets: UIEdgeInsets
    open var messageToViewEdgePadding: CGFloat

    open var cellTopLabelInsets: UIEdgeInsets
    open var cellBottomLabelInsets: UIEdgeInsets

    fileprivate var avatarMessagePadding: CGFloat = 4

    fileprivate var messagesCollectionView: MessagesCollectionView? {
        return collectionView as? MessagesCollectionView
    }

    fileprivate var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    override open class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }

    // MARK: - Initializers

    override public init() {

        messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
        messageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
        messageToViewEdgePadding = 30.0

        cellTopLabelInsets = .zero
        cellBottomLabelInsets = .zero

        super.init()

        sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    // MARK: - Layout Attributes

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else { return nil }

        attributesArray.forEach { attributes in
            if attributes.representedElementCategory == UICollectionElementCategory.cell {
                configure(attributes: attributes)
            }
        }

        return attributesArray
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

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

        // First we set all the sizes so we can pass the attributes object around to calculate the origins
        attributes.messageContainerFrame = CGRect(origin: .zero, size: messageContainerSize(for: message, at: indexPath))
        attributes.cellTopLabelFrame = CGRect(origin: .zero, size: cellTopLabelSize(for: message, at: indexPath))
        attributes.cellBottomLabelFrame = CGRect(origin: .zero, size: cellBottomLabelSize(for: message, at: indexPath))
        attributes.avatarFrame = CGRect(origin: .zero, size: avatarSize(for: message, at: indexPath))

        attributes.messageLabelFont = messageLabelFont
        attributes.messageLabelInsets = messageLabelInsets
        attributes.cellTopLabelInsets = cellTopLabelInsets
        attributes.cellBottomLabelInsets = cellBottomLabelInsets
        attributes.avatarHorizontalAlignment = dataSource.isFromCurrentSender(message: message) ? .cellTrailing : .cellLeading

        let layoutDelegate = messagesCollectionView.messagesLayoutDelegate
        let avatarAlignment = layoutDelegate?.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView) ?? .messageBottom

        // Now we set the origins for the frames using the attributes object that contains the calculated sizes
        attributes.messageContainerFrame.origin = messageContainerOrigin(for: attributes)
        attributes.cellTopLabelFrame.origin = cellTopLabelOrigin(for: message, and: attributes)
        attributes.cellBottomLabelFrame.origin = cellBottomLabelOrigin(for: message, and: attributes)
        attributes.avatarFrame.origin = avatarOrigin(for: attributes, with: avatarAlignment)

    }

    // MARK: - Invalidation Context

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

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

        switch avatarAlignment {
        case .cellTop:
            origin.y = 0
        case .cellBottom:
            origin.y = contentHeight - avatarHeight
        case .messageTop:
            origin.y = cellTopLabelHeight
        case .messageBottom:
            origin.y = contentHeight - avatarHeight - cellBottomLabelHeight
        case .messageCenter:
            let messageMidY = messageContainerHeight / 2
            let avatarMidY = avatarHeight / 2
            origin.y = contentHeight - cellTopLabelHeight - messageMidY - avatarMidY
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

    /// The total value of the horizontal insets for the message label.
    private var messageHorizontalInsets: CGFloat {
        return messageLabelInsets.left + messageLabelInsets.right
    }

    /// The total value of the vertical insets for the message label.
    private var messageVerticalInsets: CGFloat {
        return messageLabelInsets.top + messageLabelInsets.bottom
    }

    /// The max width available for the message container.
    private func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        var avatarWidth = avatarSize(for: message, at: indexPath).width

        // Only apply padding if avatar width is greater than zero
        if avatarWidth > 0 { avatarWidth += avatarMessagePadding }

        let availableWidth = itemWidth - avatarWidth - messageToViewEdgePadding - messageHorizontalInsets

        return availableWidth
    }

    /// The size for the message container.
    fileprivate func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)

        var messageContainerSize: CGSize = .zero

        switch message.data {
        case .text(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth, and: messageLabelFont)
        case .attributedText(let text):
            messageContainerSize = labelSize(for: text, considering: maxWidth)
        }

        messageContainerSize.width += messageHorizontalInsets
        messageContainerSize.height += messageVerticalInsets

        return messageContainerSize
    }

    /// The origin for the message container.
    fileprivate func messageContainerOrigin(for attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        var avatarWidth = attributes.avatarFrame.width

        if avatarWidth > 0 { avatarWidth += avatarMessagePadding }

        var origin = CGPoint.zero

        switch attributes.avatarHorizontalAlignment {
        case .cellLeading:
            origin.x = avatarWidth
            origin.y = attributes.cellTopLabelFrame.height
        case .cellTrailing:
            origin.x = attributes.frame.width - avatarWidth - attributes.messageContainerFrame.width
            origin.y = attributes.cellTopLabelFrame.height
        }

        return origin

    }

    // MARK: - Cell Top Label Calculations

    /// The total value of the horizontal insets for the cell top label.
    private var topLabelHorizontalInsets: CGFloat {
        return cellTopLabelInsets.left + cellTopLabelInsets.right
    }

    /// The total value of the vertical insets for the cell top label.
    private var topLabelVerticalInsets: CGFloat {
        return cellTopLabelInsets.top + cellTopLabelInsets.bottom
    }

    /// The max width available for the cell top label.
    private func topLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return 0 }

        let labelHorizontal = layoutDelegate.cellTopLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarVertical = layoutDelegate.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarHorizontal = avatarHorizontalAlignment(for: message)

        var avatarWidth = layoutDelegate.avatarSize(for: message, at: indexPath, in: messagesCollectionView).width

        // Only apply padding is avatar width is greater than zero
        if avatarWidth > 0 { avatarWidth += avatarMessagePadding }

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
            origin.x = attributes.avatarFrame.width + avatarMessagePadding
        case (.messageLeading, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - avatarMessagePadding - attributes.messageContainerFrame.width
        case (.messageTrailing, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - avatarMessagePadding - attributes.cellTopLabelFrame.width
        case (.messageTrailing, .cellLeading):
            origin.x = attributes.frame.width - messageToViewEdgePadding - attributes.cellTopLabelFrame.width
        }

        return origin

    }

    // MARK: - Cell Bottom Label Calculations

    /// The total value of the horizontal insets for the cell bottom label
    private var bottomLabelHorizontalInsets: CGFloat {
        return cellBottomLabelInsets.left + cellBottomLabelInsets.right
    }

    /// The total value of the vertical insets for the cell bottom label.
    private var bottomLabelVerticalInsets: CGFloat {
        return cellBottomLabelInsets.top + cellBottomLabelInsets.bottom
    }

    /// The max with available for the cell bottom label.
    private func bottomLabelMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else { return 0 }

        let labelHorizontal = layoutDelegate.cellBottomLabelAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarVertical = layoutDelegate.avatarAlignment(for: message, at: indexPath, in: messagesCollectionView)
        let avatarHorizontal = avatarHorizontalAlignment(for: message)

        var avatarWidth = layoutDelegate.avatarSize(for: message, at: indexPath, in: messagesCollectionView).width

        // Only apply padding is avatar width is greater than zero
        if avatarWidth > 0 { avatarWidth += avatarMessagePadding }

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
            origin.x = attributes.avatarFrame.width + avatarMessagePadding
        case (.messageLeading, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - avatarMessagePadding - attributes.messageContainerFrame.width
        case (.messageTrailing, .cellTrailing):
            origin.x = attributes.frame.width - attributes.avatarFrame.width - avatarMessagePadding - attributes.cellBottomLabelFrame.width
        case (.messageTrailing, .cellLeading):
            origin.x = attributes.frame.width - messageToViewEdgePadding - attributes.cellBottomLabelFrame.width
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

        switch avatarAlignment {
        case .cellTop:
            return max(avatarHeight, topLabelHeight) + bottomLabelHeight
        case .cellBottom:
            return max(avatarHeight, bottomLabelHeight) + topLabelHeight
        case .messageTop, .messageCenter, .messageBottom:
            return topLabelHeight + avatarHeight + bottomLabelHeight
        }

    }

    /// The calculated height of the cell not considering the minimum height.
    private func estimatedCellHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let messageContainerHeight = messageContainerSize(for: message, at: indexPath).height
        let cellTopLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
        let cellBottomLabelHeight = cellBottomLabelSize(for: message, at: indexPath).height

        return messageContainerHeight + cellBottomLabelHeight + cellTopLabelHeight

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
