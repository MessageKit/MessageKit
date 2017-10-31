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

import Foundation

/// A intermediate context used to store recently calculated values used by
/// the `MessagesCollectionViewFlowLayout` object to reduce redundant calculations.
final class MessageIntermediateLayoutAttributes {

    // Message
    var message: MessageType
    var indexPath: IndexPath
    var itemHeight: CGFloat = 0

    init(message: MessageType, indexPath: IndexPath) {
        self.message = message
        self.indexPath = indexPath
    }

    // AvatarView
    var avatarSize: CGSize = .zero
    var avatarVertical: AvatarAlignment = .messageBottom
    var avatarHorizontal: AvatarHorizontalAlignment = .cellLeading

    // MessageContainerView
    var messageContainerSize: CGSize = .zero
    var messageContainerMaxWidth: CGFloat = 0
    var messageContainerPadding: UIEdgeInsets = .zero
    var messageLabelInsets: UIEdgeInsets = .zero

    var messageLabelVerticalInsets: CGFloat {
        return messageLabelInsets.top + messageLabelInsets.bottom
    }

    var messageLabelHorizontalInsets: CGFloat {
        return messageLabelInsets.left + messageLabelInsets.right
    }

    var messageVerticalPadding: CGFloat {
        return messageContainerPadding.top + messageContainerPadding.bottom
    }

    var messageHorizontalPadding: CGFloat {
        return messageContainerPadding.left + messageContainerPadding.right
    }

    // Cell Top Label
    var cellBottomLabelText: NSAttributedString?
    var cellTopLabelSize: CGSize = .zero
    var cellTopLabelMaxWidth: CGFloat = 0
    var cellTopLabelAlignment: LabelAlignment = .cellLeading(.zero)

    var cellTopLabelVerticalInsets: CGFloat {
        let cellTopLabelInsets = cellTopLabelAlignment.insets
        return cellTopLabelInsets.top + cellTopLabelInsets.bottom
    }

    var cellTopLabelHorizontalInsets: CGFloat {
        let cellTopLabelInsets = cellTopLabelAlignment.insets
        return cellTopLabelInsets.left + cellTopLabelInsets.right
    }

    // Cell Bottom Label
    var cellTopLabelText: NSAttributedString?
    var cellBottomLabelSize: CGSize = .zero
    var cellBottomLabelMaxWidth: CGFloat = 0
    var cellBottomLabelAlignment: LabelAlignment = .cellTrailing(.zero)

    var cellBottomLabelVerticalInsets: CGFloat {
        let cellBottomLabelInsets = cellBottomLabelAlignment.insets
        return cellBottomLabelInsets.top + cellBottomLabelInsets.bottom
    }

    var cellBottomLabelHorizontalInsets: CGFloat {
        let cellBottomLabelInsets = cellBottomLabelAlignment.insets
        return cellBottomLabelInsets.left + cellBottomLabelInsets.right
    }

}
