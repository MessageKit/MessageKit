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

    open var messageContainerView: UIView = {
        let messageContainerView = UIView()
        messageContainerView.layer.cornerRadius = 12.0
        messageContainerView.layer.masksToBounds = true
        return messageContainerView
    }()

    open var avatarView: AvatarView = AvatarView()

    open var cellTopLabel: MessageLabel = {
        let topLabel = MessageLabel()
        topLabel.enabledDetectors = []
        return topLabel
    }()

    open var messageLabel: MessageLabel = MessageLabel()

    open var cellBottomLabel: MessageLabel = {
        let bottomLabel = MessageLabel()
        bottomLabel.enabledDetectors = []
        return bottomLabel
    }()

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

    private func cellTopLabelFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = .zero

        if attributes.topLabelExtendsPastAvatar == false {
            origin = CGPoint(x: attributes.avatarSize.width + attributes.avatarMessagePadding, y: 0)
        }

        return CGRect(origin: origin, size: attributes.cellTopLabelSize)
    }

    private func cellBottomLabelFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = CGPoint(x: 0, y: contentView.frame.height - attributes.cellBottomLabelSize.height)

        if attributes.bottomLabelExtendsPastAvatar == false {
            origin.x = attributes.avatarSize.width + attributes.avatarMessagePadding
        }

        return CGRect(origin: origin, size: attributes.cellBottomLabelSize)
    }

    private func messageContainerFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

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

    private func avatarViewFrame(for attributes: MessagesCollectionViewLayoutAttributes) -> CGRect {

        var origin: CGPoint = .zero

        switch attributes.avatarPosition {
        case .cellTop:
            if attributes.topLabelExtendsPastAvatar {
                origin.y = attributes.cellTopLabelSize.height
            } else {
                origin.y = 0
            }
        case .cellBottom:
            if attributes.bottomLabelExtendsPastAvatar {
                origin.y = contentView.frame.height - attributes.avatarSize.height - attributes.cellBottomLabelSize.height
            } else {
                origin.y = contentView.frame.height - attributes.avatarSize.height
            }
        case .messageTop:
            origin.y = attributes.cellTopLabelSize.height
        case .messageBottom:
            origin.y = contentView.frame.height - attributes.avatarSize.height - attributes.cellBottomLabelSize.height
        case .messageCenter:
            let messageMidY = (attributes.messageContainerSize.height / 2)
            let avatarMidY = (attributes.avatarSize.height / 2)
            origin.y = contentView.frame.height - attributes.cellTopLabelSize.height - messageMidY - avatarMidY
        }

        switch attributes.direction {
        case .outgoing:
            origin.x = contentView.frame.width - attributes.avatarSize.width
        case .incoming:
            origin.x = 0
        }

        return CGRect(origin: origin, size: attributes.avatarSize)

    }

    public func configure(with message: MessageType) {

        switch message.data {
        case .text(let text):
            messageLabel.text = text
        case .attributedText(let text):
            messageLabel.attributedText = text
        }

    }

    private func setupGestureRecognizers() {

        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarView.addGestureRecognizer(avatarTapGesture)
        avatarView.isUserInteractionEnabled = true

        let messageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMessage))
        messageContainerView.addGestureRecognizer(messageTapGesture)
        messageTapGesture.delegate = messageLabel

        let topLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopLabel))
        cellTopLabel.addGestureRecognizer(topLabelTapGesture)
        cellTopLabel.isUserInteractionEnabled = true

        let bottomlabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBottomLabel))
        cellBottomLabel.addGestureRecognizer(bottomlabelTapGesture)
        cellBottomLabel.isUserInteractionEnabled = true

    }

    // MARK: - Delegate Methods

    func didTapAvatar() {
        delegate?.didTapAvatar(in: self)
    }

    func didTapMessage() {
        delegate?.didTapMessage(in: self)
    }

    func didTapTopLabel() {
        delegate?.didTapTopLabel(in: self)
    }

    func didTapBottomLabel() {
        delegate?.didTapBottomLabel(in: self)
    }
}
