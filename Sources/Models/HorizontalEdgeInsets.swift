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

/// A varient of `UIEdgeInsets` that only has horizontal inset properties
public struct HorizontalEdgeInsets {

    public var left: CGFloat
    public var right: CGFloat

    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }

    public static var zero: HorizontalEdgeInsets {
        return HorizontalEdgeInsets(left: 0, right: 0)
    }
}

extension HorizontalEdgeInsets: Equatable {

    public static func == (lhs: HorizontalEdgeInsets, rhs: HorizontalEdgeInsets) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right
    }
}

extension HorizontalEdgeInsets {

    internal var horizontal: CGFloat {
        return left + right
    }
}
