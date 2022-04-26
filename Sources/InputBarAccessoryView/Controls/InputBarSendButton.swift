//
//  InputBarSendButton.swift
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
//  Created by Nathan Tannar on 8/18/17.
//

import UIKit

open class InputBarSendButton: InputBarButtonItem {

    /// A flag indicating the animation state of the `InputBarSendButton`
    open private(set) var isAnimating: Bool = false

    /// Accessor to modify the color of the activity view
    open var activityViewColor: UIColor! {
        get {
            return activityView.color
        }
        set {
            activityView.color = newValue
        }
    }

    private let activityView: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .medium)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }
        
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSendButton()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSendButton()
    }

    private func setupSendButton() {
        addSubview(activityView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        activityView.frame = bounds
    }

    /// Starts the animation of the activity view, hiding other elements
    open func startAnimating() {
        guard !isAnimating else { return }
        defer { isAnimating = true }
        activityView.startAnimating()
        activityView.isHidden = false
        // Setting isHidden doesn't hide the elements
        titleLabel?.alpha = 0
        imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
    }

    /// Stops the animation of the activity view, shows other elements
    open func stopAnimating() {
        guard isAnimating else { return }
        defer { isAnimating = false }
        activityView.stopAnimating()
        activityView.isHidden = true
        titleLabel?.alpha = 1
        imageView?.layer.transform = CATransform3DIdentity
    }

}
