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
    open override class func reuseIdentifier() -> String { return "messagekit.cell.text" }

    // MARK: - Properties

    open override weak var delegate: MessageCellDelegate? {
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

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        messageContentView.textInsets = attributes.messageLabelInsets
        messageContentView.font = attributes.messageLabelFont
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageContentView.attributedText = nil
        messageContentView.text = nil
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        if let displayDelegate = messagesCollectionView.messagesDisplayDelegate as? TextMessageDisplayDelegate {
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            let detectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
            messageContentView.textColor = textColor
            messageContentView.enabledDetectors = detectors
        }

        switch message.data {
        case .text(let text), .emoji(let text):
            messageContentView.text = text
        case .attributedText(let text):
            messageContentView.attributedText = text
        default:
            break
        }
    }
    
}
