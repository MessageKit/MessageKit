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
    private lazy var linkPreviewView: LinkPreviewView = {
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

    private struct DummyMessage: MessageType {
        let sender: SenderType
        let messageId: String
        let sentDate: Date
        var kind: MessageKind
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }

        let textColor: UIColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        linkPreviewView.titleLabel.textColor = textColor
        linkPreviewView.teaserLabel.textColor = textColor
        linkPreviewView.domainLabel.textColor = textColor

        guard case MessageKind.linkPreview(let linkItem) = message.kind else {
            fatalError("LinkPreviewMessageCell received unhandled MessageDataType: \(message.kind)")
        }

        let kind: MessageKind
        if let text = linkItem.text {
            kind = .text(text)
        } else if let attributedText = linkItem.attributedText {
            kind = .attributedText(attributedText)
        } else {
            fatalError("LinkItem must have \"text\" or \"attributedText\"")
        }

        let dummyMessage = DummyMessage(sender: message.sender,
                                        messageId: message.messageId,
                                        sentDate: message.sentDate,
                                        kind: kind)
        super.configure(with: dummyMessage, at: indexPath, and: messagesCollectionView)

        linkPreviewView.titleLabel.text = linkItem.title
        linkPreviewView.teaserLabel.text = linkItem.teaser
        linkPreviewView.domainLabel.text = linkItem.url.host?.lowercased()
        linkPreviewView.imageView.image = linkItem.thumbnailImage
        linkURL = linkItem.url
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

open class LinkPreviewView: UIView {
    lazy var imageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.widthAnchor.constraint(equalToConstant: LinkPreviewMessageSizeCalculator.imageViewSize),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])

        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = LinkPreviewMessageSizeCalculator.titleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var teaserLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = LinkPreviewMessageSizeCalculator.teaserFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var domainLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = LinkPreviewMessageSizeCalculator.domainFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                          constant: LinkPreviewMessageSizeCalculator.imageViewMargin),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        return view
    }()

    init() {
        super.init(frame: .zero)

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        contentView.addSubview(teaserLabel)
        NSLayoutConstraint.activate([
            teaserLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            teaserLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            teaserLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        teaserLabel.setContentHuggingPriority(.init(249), for: .vertical)

        contentView.addSubview(domainLabel)
        NSLayoutConstraint.activate([
            domainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            domainLabel.topAnchor.constraint(equalTo: teaserLabel.bottomAnchor, constant: 3),
            domainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            domainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
