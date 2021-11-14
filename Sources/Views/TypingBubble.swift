/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
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

/// A subclass of `UIView` that mimics the iMessage typing bubble
open class TypingBubble: UIView {
    
    // MARK: - Properties
    
    open var isPulseEnabled: Bool = true
    
    public private(set) var isAnimating: Bool = false
    
    open override var backgroundColor: UIColor? {
        set {
            [contentBubble, cornerBubble, tinyBubble].forEach { $0.backgroundColor = newValue }
        }
        get {
            return contentBubble.backgroundColor
        }
    }
    
    private struct AnimationKeys {
        static let pulse = "typingBubble.pulse"
    }
    
    // MARK: - Subviews
    
    /// The indicator used to display the typing animation.
    public let typingIndicator = TypingIndicator()
    
    public let contentBubble = UIView()
    
    public let cornerBubble = BubbleCircle()
    
    public let tinyBubble = BubbleCircle()
    
    // MARK: - Animation Layers
    
    open var contentPulseAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.04
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    open var circlePulseAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.1
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    open func setupSubviews() {
        addSubview(tinyBubble)
        addSubview(cornerBubble)
        addSubview(contentBubble)
        contentBubble.addSubview(typingIndicator)
        backgroundColor = .incomingMessageBackground
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // To maintain the iMessage like bubble the width:height ratio of the frame
        // must be close to 1.65
        
        //In order to prevent NaN crash when assigning the frame of the contentBubble
        guard bounds.width > 0,
              bounds.height > 0
        else { return}
        
        let ratio = bounds.width / bounds.height
        let extraRightInset = bounds.width - 1.65/ratio*bounds.width
        
        let tinyBubbleRadius: CGFloat = bounds.height / 6
        tinyBubble.frame = CGRect(x: 0,
                                  y: bounds.height - tinyBubbleRadius,
                                  width: tinyBubbleRadius,
                                  height: tinyBubbleRadius)
        
        let cornerBubbleRadius = tinyBubbleRadius * 2
        let offset: CGFloat = tinyBubbleRadius / 6
        cornerBubble.frame = CGRect(x: tinyBubbleRadius - offset,
                                    y: bounds.height - (1.5 * cornerBubbleRadius) + offset,
                                    width: cornerBubbleRadius,
                                    height: cornerBubbleRadius)
        
        let contentBubbleFrame = CGRect(x: tinyBubbleRadius + offset,
                              y: 0,
                              width: bounds.width - (tinyBubbleRadius + offset) - extraRightInset,
                              height: bounds.height - (tinyBubbleRadius + offset))
        let contentBubbleFrameCornerRadius = contentBubbleFrame.height / 2
        
        contentBubble.frame = contentBubbleFrame
        contentBubble.layer.cornerRadius = contentBubbleFrameCornerRadius
            
        let insets = UIEdgeInsets(top: offset, left: contentBubbleFrameCornerRadius / 1.25, bottom: offset, right: contentBubbleFrameCornerRadius / 1.25)
        typingIndicator.frame = contentBubble.bounds.inset(by: insets)
    }
    
    // MARK: - Animation API
    
    open func startAnimating() {
        defer { isAnimating = true }
        guard !isAnimating else { return }
        typingIndicator.startAnimating()
        if isPulseEnabled {
            contentBubble.layer.add(contentPulseAnimationLayer, forKey: AnimationKeys.pulse)
            [cornerBubble, tinyBubble].forEach { $0.layer.add(circlePulseAnimationLayer, forKey: AnimationKeys.pulse) }
        }
    }
    
    open func stopAnimating() {
        defer { isAnimating = false }
        guard isAnimating else { return }
        typingIndicator.stopAnimating()
        [contentBubble, cornerBubble, tinyBubble].forEach { $0.layer.removeAnimation(forKey: AnimationKeys.pulse) }
    }
    
}
