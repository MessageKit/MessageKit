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

open class TextMessageCell: MessageCollectionViewCell {

    open override class func reuseIdentifier() -> String { return "messagekit.cell.text" }

    // MARK: - Properties

    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }

    open var messageLabel = MessageLabel()

    // MARK: - Methods

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            messageLabel.textInsets = attributes.messageLabelInsets
            messageLabel.messageLabelFont = attributes.messageLabelFont
            messageLabel.frame = messageContainerView.bounds
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(messageLabel)
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
            switch message.data {
            case .text(let text), .emoji(let text):
                messageLabel.text = text
                if let font = messageLabel.messageLabelFont {
                    messageLabel.font = font
                }
            case .attributedText(let text):
                messageLabel.attributedText = text
            default:
                break
            }
            // Needs to be set after the attributedText because it takes precedence
            messageLabel.textColor = textColor
        }
    }
    
    /// Handle `ContentView`'s tap gesture, return false when `ContentView` don't needs to handle gesture
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return messageLabel.handleGesture(touchPoint)
    }
}
