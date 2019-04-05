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

/// Used to determine the `Horizontal` and `Vertical` position of
// an `AccessoryView` in a `MessageCollectionViewCell`.
public enum AccessoryPosition {
    
    /// Aligns the `AccessoryView`'s top edge to the cell's top edge.
    case cellTop
    
    /// Aligns the `AccessoryView`'s top edge to the `messageTopLabel`'s top edge.
    case messageLabelTop
    
    /// Aligns the `AccessoryView`'s top edge to the `MessageContainerView`'s top edge.
    case messageTop
    
    /// Aligns the `AccessoryView` center to the `MessageContainerView` center.
    case messageCenter
    
    /// Aligns the `AccessoryView`'s bottom edge to the `MessageContainerView`s bottom edge.
    case messageBottom
    
    /// Aligns the `AccessoryView`'s bottom edge to the cell's bottom edge.
    case cellBottom
}
