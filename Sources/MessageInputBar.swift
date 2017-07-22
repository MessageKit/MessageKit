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

open class MessageInputBar: UIView {
    
    // MARK: - Properties
    
    let inputTextView: UITextView = {
    
        let inputTextView = UITextView(frame: .zero)
        inputTextView.text = "Some example text for testing"
        inputTextView.backgroundColor = .white
        return inputTextView
    }()
    
    let sendButton: UIButton = {
    
        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.lightGray, for: .normal)
        sendButton.backgroundColor = .red
        return sendButton
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        
        addSubview(inputTextView)
        addSubview(sendButton)
        
    }
    
    func setupConstraints() {

        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -4))
        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .trailing, relatedBy: .equal, toItem: sendButton, attribute: .leading, multiplier: 1, constant: -4))

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: sendButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))

    }


}
