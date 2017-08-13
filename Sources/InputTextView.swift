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

    open var placeholder: NSString? {
        didSet {
            guard placeholder != oldValue else { return }
            setNeedsDisplay()
        }
    }

    open var placeholderTextColor: UIColor = .lightGray {
        didSet {
            guard placeholderTextColor != oldValue else { return }
            setNeedsDisplay()
        }
    }

    open var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 7,
                                                            left: 5,
                                                            bottom: 7,
                                                            right: 5) {
        didSet {
            guard placeholderInsets != oldValue else { return }
            setNeedsDisplay()
        }
    }

    private var isPlaceholderVisibile = false

    // MARK: - Initializers

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addObservers()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        guard text.isEmpty, let placeholder = placeholder else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        var attributes: [String: Any] = [
            NSForegroundColorAttributeName: placeholderTextColor,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        if let font = font {
            attributes[NSFontAttributeName] = font
        }

        placeholder.draw(in: UIEdgeInsetsInsetRect(rect, placeholderInsets),
                         withAttributes: attributes)
        
        isPlaceholderVisibile = true

    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.orientationChanged(notification:)),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }

    func textDidChange(notification: Notification) {
        guard text.isEmpty || isPlaceholderVisibile else { return }
        setNeedsDisplay()
        isPlaceholderVisibile = false
    }
    
    func orientationChanged(notification: Notification) {
        setNeedsDisplay()
    }

}
