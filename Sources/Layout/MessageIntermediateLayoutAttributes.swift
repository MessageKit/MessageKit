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

import Foundation

class MessageIntermediateLayoutAttributes {

    var avatarSize: CGSize = .zero
    var avatarPosition = AvatarPosition(vertical: .cellBottom)

    var messageContainerSize: CGSize = .zero
    var messageContainerPadding: UIEdgeInsets = .zero
    var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    var messageLabelInsets: UIEdgeInsets = .zero

    var topLabelAlignment = LabelAlignment.cellCenter(.zero)
    var topLabelSize: CGSize = .zero

    var bottomLabelAlignment = LabelAlignment.cellCenter(.zero)
    var bottomLabelSize: CGSize = .zero

    lazy var itemHeight: CGFloat = {
        let avatarVerticalPosition = avatarPosition.vertical
        let avatarHeight = avatarSize.height
        let messageContainerHeight = messageContainerSize.height
        let bottomLabelHeight = bottomLabelSize.height
        let topLabelHeight = topLabelSize.height
        let messageVerticalPadding = messageContainerPadding.vertical

        var cellHeight: CGFloat = 0

        switch avatarVerticalPosition {
        case .cellTop:
            cellHeight += max(avatarHeight, topLabelHeight)
            cellHeight += bottomLabelHeight
            cellHeight += messageContainerHeight
            cellHeight += messageVerticalPadding
        case .cellBottom:
            cellHeight += max(avatarHeight, bottomLabelHeight)
            cellHeight += topLabelHeight
            cellHeight += messageContainerHeight
            cellHeight += messageVerticalPadding
        case .messageTop, .messageCenter, .messageBottom:
            cellHeight += max(avatarHeight, messageContainerHeight)
            cellHeight += messageVerticalPadding
            cellHeight += topLabelHeight
            cellHeight += bottomLabelHeight
        }

        return cellHeight
    }()

}
