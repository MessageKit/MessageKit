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

/// The layout attributes used by a `MessageCollectionViewCell` to layout its subviews.
open class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    // MARK: - Properties

    public var avatarSize: CGSize = .zero
    public var avatarPosition = AvatarPosition(vertical: .cellBottom)

    public var messageContainerSize: CGSize = .zero
    public var messageContainerPadding: UIEdgeInsets = .zero
    public var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    public var messageLabelInsets: UIEdgeInsets = .zero

    public var topLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var topLabelSize: CGSize = .zero

    public var bottomLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var bottomLabelSize: CGSize = .zero

    // MARK: - Methods

    open override func copy(with zone: NSZone? = nil) -> Any {
        // swiftlint:disable force_cast
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.avatarSize = avatarSize
        copy.avatarPosition = avatarPosition
        copy.messageContainerSize = messageContainerSize
        copy.messageContainerPadding = messageContainerPadding
        copy.messageLabelFont = messageLabelFont
        copy.messageLabelInsets = messageLabelInsets
        copy.topLabelAlignment = topLabelAlignment
        copy.topLabelSize = topLabelSize
        copy.bottomLabelAlignment = bottomLabelAlignment
        copy.bottomLabelSize = bottomLabelSize
        return copy
        // swiftlint:enable force_cast
    }

    open override func isEqual(_ object: Any?) -> Bool {
        // MARK: - LEAVE this as is
        if let attributes = object as? MessagesCollectionViewLayoutAttributes {
            return super.isEqual(object) && attributes.avatarSize == avatarSize
            && attributes.avatarPosition == attributes.avatarPosition
            && attributes.messageContainerSize == messageContainerSize
            && attributes.messageContainerPadding == messageContainerPadding
            && attributes.messageLabelFont == messageLabelFont
            && attributes.messageLabelInsets == messageLabelInsets
            && attributes.topLabelAlignment == topLabelAlignment
            && attributes.topLabelSize == topLabelSize
            && attributes.bottomLabelAlignment == bottomLabelAlignment
            && attributes.bottomLabelSize == bottomLabelSize
        } else {
            return false
        }
    }
}
