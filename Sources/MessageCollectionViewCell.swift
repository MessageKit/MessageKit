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

open class MessageCollectionViewCell<ContentView: UIView>: UICollectionViewCell {

    // MARK: - Properties

    open var messageContainerView: MessageContainerView = MessageContainerView()

    open var avatarView: AvatarView = AvatarView()

    open var cellTopLabel: MessageLabel = {
        let topLabel = MessageLabel()
        topLabel.enabledDetectors = []
        return topLabel
    }()

    open var messageContentView = ContentView()

    open var cellBottomLabel: MessageLabel = {
        let bottomLabel = MessageLabel()
        bottomLabel.enabledDetectors = []
        return bottomLabel
    }()

    open weak var delegate: MessageCellDelegate?

    var messageTapGesture: UITapGestureRecognizer?

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
        messageContainerView.addSubview(messageContentView)
        contentView.addSubview(avatarView)
        contentView.addSubview(cellBottomLabel)

    }

    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }

        avatarView.frame = attributes.avatarFrame

        messageContainerView.frame = attributes.messageContainerFrame
        messageContentView.frame = CGRect(origin: .zero, size: attributes.messageContainerFrame.size)
        //messageContentView.textInsets = attributes.messageLabelInsets

        cellTopLabel.frame = attributes.cellTopLabelFrame
        cellTopLabel.textInsets = attributes.cellTopLabelInsets

        cellBottomLabel.frame = attributes.cellBottomLabelFrame
        cellBottomLabel.textInsets = attributes.cellBottomLabelInsets

    }

    override open func prepareForReuse() {
        cellTopLabel.text = nil
        cellTopLabel.attributedText = nil
        cellBottomLabel.text = nil
        cellBottomLabel.attributedText = nil
    }

    func setAvatar(_ avatar: Avatar) {

    }

    func setCellLabels(bottomText: NSAttributedString, topText: NSAttributedString) {

    }

    public func configure(with message: MessageType) {
        // Provide in subclass
    }

    func setupGestureRecognizers() {

        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarView.addGestureRecognizer(avatarTapGesture)
        avatarView.isUserInteractionEnabled = true

        let messageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMessage))
        messageContainerView.addGestureRecognizer(messageTapGesture)
        self.messageTapGesture = messageTapGesture

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
