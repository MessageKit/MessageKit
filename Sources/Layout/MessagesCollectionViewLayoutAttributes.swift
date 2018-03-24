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

    var avatarSize: CGSize = .zero
    var avatarPosition = AvatarPosition(vertical: .cellBottom)

    var messageContainerSize: CGSize = .zero
    var messageContainerPadding: UIEdgeInsets = .zero
    var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    var messageLabelInsets: UIEdgeInsets = .zero

    var topLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    var topLabelSize: CGSize = .zero

    var bottomLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    var bottomLabelSize: CGSize = .zero

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
        // swiftlint:disable unused_optional_binding
        if let _ = object as? MessagesCollectionViewLayoutAttributes {
            return super.isEqual(object)
        } else {
            return false
        }
        // swiftlint:enable unused_optional_binding
    }
}
