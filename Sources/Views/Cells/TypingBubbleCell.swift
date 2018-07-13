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

/// A subclass of `MessageCollectionViewCell` used to display the typing indicator.
open class TypingBubbleCell: MessageCollectionViewCell {
    
    // MARK: - Properties
    
    /// The container used for styling and holding the message's content view.
    open var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    open var isPulseEnabled: Bool = true
    
    public private(set) var isAnimating: Bool = false
    
    private struct AnimationKeys {
        static let pulse = "typingBubble.pulse"
    }
    
    /// The indicator used to display the typing animation.
    open let typingIndicator = TypingIndicator()
    
    open let cornerBubble: Circle = {
        let view = Circle()
        return view
    }()
    
    open let tinyBubble: Circle = {
        let view = Circle()
        return view
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
    
    open func setupSubviews() {
        contentView.addSubview(tinyBubble)
        contentView.addSubview(cornerBubble)
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(typingIndicator)
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(typingIndicator)
    }
    
    // MARK: - Configuration
    
    /// Used to configure the cell.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` for this cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell is contained.
    open func configure(at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        
        let messageColor = displayDelegate.backgroundColorForTypingBubble(at: indexPath, in: messagesCollectionView)
        messageContainerView.backgroundColor = messageColor
        tinyBubble.backgroundColor = messageColor
        cornerBubble.backgroundColor = messageColor
    }
    
    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return false
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // To maintain the iMessage like bubble the width:height ratio of the frame
        // must be close to 1.65
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
        
        let msgFrame = CGRect(x: tinyBubbleRadius + offset,
                              y: 0,
                              width: bounds.width - (tinyBubbleRadius + offset) - extraRightInset,
                              height: bounds.height - (tinyBubbleRadius + offset))
        let msgFrameCornerRadius = msgFrame.height / 2
        
        messageContainerView.frame = msgFrame
        messageContainerView.layer.cornerRadius = msgFrameCornerRadius
        
        
        let insets = UIEdgeInsets(top: offset, left: msgFrameCornerRadius / 1.5, bottom: offset, right: msgFrameCornerRadius / 1.5)
        typingIndicator.frame = CGRect(x: insets.left,
                                       y: insets.top,
                                       width: msgFrame.width - insets.left - insets.right,
                                       height: msgFrame.height - insets.top - insets.bottom)
    }
    
    // MARK: - Animation Layers
    
    open func pulseAnimationLayer() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.05
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    // MARK: - Animation API
    
    open func startAnimating() {
        defer { isAnimating = true }
        guard !isAnimating else { return }
        typingIndicator.startAnimating()
        if isPulseEnabled {
            layer.add(pulseAnimationLayer(), forKey: AnimationKeys.pulse)
        }
    }
    
    open func stopAnimating() {
        defer { isAnimating = false }
        guard isAnimating else { return }
        typingIndicator.stopAnimating()
        layer.removeAnimation(forKey: AnimationKeys.pulse)
    }
    
}
