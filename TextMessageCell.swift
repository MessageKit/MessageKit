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

open class TextMessageCell: MessageCollectionViewCell<MessageLabel> {

    // MARK: - Properties

    override open weak var delegate: MessageCellDelegate? {
        didSet {
            messageContentView.delegate = delegate
        }
    }

    override var messageTapGesture: UITapGestureRecognizer? {
        didSet {
            messageTapGesture?.delegate = messageContentView
        }
    }

    // MARK: - Methods

    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }

        avatarView.frame = attributes.avatarFrame

        messageContainerView.frame = attributes.messageContainerFrame
        messageContentView.frame = CGRect(origin: .zero, size: attributes.messageContainerFrame.size)
        messageContentView.textInsets = attributes.messageLabelInsets

        cellTopLabel.frame = attributes.cellTopLabelFrame
        cellTopLabel.textInsets = attributes.cellTopLabelInsets

        cellBottomLabel.frame = attributes.cellBottomLabelFrame
        cellBottomLabel.textInsets = attributes.cellBottomLabelInsets

    }

    override open func prepareForReuse() {
        super.prepareForReuse()
        cellTopLabel.text = nil
        cellTopLabel.attributedText = nil
        cellBottomLabel.text = nil
        cellBottomLabel.attributedText = nil
    }

    override public func configure(with message: MessageType) {
        switch message.data {
        case .text(let text):
            messageContentView.text = text
        case .attributedText(let text):
            messageContentView.attributedText = text
        }
    }

}
