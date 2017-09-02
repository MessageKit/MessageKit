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

open class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties

    open var messageLabelFont: UIFont
    open var messageLabelInsets: UIEdgeInsets
    open var messageToViewEdgePadding: CGFloat

    open var cellTopLabelInsets: UIEdgeInsets
    open var topLabelExtendsPastAvatar: Bool

    open var cellBottomLabelInsets: UIEdgeInsets
    open var bottomLabelExtendsPastAvatar: Bool

    open var incomingAvatarSize: CGSize
    open var outgoingAvatarSize: CGSize

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
        topLabelExtendsPastAvatar = false

        cellBottomLabelInsets = .zero
        bottomLabelExtendsPastAvatar = false

        incomingAvatarSize = CGSize(width: 30, height: 30)
        outgoingAvatarSize = CGSize(width: 30, height: 30)

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
        attributes.avatarFrame = CGRect(origin: .zero, size: avatarSize(for: message))

        attributes.messageLabelFont = messageLabelFont
        attributes.messageLabelInsets = messageLabelInsets
        attributes.cellTopLabelInsets = cellTopLabelInsets
        attributes.cellBottomLabelInsets = cellBottomLabelInsets
        attributes.direction = dataSource.isFromCurrentSender(message: message) ? .outgoing : .incoming

        let displayDataSource = dataSource as? MessagesDisplayDataSource
        let avatarPosition = displayDataSource?.avatarPosition(for: message, at: indexPath, in: messagesCollectionView) ?? .messageBottom

        // Now we set the origins for the frames using the attributes object that contains the calculated sizes
        attributes.messageContainerFrame.origin = messageContainerOrigin(for: attributes)
        attributes.cellTopLabelFrame.origin = cellTopLabelOrigin(for: attributes)
        attributes.cellBottomLabelFrame.origin = cellBottomLabelOrigin(for: attributes)
        attributes.avatarFrame.origin = avatarOrigin(for: attributes, with: avatarPosition)

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

    fileprivate func avatarSize(for message: MessageType) -> CGSize {

        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return .zero }

        let isOutgoingMessage = messagesDataSource.isFromCurrentSender(message: message)

        return isOutgoingMessage ? outgoingAvatarSize : incomingAvatarSize
    }

    fileprivate func avatarOrigin(for attributes: MessagesCollectionViewLayoutAttributes, with avatarPosition: AvatarPosition) -> CGPoint {

        var origin = CGPoint.zero

        let contentWidth = attributes.frame.size.width
        let avatarWidth = attributes.avatarFrame.size.width

        switch attributes.direction {
        case .incoming:
            origin.x = 0
        case .outgoing:
            origin.x = contentWidth - avatarWidth
        }

        let contentHeight = attributes.frame.height
        let avatarHeight = attributes.avatarFrame.height
        let cellTopLabelHeight = attributes.cellTopLabelFrame.height
        let cellBottomLabelHeight = attributes.cellBottomLabelFrame.height
        let messageContainerHeight = attributes.messageContainerFrame.height

        switch avatarPosition {
        case .cellTop:
            origin.y = topLabelExtendsPastAvatar ? cellTopLabelHeight : 0
        case .cellBottom:
            origin.y = contentHeight - avatarHeight
            if bottomLabelExtendsPastAvatar { origin.y -= cellBottomLabelHeight }
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

    // MARK: - Message Container Calculations

    private func availableWidthForMessageContainer(considering message: MessageType) -> CGFloat {

        let avatarWidth = avatarSize(for: message).width
        let avatarWidthPlusPadding = avatarWidth == 0 ? 0 : avatarWidth + avatarMessagePadding

        let horizontalMessageInsets = messageLabelInsets.left + messageLabelInsets.right
        let availableWidth = itemWidth - avatarWidthPlusPadding - horizontalMessageInsets - messageToViewEdgePadding

        return availableWidth

    }

    private func messageContainerWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let containerHeight = messageContainerHeight(for: message, at: indexPath)
        let availableWidth = availableWidthForMessageContainer(considering: message)
        let horizontalMessageInsets = messageLabelInsets.left + messageLabelInsets.right
        var estimatedWidth: CGFloat = 0

        switch message.data {
        case .text(let text):
            estimatedWidth = text.width(considering: containerHeight, and: messageLabelFont).rounded(.up)
        case .attributedText(let text):
            estimatedWidth = text.width(considering: containerHeight).rounded(.up)
        }

        let widthToUse = estimatedWidth > availableWidth ? availableWidth : estimatedWidth

        let finalWidth = widthToUse + horizontalMessageInsets

        return finalWidth
        
    }

    private func messageContainerHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let availableWidth = availableWidthForMessageContainer(considering: message)
        let verticalMessageInsets = messageLabelInsets.top + messageLabelInsets.bottom
        var estimatedHeight: CGFloat = 0

        switch message.data {
        case .text(let text):
            estimatedHeight = text.height(considering: availableWidth, and: messageLabelFont)
        case .attributedText(let text):
            estimatedHeight = text.height(considering: availableWidth)
        }

        let finalHeight = estimatedHeight.rounded(.up) + verticalMessageInsets

        return finalHeight
        
    }

    fileprivate func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        let messageWidth = messageContainerWidth(for: message, at: indexPath)
        let messageHeight = messageContainerHeight(for: message, at: indexPath)

        return CGSize(width: messageWidth, height: messageHeight)

    }

    fileprivate func messageContainerOrigin(for attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        let contentWidth = attributes.frame.width
        let avatarWidth = attributes.avatarFrame.width
        let messageContainerWidth = attributes.messageContainerFrame.width
        let cellTopLabelHeight = attributes.cellTopLabelFrame.height

        var origin = CGPoint.zero

        switch attributes.direction {
        case .incoming:
            origin.x = avatarWidth + avatarMessagePadding
            origin.y = cellTopLabelHeight
        case .outgoing:
            origin.x = contentWidth - avatarWidth - avatarMessagePadding - messageContainerWidth
            origin.y = cellTopLabelHeight
        }

        return origin

    }

    // MARK: - Cell Top Label Calculations

    private func cellTopLabelWidth(for message: MessageType) -> CGFloat {
        if topLabelExtendsPastAvatar {
            return itemWidth
        } else {
            return itemWidth - avatarSize(for: message).width - avatarMessagePadding - messageToViewEdgePadding
        }
    }

    private func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let displayDataSource = messagesCollectionView.messagesDataSource as? MessagesDisplayDataSource else { return 0 }
        guard let topLabelText = displayDataSource.cellTopLabelAttributedText(for: message, at: indexPath) else { return 0 }

        let availableWidth = cellTopLabelWidth(for: message) - cellTopLabelInsets.left - cellTopLabelInsets.right

        let estimatedHeight = topLabelText.height(considering: availableWidth)

        return estimatedHeight.rounded(.up)
        
    }

    fileprivate func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        let topLabelWidth = cellTopLabelWidth(for: message)
        let topLabelHeight = cellTopLabelHeight(for: message, at: indexPath)

        return CGSize(width: topLabelWidth, height: topLabelHeight)
        
    }

    fileprivate func cellTopLabelOrigin(for attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        var origin = CGPoint.zero

        if topLabelExtendsPastAvatar == false {
            let avatarWidth = attributes.avatarFrame.width
            origin.x = avatarWidth + avatarMessagePadding
        }

        return origin

    }

    // MARK: - Cell Bottom Label Calculations

    private func cellBottomLabelWidth(for message: MessageType) -> CGFloat {
        if bottomLabelExtendsPastAvatar {
            return itemWidth
        } else {
            return itemWidth - avatarSize(for: message).width - avatarMessagePadding - messageToViewEdgePadding

        }
    }

    private func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        guard let messagesCollectionView = messagesCollectionView else { return 0 }
        guard let displayDataSource = messagesCollectionView.messagesDataSource as? MessagesDisplayDataSource else { return 0 }
        guard let bottomLabelText = displayDataSource.cellBottomLabelAttributedText(for: message, at: indexPath) else { return 0 }

        let availableWidth = cellBottomLabelWidth(for: message) - cellBottomLabelInsets.left - cellBottomLabelInsets.right

        let estimatedHeight = bottomLabelText.height(considering: availableWidth)

        return estimatedHeight.rounded(.up)
    }

    fileprivate func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {

        let bottomLabelWidth = cellBottomLabelWidth(for: message)
        let bottomLabelHeight = cellBottomLabelHeight(for: message, at: indexPath)

        return CGSize(width: bottomLabelWidth, height: bottomLabelHeight)
        
    }

    fileprivate func cellBottomLabelOrigin(for attributes: MessagesCollectionViewLayoutAttributes) -> CGPoint {

        var origin = CGPoint.zero

        let contentHeight = attributes.frame.height
        let cellBottomLabelHeight = attributes.cellBottomLabelFrame.height

        origin.y = contentHeight - cellBottomLabelHeight

        if bottomLabelExtendsPastAvatar == false {
            let avatarWidth = attributes.avatarFrame.width
            origin.x = avatarWidth + avatarMessagePadding
        }

        return origin

    }

    // MARK: - Cell Size Calculations

    private func minimumCellHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let size = avatarSize(for: message)
        let avatarHeight = size.height
        let bottomLabelHeight = cellBottomLabelHeight(for: message, at: indexPath)
        let topLabelHeight = cellTopLabelHeight(for: message, at: indexPath)

        let minimumHeight = topLabelHeight + avatarHeight + bottomLabelHeight

        return minimumHeight
        
    }

    private func estimatedCellHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let containerHeight = messageContainerHeight(for: message, at: indexPath)
        let topLabelHeight = cellTopLabelHeight(for: message, at: indexPath)
        let bottomLabelheight = cellBottomLabelHeight(for: message, at: indexPath)

        return topLabelHeight + containerHeight + bottomLabelheight

    }

    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        
        guard let messagesCollectionView = messagesCollectionView else { return .zero }
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .zero }
        
        let message = dataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        let minimumHeight = minimumCellHeight(for: message, at: indexPath)
        let estimatedHeight = estimatedCellHeight(for: message, at: indexPath)
        let finalHeight = estimatedHeight < minimumHeight ? minimumHeight : estimatedHeight
        
        return CGSize(width: itemWidth, height: finalHeight)
        
    }
    
}
