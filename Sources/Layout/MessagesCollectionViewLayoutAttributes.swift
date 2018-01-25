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
final class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    // MARK: - Properties

    var avatarFrame: CGRect = .zero

    var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    var messageContainerFrame: CGRect = .zero
    var messageLabelInsets: UIEdgeInsets = .zero

    var topLabelFrame: CGRect = .zero
    var bottomLabelFrame: CGRect = .zero

    // MARK: - Methods

    override func copy(with zone: NSZone? = nil) -> Any {
        // swiftlint:disable force_cast
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.avatarFrame = avatarFrame
        copy.messageContainerFrame = messageContainerFrame
        copy.messageLabelFont = messageLabelFont
        copy.messageLabelInsets = messageLabelInsets
        copy.topLabelFrame = topLabelFrame
        copy.bottomLabelFrame = bottomLabelFrame
        return copy
        // swiftlint:enable force_cast
    }

    override func isEqual(_ object: Any?) -> Bool {

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
