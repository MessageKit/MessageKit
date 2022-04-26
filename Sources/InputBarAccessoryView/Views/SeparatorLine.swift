//
//  SeparatorLine.swift
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
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

/**
 A UIView thats intrinsicContentSize is overrided so an exact height can be specified
 
 ## Important Notes ##
 1. Default height is 1 pixel
 2. Default backgroundColor is UIColor.lightGray
 3. Intended to be used in an `InputStackView`
 */
open class SeparatorLine: UIView {
    
    // MARK: - Properties
    
    /// The height of the line
  open var height: CGFloat = 1.0 / UIScreen.main.scale {
        didSet {
            constraints.filter { $0.identifier == "height" }.forEach { $0.constant = height } // Assumes constraint was given an identifier
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Sets up the default properties
    open func setup() {
        if #available(iOS 13, *) {
            backgroundColor = .systemGray2
        } else {
            backgroundColor = .lightGray
        }
        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
