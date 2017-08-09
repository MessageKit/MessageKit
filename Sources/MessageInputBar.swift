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

open class MessageInputBar: UIView, UITextViewDelegate {

    // MARK: - Properties

    open let inputTextView: UITextView = {

        let inputTextView = InputTextView(frame: .zero)
        inputTextView.font = UIFont.preferredFont(forTextStyle: .body)
        inputTextView.textColor = .black
        inputTextView.placeholder = "New Message"
        inputTextView.backgroundColor = .white
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 3.0
        inputTextView.layer.masksToBounds = true
        inputTextView.isScrollEnabled = false
        return inputTextView
    }()

    open let sendButton: UIButton = {

        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.sendButtonBlue, for: .normal)
        sendButton.setTitleColor(UIColor.sendButtonBlue.withAlphaComponent(0.3), for: .highlighted)
        sendButton.setTitleColor(.lightGray, for: .disabled)
        sendButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        sendButton.isEnabled = false

        return sendButton
    }()

    open weak var delegate: MessageInputBarDelegate?

    // MARK: - Initializers

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
        registerSelector()

        inputTextView.delegate = self

        backgroundColor = .inputBarGray

        autoresizingMask = .flexibleHeight

        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)

    }

    convenience public init() {
        self.init(frame: .zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    func orientationDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
    }

    public func textViewDidChange(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !trimmedText.isEmpty
        invalidateIntrinsicContentSize()
    }

    override open var intrinsicContentSize: CGSize {
        let sizeToFit = inputTextView.sizeThatFits(CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude))
        let heightToFit = sizeToFit.height.rounded() + 8 // constraint padding
        return CGSize(width: bounds.width, height: heightToFit)
    }

    private func setupSubviews() {

        addSubview(inputTextView)
        addSubview(sendButton)

    }

    private func setupConstraints() {

        inputTextView.translatesAutoresizingMaskIntoConstraints = false

        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 4))

        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .bottom, relatedBy: .equal,
                                         toItem: self, attribute: .bottom, multiplier: 1, constant: -4))

        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .leading, relatedBy: .equal,
                                         toItem: self, attribute: .leading, multiplier: 1, constant: 4))

        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .trailing, relatedBy: .equal,
                                         toItem: sendButton, attribute: .leading, multiplier: 1, constant: -4))

        sendButton.translatesAutoresizingMaskIntoConstraints = false

        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal,
                                         toItem: inputTextView, attribute: .bottom, multiplier: 1, constant: 0))

        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .trailing, relatedBy: .equal,
                                         toItem: self, attribute: .trailing, multiplier: 1, constant: -4))

        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .top, relatedBy: .greaterThanOrEqual,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 0))

        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal,
                                         toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))

    }

    private func registerSelector() {
        sendButton.addTarget(self, action: #selector(MessageInputBar.sendButtonPressed), for: .touchUpInside)
    }

    func sendButtonPressed() {
        delegate?.sendButtonPressed(sender: sendButton, textView: inputTextView)
    }
}
