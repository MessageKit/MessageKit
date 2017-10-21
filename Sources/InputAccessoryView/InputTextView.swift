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

import Foundation
import UIKit

/**
 A UITextView can has a UILabel embedded for placeholder text
 
 ## Important Notes ##
 1. Changing the font, textAlignment or textContainerInset automatically performs the same modifications to the placeholderLabel
 2. Intended to be used in an `MessageInputBar`
 3. Default placeholder text is "New Message"
 4. Will pass a pasted image it's `MessageInputBar`'s `InputManager`s
 */
open class InputTextView: UITextView {
    
    // MARK: - Properties
    
    open override var text: String! {
        didSet {
            textViewTextDidChange()
        }
    }
    
    open override var attributedText: NSAttributedString! {
        didSet {
            textViewTextDidChange()
        }
    }

    /// A UILabel that holds the InputTextView's placeholder text
    open let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "New Message"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The placeholder text that appears when there is no text
    open var placeholder: String? = "New Message" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    /// The placeholderLabel's textColor
    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    
    /// The UIEdgeInsets the placeholderLabel has within the InputTextView
    open var placeholderLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4) {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    /// The font of the InputTextView. When set the placeholderLabel's font is also updated
    open override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    /// The textAlignment of the InputTextView. When set the placeholderLabel's textAlignment is also updated
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    /// The textContainerInset of the InputTextView. When set the placeholderLabelInsets is also updated
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabelInsets = textContainerInset
        }
    }
    
    open override var scrollIndicatorInsets: UIEdgeInsets {
        didSet {
            // When .zero a rendering issue can occur
            if scrollIndicatorInsets == .zero {
                scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                                     left: .leastNonzeroMagnitude,
                                                     bottom: .leastNonzeroMagnitude,
                                                     right: .leastNonzeroMagnitude)
            }
        }
    }
    
    /// A weak reference to the MessageInputBar that the InputTextView is contained within
    open weak var messageInputBar: MessageInputBar?
    
    /// The constraints of the placeholderLabel
    private var placeholderLabelConstraintSet: NSLayoutConstraintSet?
 
    // MARK: - Initializers
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    /// Sets up the default properties
    open func setup() {
        
        backgroundColor = .white
        font = UIFont.preferredFont(forTextStyle: .body)
        isScrollEnabled = false
        textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        placeholderLabelInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4)
        scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                             left: .leastNonzeroMagnitude,
                                             bottom: .leastNonzeroMagnitude,
                                             right: .leastNonzeroMagnitude)
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.25
        layer.borderColor = UIColor.lightGray.cgColor
        addObservers()
        addPlaceholderLabel()
    }
    
    /// Adds the placeholderLabel to the view and sets up its initial constraints
    private func addPlaceholderLabel() {
        
        addSubview(placeholderLabel)
        placeholderLabelConstraintSet = NSLayoutConstraintSet(
            top:    placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeholderLabelInsets.top),
            bottom: placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -placeholderLabelInsets.bottom),
            left:   placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: placeholderLabelInsets.left),
            width:  placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -(placeholderLabelInsets.left + placeholderLabelInsets.right))
        ).activate()
    }
    
    /// Updates the placeholderLabels constraint constants to match the placeholderLabelInsets
    private func updateConstraintsForPlaceholderLabel() {
        
        placeholderLabelConstraintSet?.top?.constant = placeholderLabelInsets.top
        placeholderLabelConstraintSet?.bottom?.constant = -placeholderLabelInsets.bottom
        placeholderLabelConstraintSet?.left?.constant = placeholderLabelInsets.left
        placeholderLabelConstraintSet?.width?.constant = -(placeholderLabelInsets.left + placeholderLabelInsets.right)
    }
    
    /// Adds a notification for .UITextViewTextDidChange to detect when the placeholderLabel
    /// should be hidden or shown
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputTextView.textViewTextDidChange),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: nil)
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) && UIPasteboard.general.image != nil {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK: - Paste Support
    
    open override func paste(_ sender: Any?) {
        
        if let image = UIPasteboard.general.image {
            messageInputBar?.inputManagers.forEach { $0.handleInput(of: image) }
        } else {
            super.paste(sender)
        }
    }
    
    // MARK: - Notifications
    
    /// Updates the placeholderLabel's isHidden property based on the text being empty or not
    @objc
    open func textViewTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
