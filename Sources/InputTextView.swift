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

open class InputTextView: UITextView {

    // MARK: - Properties

    open let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "New Message"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var placeholderLabelConstraintSet: NSLayoutConstraintSet?

    open var placeholder: String? = "New Message" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    override open var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }

    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    open var placeholderLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 7, bottom: 4, right: 4) {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }

    public weak var messageInputBar: MessageInputBar?

    // MARK: - Initializers

    public convenience init() {
        self.init(frame: .zero)
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {

        font = UIFont.preferredFont(forTextStyle: .body)
        textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        isScrollEnabled = false
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.25
        layer.borderColor = UIColor.lightGray.cgColor

        addSubviews()
        addConstraints()
    }

    private func addSubviews() {

        addSubview(placeholderLabel)
    }

    private func addConstraints() {

        placeholderLabelConstraintSet = NSLayoutConstraintSet(
            top:    placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeholderLabelInsets.top),
            bottom: placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -placeholderLabelInsets.bottom),
            left:   placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: placeholderLabelInsets.left),
            right:  placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -placeholderLabelInsets.right)
            ).activate()
    }

    private func updateConstraintsForPlaceholderLabel() {

        placeholderLabelConstraintSet?.top?.constant = placeholderLabelInsets.top
        placeholderLabelConstraintSet?.bottom?.constant = -placeholderLabelInsets.bottom
        placeholderLabelConstraintSet?.left?.constant = placeholderLabelInsets.left
        placeholderLabelConstraintSet?.right?.constant = -placeholderLabelInsets.bottom
    }

}
