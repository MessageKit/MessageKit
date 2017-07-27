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

final class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // MARK: - Properties
    
    var direction: MessageDirection = .outgoing

    var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    var messageContainerSize: CGSize = .zero
    
    var messageContainerInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    var avatarSize: CGSize = CGSize(width: 30, height: 30)
    
    var avatarBottomSpacing: CGFloat = 4
    
    var avatarContainerSpacing: CGFloat = 4
    
    // MARK: - Methods
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.direction = direction
        copy.messageFont = messageFont
        copy.messageContainerSize = messageContainerSize
        copy.avatarSize = avatarSize
        copy.messageContainerInsets = messageContainerInsets
        copy.avatarBottomSpacing = avatarBottomSpacing
        copy.avatarContainerSpacing = avatarContainerSpacing
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        
        // MARK: - LEAVE this as is
        if let _ = object as? MessagesCollectionViewLayoutAttributes {
            return super.isEqual(object)
        } else {
            return false
        }
    }
}
