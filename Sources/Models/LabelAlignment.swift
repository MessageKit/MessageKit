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

/// An enum represnting the horizontal alignment of a `MessageCollectionViewCell`'s top and bottom labels.
public enum LabelAlignment {

    /// Aligns the label's trailing edge to the cell's trailing edge.
    /// The `UIEdgeInsets` associated value represents the offset from this position.
    case cellTrailing(UIEdgeInsets)
    
    /// Aligns the label's leading edge to the cell's leading edge.
    /// The `UIEdgeInsets` associated value represents the offset from this position.
    case cellLeading(UIEdgeInsets)
    
    /// Aligns the label's center to the cell's center.
    /// The `UIEdgeInsets` associated value represents the offset from this position.
    case cellCenter(UIEdgeInsets)
    
    /// Aligns the label's trailing edge to the `MessageContainerView`'s trailing edge.
    /// The `UIEdgeInsets` associated value represents the offset from this position.
    case messageTrailing(UIEdgeInsets)
    
    /// Aligns the label's leading edge to the `MessageContainerView`'s leading edge.
    /// The `UIEdgeInsets` associated value represents the offset from this position.
    case messageLeading(UIEdgeInsets)

    /// Returns the `UIEdgeInsets` associated value for the `LabelAlignment` case.
    public var insets: UIEdgeInsets {
        switch self {
        case .cellTrailing(let insets): return insets
        case .cellLeading(let insets): return insets
        case .cellCenter(let insets): return insets
        case .messageTrailing(let insets): return insets
        case .messageLeading(let insets): return insets
        }
    }

}
