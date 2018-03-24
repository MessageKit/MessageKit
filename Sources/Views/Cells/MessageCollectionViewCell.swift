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

open class MessageCollectionViewCell: UICollectionViewCell, CollectionViewReusable {

    open class func reuseIdentifier() -> String {
        return "messagekit.cell.base-cell"
    }

    open var avatarView = AvatarView()

    open var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()

    open var cellTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()

    open var cellBottomLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()

    open weak var delegate: MessageCellDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupSubviews() {
        contentView.addSubview(messageContainerView)
        contentView.addSubview(avatarView)
        contentView.addSubview(cellTopLabel)
        contentView.addSubview(cellBottomLabel)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        cellTopLabel.text = nil
        cellTopLabel.attributedText = nil
        cellBottomLabel.text = nil
        cellBottomLabel.attributedText = nil
    }

    // MARK: - Configuration

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        // Call this before other laying out other subviews
        layoutMessageContainerView(with: attributes)
        layoutAvatarView(with: attributes)
        layoutBottomLabel(with: attributes)
        layoutTopLabel(with: attributes)
    }

    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        delegate = messagesCollectionView.messageCellDelegate

        let messageColor = displayDelegate.backgroundColor(for: message, at: indexPath, in: messagesCollectionView)
        let messageStyle = displayDelegate.messageStyle(for: message, at: indexPath, in: messagesCollectionView)
        
        displayDelegate.configureAvatarView(avatarView, for: message, at: indexPath, in: messagesCollectionView)

        messageContainerView.backgroundColor = messageColor
        messageContainerView.style = messageStyle

        let topText = dataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        let bottomText = dataSource.cellBottomLabelAttributedText(for: message, at: indexPath)

        cellTopLabel.attributedText = topText
        cellBottomLabel.attributedText = bottomText
    }

    /// Handle tap gesture on contentView and its subviews like messageContainerView, cellTopLabel, cellBottomLabel, avatarView ....
    open func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)

        switch true {
        case messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            delegate?.didTapMessage(in: self)
        case avatarView.frame.contains(touchLocation):
            delegate?.didTapAvatar(in: self)
        case cellTopLabel.frame.contains(touchLocation):
            delegate?.didTapTopLabel(in: self)
        case cellBottomLabel.frame.contains(touchLocation):
            delegate?.didTapBottomLabel(in: self)
        default:
            break
        }
    }
    
    /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self)
        guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
        return messageContainerView.frame.contains(touchPoint)
    }

    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return false
    }

    // MARK: - Origin Calculations

    /// Positions the cell's `AvatarView`.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutAvatarView(with attributes: MessagesCollectionViewLayoutAttributes) {
        guard attributes.avatarSize != .zero else { return }

        var origin: CGPoint = .zero

        switch attributes.avatarPosition.horizontal {
        case .cellLeading:
            break
        case .cellTrailing:
            origin.x = attributes.frame.width - attributes.avatarSize.width
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }

        switch attributes.avatarPosition.vertical {
        case .cellTop:
            break
        case .cellBottom:
            origin.y = attributes.frame.height - attributes.avatarSize.height
        case .messageTop: // Needs messageContainerView frame to be set
            origin.y = messageContainerView.frame.minY
        case .messageBottom: // Needs messageContainerView frame to be set
            origin.y = messageContainerView.frame.maxY - attributes.avatarSize.height
        case .messageCenter: // Needs messageContainerView frame to be set
            origin.y = messageContainerView.frame.midY - (attributes.avatarSize.height/2)
        }

        avatarView.frame = CGRect(origin: origin, size: attributes.avatarSize)
    }

    /// Positions the cell's `MessageContainerView`.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutMessageContainerView(with attributes: MessagesCollectionViewLayoutAttributes) {
        guard attributes.messageContainerSize != .zero else { return }

        var origin: CGPoint = .zero
        origin.y = attributes.topLabelSize.height + attributes.messageContainerPadding.top

        switch attributes.avatarPosition.horizontal {
        case .cellLeading:
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left
        case .cellTrailing:
            origin.x = attributes.frame.width - attributes.avatarSize.width - attributes.messageContainerSize.width - attributes.messageContainerPadding.right
        case .natural:
            fatalError(MessageKitError.avatarPositionUnresolved)
        }

        messageContainerView.frame = CGRect(origin: origin, size: attributes.messageContainerSize)
    }

    /// Positions the cell's top label.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutTopLabel(with attributes: MessagesCollectionViewLayoutAttributes) {
        guard attributes.topLabelSize != .zero else { return }

        cellTopLabel.textAlignment = attributes.topLabelAlignment.textAlignment
        cellTopLabel.textInsets = attributes.topLabelAlignment.textInsets

        cellTopLabel.frame = CGRect(origin: .zero, size: attributes.topLabelSize)
    }

    /// Positions the cell's bottom label.
    /// - attributes: The `MessagesCollectionViewLayoutAttributes` for the cell.
    open func layoutBottomLabel(with attributes: MessagesCollectionViewLayoutAttributes) {
        guard attributes.bottomLabelSize != .zero else { return }

        cellBottomLabel.textAlignment = attributes.bottomLabelAlignment.textAlignment
        cellBottomLabel.textInsets = attributes.bottomLabelAlignment.textInsets

        let y = messageContainerView.frame.maxY + attributes.messageContainerPadding.bottom
        let origin = CGPoint(x: 0, y: y)


        cellBottomLabel.frame = CGRect(origin: origin, size: attributes.bottomLabelSize)
    }
}
