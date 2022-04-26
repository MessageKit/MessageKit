//
//  InputStackView.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 10/6/17.
//

import UIKit

/**
 A UIStackView that's intended for holding `InputItem`s
 
 ## Important Notes ##
 1. Default alignment is .fill
 2. Default distribution is .fill
 3. The distribution property needs to be based on its arranged subviews intrinsicContentSize so it is not recommended to change it
 */
open class InputStackView: UIStackView {
    
    /// The stack view position in the InputBarAccessoryView
    ///
    /// - left: Left Stack View
    /// - right: Bottom Stack View
    /// - bottom: Left Stack View
    /// - top: Top Stack View
    public enum Position {
        case left, right, bottom, top
    }
    
    // MARK: Initialization
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    
    /// Sets up the default properties
    open func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fill
        alignment = .bottom
    }
    
}
