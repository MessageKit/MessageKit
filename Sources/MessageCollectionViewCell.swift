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

open class MessageCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    open let messageContainerView: UIView = {
        let messageContainerView = UIView()
        messageContainerView.layer.cornerRadius = 12.0
        messageContainerView.layer.masksToBounds = true
        return messageContainerView
    }()

    open var avatarView: AvatarView = AvatarView()

    open var cellTopLabel: MessageLabel = MessageLabel()

    open var messageLabel: MessageLabel = MessageLabel()

    open var cellBottomLabel: MessageLabel = MessageLabel()

    open weak var delegate: MessageCellDelegate?

    // MARK: - Initializer

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizers()
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setupSubviews() {

        contentView.addSubview(cellTopLabel)
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
        contentView.addSubview(avatarView)
        contentView.addSubview(cellBottomLabel)

    }

    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }

        cellTopLabel.frame = cellTopLabelFrame(for: attributes)
        cellTopLabel.textInsets = attributes.cellTopLabelInsets

        messageContainerView.frame = messageContainerFrame(for: attributes)
        messageLabel.frame = CGRect(origin: .zero, size: attributes.messageContainerSize)
        messageLabel.textInsets = attributes.messageLabelInsets

        avatarView.frame = avatarViewFrame(for: attributes)

        cellBottomLabel.frame = cellBottomLabelFrame(for: attributes)
        cellBottomLabel.textInsets = attributes.cellBottomLabelInsets

        switch attributes.direction {
        case .incoming:
            cellTopLabel.textAlignment = .left
            cellBottomLabel.textAlignment = .right
        case .outgoing:
            cellTopLabel.textAlignment = .right
            cellBottomLabel.textAlignment = .left
        }

    }

    func cellTopLabelFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = .zero

        if attributes.topLabelPinnedUnderMessage {
            origin = CGPoint(x: attributes.avatarSize.width + attributes.avatarMessagePadding, y: 0)
        }

        return CGRect(origin: origin, size: attributes.cellTopLabelSize)
    }

    func cellBottomLabelFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = CGPoint(x: 0, y: contentView.frame.height - attributes.cellBottomLabelSize.height)

        if attributes.bottomLabelPinnedUnderMessage {
            origin.x = attributes.avatarSize.width + attributes.avatarMessagePadding
        }

        return CGRect(origin: origin, size: attributes.cellBottomLabelSize)
    }

    func messageContainerFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = .zero

        let yPosition = attributes.cellTopLabelSize.height

        switch attributes.direction {
        case .outgoing:
            let xPosition = contentView.frame.width - attributes.avatarSize.width - attributes.avatarMessagePadding - attributes.messageContainerSize.width
            origin = CGPoint(x: xPosition, y: yPosition)
        case .incoming:
            let xPosition = attributes.avatarSize.width + attributes.avatarMessagePadding
            origin = CGPoint(x: xPosition, y: yPosition)
        }

        return CGRect(origin: origin, size: attributes.messageContainerSize)

    }

    func avatarViewFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = .zero

        let yPosition = contentView.frame.height - attributes.avatarSize.height - attributes.avatarBottomPadding - attributes.cellBottomLabelSize.height

        switch attributes.direction {
        case .outgoing:
            let xPosition = contentView.frame.width - attributes.avatarSize.width
            origin = CGPoint(x: xPosition, y: yPosition)
        case .incoming:
            origin = CGPoint(x: 0, y: yPosition)
        }

        return CGRect(origin: origin, size: attributes.avatarSize)

    }

    func configure(with message: MessageType) {

        switch message.data {
        case .text(let text):
            messageLabel.text = text
        }

    }

    func setupGestureRecognizers() {

        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarView.addGestureRecognizer(avatarTapGesture)
        avatarView.isUserInteractionEnabled = true

        let messageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMessage))
        messageContainerView.addGestureRecognizer(messageTapGesture)

    }

    // MARK: - Delegate Methods

    func didTapAvatar() {
        delegate?.didTapAvatar(in: self)
    }

    func didTapMessage() {
        delegate?.didTapMessage(in: self)
    }
}
