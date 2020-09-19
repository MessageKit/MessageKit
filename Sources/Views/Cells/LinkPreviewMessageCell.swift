/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

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

open class LinkPreviewMessageCell: TextMessageCell {
    public lazy var linkPreviewView: LinkPreviewView = {
        let view = LinkPreviewView()
        view.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor,
                                          constant: messageLabel.textInsets.left),
            view.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor,
                                           constant: messageLabel.textInsets.right * -1),
            view.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor,
                                         constant: messageLabel.textInsets.bottom * -1)
        ])
        return view
    }()

    private var linkURL: URL?

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        linkPreviewView.titleLabel.font = attributes.linkPreviewFonts.titleFont
        linkPreviewView.teaserLabel.font = attributes.linkPreviewFonts.teaserFont
        linkPreviewView.domainLabel.font = attributes.linkPreviewFonts.domainFont
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        let displayDelegate = messagesCollectionView.messagesDisplayDelegate

        if let textColor: UIColor = displayDelegate?.textColor(for: message, at: indexPath, in: messagesCollectionView) {
            linkPreviewView.titleLabel.textColor = textColor
            linkPreviewView.teaserLabel.textColor = textColor
            linkPreviewView.domainLabel.textColor = textColor
        }

        guard case MessageKind.linkPreview(let linkItem) = message.kind else {
            fatalError("LinkPreviewMessageCell received unhandled MessageDataType: \(message.kind)")
        }

        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        linkPreviewView.titleLabel.text = linkItem.title
        linkPreviewView.teaserLabel.text = linkItem.teaser
        linkPreviewView.domainLabel.text = linkItem.url.host?.lowercased()
        linkPreviewView.imageView.image = linkItem.thumbnailImage
        linkURL = linkItem.url

        displayDelegate?.configureLinkPreviewImageView(linkPreviewView.imageView, for: message, at: indexPath, in: messagesCollectionView)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        linkPreviewView.titleLabel.text = nil
        linkPreviewView.teaserLabel.text = nil
        linkPreviewView.domainLabel.text = nil
        linkPreviewView.imageView.image = nil
        linkURL = nil
    }

    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: linkPreviewView)

        guard linkPreviewView.frame.contains(touchLocation), let url = linkURL else {
            super.handleTapGesture(gesture)
            return
        }
        delegate?.didSelectURL(url)
    }
}
