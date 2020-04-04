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

import Foundation

open class LinkPreviewMessageSizeCalculator: TextMessageSizeCalculator {

    private struct DummyMessage: MessageType {
        let sender: SenderType
        let messageId: String
        let sentDate: Date
        var kind: MessageKind
    }

    static let imageViewSize: CGFloat = 60
    static let imageViewMargin: CGFloat = 8

    static var titleFont: UIFont = {
        let font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let fontMetrics = UIFontMetrics(forTextStyle: .footnote)
        return fontMetrics.scaledFont(for: font)
    }()

    static var teaserFont: UIFont = {
        .preferredFont(forTextStyle: .caption2)
    }()

    static var domainFont: UIFont = {
        let font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let fontMetrics = UIFontMetrics(forTextStyle: .caption1)
        return fontMetrics.scaledFont(for: font)
    }()

    open override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        switch message.kind {
        case .linkPreview:
            let maxWidth = super.messageContainerMaxWidth(for: message)
            return max(maxWidth, (layout?.collectionView?.bounds.width ?? 0) * 0.75)
        default:
            return super.messageContainerMaxWidth(for: message)
        }
    }

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        guard case MessageKind.linkPreview(let linkItem) = message.kind else {
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
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

        var containerSize = super.messageContainerSize(for: dummyMessage)
        containerSize.width = max(containerSize.width, messageContainerMaxWidth(for: message))

        let labelInsets: UIEdgeInsets = messageLabelInsets(for: dummyMessage)

        let minHeight = containerSize.height + LinkPreviewMessageSizeCalculator.imageViewSize
        let previewMaxWidth = containerSize.width - (LinkPreviewMessageSizeCalculator.imageViewSize + LinkPreviewMessageSizeCalculator.imageViewMargin + labelInsets.horizontal)

        calculateContainerSize(with: NSAttributedString(string: linkItem.title ?? "", attributes: [.font: LinkPreviewMessageSizeCalculator.titleFont]),
                               containerSize: &containerSize,
                               maxWidth: previewMaxWidth)

        calculateContainerSize(with: NSAttributedString(string: linkItem.teaser, attributes: [.font: LinkPreviewMessageSizeCalculator.teaserFont]),
                               containerSize: &containerSize,
                               maxWidth: previewMaxWidth)

        calculateContainerSize(with: NSAttributedString(string: linkItem.url.host ?? "", attributes: [.font: LinkPreviewMessageSizeCalculator.domainFont]),
                               containerSize: &containerSize,
                               maxWidth: previewMaxWidth)

        containerSize.height = max(minHeight, containerSize.height) + labelInsets.vertical

        return containerSize
    }
}

private extension LinkPreviewMessageSizeCalculator {
    private func calculateContainerSize(with attibutedString: NSAttributedString, containerSize: inout CGSize, maxWidth: CGFloat) {
        guard !attibutedString.string.isEmpty else { return }
        let size = labelSize(for: attibutedString, considering: maxWidth)
        containerSize.height += size.height
    }
}
