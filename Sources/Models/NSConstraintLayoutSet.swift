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

internal class NSLayoutConstraintSet {
    
    internal var top: NSLayoutConstraint?
    internal var bottom: NSLayoutConstraint?
    internal var left: NSLayoutConstraint?
    internal var right: NSLayoutConstraint?
    internal var centerX: NSLayoutConstraint?
    internal var centerY: NSLayoutConstraint?
    internal var width: NSLayoutConstraint?
    internal var height: NSLayoutConstraint?
    
    internal init(top: NSLayoutConstraint? = nil, bottom: NSLayoutConstraint? = nil,
                  left: NSLayoutConstraint? = nil, right: NSLayoutConstraint? = nil,
                  centerX: NSLayoutConstraint? = nil, centerY: NSLayoutConstraint? = nil,
                  width: NSLayoutConstraint? = nil, height: NSLayoutConstraint? = nil) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
    }

    /// All of the currently configured constraints
    private var availableConstraints: [NSLayoutConstraint] {
        let constraints = [top, bottom, left, right, centerX, centerY, width, height]
        var available: [NSLayoutConstraint] = []
        for constraint in constraints {
            if let value = constraint {
                available.append(value)
            }
        }
        return available
    }
    
    /// Activates all of the non-nil constraints
    ///
    /// - Returns: Self
    @discardableResult
    internal func activate() -> Self {
        NSLayoutConstraint.activate(availableConstraints)
        return self
    }
    
    /// Deactivates all of the non-nil constraints
    ///
    /// - Returns: Self
    @discardableResult
    internal func deactivate() -> Self {
        NSLayoutConstraint.deactivate(availableConstraints)
        return self
    }
}
