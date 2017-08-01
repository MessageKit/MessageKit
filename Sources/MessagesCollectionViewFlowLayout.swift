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

    open var messageFont: UIFont

    open var incomingAvatarSize: CGSize

    open var outgoingAvatarSize: CGSize

    open var messageContainerInsets: UIEdgeInsets

    fileprivate let avatarBottomSpacing: CGFloat = 4

    fileprivate let avatarContainerSpacing: CGFloat = 4

    fileprivate var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }

    override open class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }

    // MARK: - Initializers

    override public init() {
        messageFont = UIFont.preferredFont(forTextStyle: .body)
        incomingAvatarSize = CGSize(width: 30, height: 30)
        outgoingAvatarSize = CGSize(width: 30, height: 30)
        messageContainerInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
        super.init()
        sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

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

        guard let collectionView = collectionView as? MessagesCollectionView, let dataSource = collectionView.messagesDataSource else { return }

        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: collectionView)

        let direction: MessageDirection = dataSource.isFromCurrentSender(message: message) ? .outgoing : .incoming
        let avatarSize = avatarSizeFor(message: message)
        let messageContainerSize = containerSizeFor(message: message)

        attributes.direction = direction
        attributes.messageFont = messageFont
        attributes.messageContainerSize = messageContainerSize
        attributes.messageContainerInsets = messageContainerInsets
        attributes.avatarSize = avatarSize
        attributes.avatarBottomSpacing = avatarBottomSpacing
        attributes.avatarContainerSpacing = avatarContainerSpacing

    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

        return collectionView?.bounds.width != newBounds.width

    }

}

extension MessagesCollectionViewFlowLayout {

    func avatarSizeFor(message: MessageType) -> CGSize {

        guard let collectionView = collectionView as? MessagesCollectionView, let dataSource = collectionView.messagesDataSource else { return .zero }

        return dataSource.isFromCurrentSender(message: message) ? outgoingAvatarSize : incomingAvatarSize

    }

    func minimumCellHeightFor(message: MessageType) -> CGFloat {

        guard let collectionView = collectionView as? MessagesCollectionView, let dataSource = collectionView.messagesDataSource else { return 0 }

        let messageDirection: MessageDirection = dataSource.isFromCurrentSender(message: message) ? .outgoing : .incoming

        switch messageDirection {
        case .incoming:
            return incomingAvatarSize.height + avatarBottomSpacing
        case .outgoing:
            return outgoingAvatarSize.height + avatarBottomSpacing
        }

    }

    func containerHeightForMessage(message: MessageType) -> CGFloat {

        let avatarSize = avatarSizeFor(message: message)
        let insets = messageContainerInsets.left + messageContainerInsets.right
        let availableWidth = itemWidth - avatarSize.width - avatarContainerSpacing - insets

        // This is a switch because support for more messages are to come
        switch message.data {
        case .text(let text):
            let estimatedHeight = text.height(considering: availableWidth, and: messageFont)
            let insets = messageContainerInsets.top + messageContainerInsets.bottom
            return estimatedHeight.rounded(.up) + insets //+ 1
        }

    }

    func containerWidthForMessage(message: MessageType) -> CGFloat {

        let containerHeight = containerHeightForMessage(message: message)

        let avatarSize = avatarSizeFor(message: message)
        let insets = messageContainerInsets.left + messageContainerInsets.right
        let availableWidth = itemWidth - avatarSize.width - avatarContainerSpacing - insets

        // This is a switch because support for more messages are to come
        switch message.data {
        case .text(let text):
            let estimatedWidth = text.width(considering: containerHeight, and: messageFont).rounded(.up)
            let insets = messageContainerInsets.left + messageContainerInsets.right
            let finalWidth = estimatedWidth > availableWidth ? availableWidth : estimatedWidth
            return finalWidth + insets
        }

    }

    func estimatedCellHeightForMessage(message: MessageType) -> CGFloat {

        let messageContainerHeight = containerHeightForMessage(message: message)
        return messageContainerHeight

    }

    func containerSizeFor(message: MessageType) -> CGSize {

        let containerHeight = containerHeightForMessage(message: message)
        let containerWidth = containerWidthForMessage(message: message)

        return CGSize(width: containerWidth, height: containerHeight)

    }

    func sizeForItem(at indexPath: IndexPath) -> CGSize {

        guard let collectionView = collectionView as? MessagesCollectionView, let dataSource = collectionView.messagesDataSource else { return .zero }

        let message = dataSource.messageForItem(at: indexPath, in: collectionView)

        let minHeight = minimumCellHeightFor(message: message)
        let estimatedHeight = estimatedCellHeightForMessage(message: message)
        let actualHeight = estimatedHeight < minHeight ? minHeight : estimatedHeight

        return CGSize(width: itemWidth, height: actualHeight)

    }

}
