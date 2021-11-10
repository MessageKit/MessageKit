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
import UIKit

/// Used to determine the `Horizontal` and `Vertical` position of
// an `AvatarView` in a `MessageCollectionViewCell`.
public struct AvatarPosition: Equatable {
    
    /// An enum representing the horizontal alignment of an `AvatarView`.
    public enum Horizontal {
        
        /// Positions the `AvatarView` on the side closest to the cell's leading edge.
        case cellLeading
        
        /// Positions the `AvatarView` on the side closest to the cell's trailing edge.
        case cellTrailing
        
        /// Positions the `AvatarView` based on whether the message is from the current Sender.
        /// The cell is positioned `.cellTrailing` if `isFromCurrentSender` is true
        /// and `.cellLeading` if false.
        case natural
    }
    
    /// An enum representing the vertical alignment for an `AvatarView`.
    public enum Vertical {
        
        /// Aligns the `AvatarView`'s top edge to the cell's top edge.
        case cellTop
        
        /// Aligns the `AvatarView`'s top edge to the `messageTopLabel`'s top edge.
        case messageLabelTop
        
        /// Aligns the `AvatarView`'s top edge to the `MessageContainerView`'s top edge.
        case messageTop
        
        /// Aligns the `AvatarView` center to the `MessageContainerView` center.
        case messageCenter
        
        /// Aligns the `AvatarView`'s bottom edge to the `MessageContainerView`s bottom edge.
        case messageBottom
        
        /// Aligns the `AvatarView`'s bottom edge to the cell's bottom edge.
        case cellBottom
        
    }
    
    // MARK: - Properties
    
    // The vertical position
    public var vertical: Vertical
    
    // The horizontal position
    public var horizontal: Horizontal
    
    // MARK: - Initializers
    
    public init(horizontal: Horizontal, vertical: Vertical) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public init(vertical: Vertical) {
        self.init(horizontal: .natural, vertical: vertical)
    }
    
}

// MARK: - Equatable Conformance

public extension AvatarPosition {

    static func == (lhs: AvatarPosition, rhs: AvatarPosition) -> Bool {
        return lhs.vertical == rhs.vertical && lhs.horizontal == rhs.horizontal
    }
    
}
