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

import UIKit

open class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // MARK: - Properties

    var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    var avatarSize = CGSize(width: 30.0, height: 30.0)
    
    // Constant right now
    var avatarBottomPadding: CGFloat = 4
    var avatarToContainerPadding: CGFloat = 4
    
    var messageContainerSize: CGSize = .zero
    
    var messageLeftRightPadding: CGFloat = 16
    
    var direction: MessageDirection = .outgoing
    
    // MARK: - Methods
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.messageFont = messageFont
        copy.avatarSize = avatarSize
        copy.avatarBottomPadding = avatarBottomPadding
        copy.avatarToContainerPadding = avatarToContainerPadding
        copy.messageContainerSize = messageContainerSize
        copy.messageLeftRightPadding = messageLeftRightPadding
        copy.direction = direction
        return copy
    }
    
    override open func isEqual(_ object: Any?) -> Bool {

        guard let attributes = object as? MessagesCollectionViewLayoutAttributes else { return false }
        return super.isEqual(object)
//        return
//            attributes.messageFont == messageFont &&
//            attributes.avatarSize == avatarSize &&
//            attributes.avatarBottomPadding == avatarBottomPadding &&
//            attributes.avatarToContainerPadding == avatarToContainerPadding &&
//            attributes.messageContainerSize == attributes.messageContainerSize &&
//            attributes.messageLeftRightPadding == messageLeftRightPadding &&
//            attributes.direction == direction
    }
    
}
