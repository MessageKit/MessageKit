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

    static let imageViewSize: CGFloat = 60
    static let imageViewMargin: CGFloat = 8

    public var titleFont: UIFont
    public var teaserFont: UIFont = .preferredFont(forTextStyle: .caption2)
    public var domainFont: UIFont

    public override init(layout: MessagesCollectionViewFlowLayout?) {
        let titleFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let titleFontMetrics = UIFontMetrics(forTextStyle: .footnote)
        self.titleFont = titleFontMetrics.scaledFont(for: titleFont)

        let domainFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let domainFontMetrics = UIFontMetrics(forTextStyle: .caption1)
        self.domainFont = domainFontMetrics.scaledFont(for: domainFont)

        super.init(layout: layout)
    }

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

        let dummyMessage = ConcreteMessageType(sender: message.sender,
                                               messageId: message.messageId,
                                               sentDate: message.sentDate,
                                               kind: linkItem.textKind)

        var containerSize = super.messageContainerSize(for: dummyMessage)
        containerSize.width = max(containerSize.width, messageContainerMaxWidth(for: message))

        let labelInsets: UIEdgeInsets = messageLabelInsets(for: dummyMessage)

        let minHeight = containerSize.height + LinkPreviewMessageSizeCalculator.imageViewSize
        let previewMaxWidth = containerSize.width - (LinkPreviewMessageSizeCalculator.imageViewSize + LinkPreviewMessageSizeCalculator.imageViewMargin + labelInsets.horizontal)

        calculateContainerSize(with: NSAttributedString(string: linkItem.title ?? "", attributes: [.font: titleFont]),
                               containerSize: &containerSize,
                               maxWidth: previewMaxWidth)

        calculateContainerSize(with: NSAttributedString(string: linkItem.teaser, attributes: [.font: teaserFont]),
                               containerSize: &containerSize,
                               maxWidth: previewMaxWidth)

        calculateContainerSize(with: NSAttributedString(string: linkItem.url.host ?? "", attributes: [.font: domainFont]),
                               containerSize: &containerSize,
                               maxWidth: previewMaxWidth)

        containerSize.height = max(minHeight, containerSize.height) + labelInsets.vertical

        return containerSize
    }

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        attributes.linkPreviewFonts = LinkPreviewFonts(titleFont: titleFont, teaserFont: teaserFont, domainFont: domainFont)
    }
}

private extension LinkPreviewMessageSizeCalculator {
    private func calculateContainerSize(with attibutedString: NSAttributedString, containerSize: inout CGSize, maxWidth: CGFloat) {
        guard !attibutedString.string.isEmpty else { return }
        let size = labelSize(for: attibutedString, considering: maxWidth)
        containerSize.height += size.height
    }
}
