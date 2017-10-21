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

/// A powerful InputAccessoryView ideal for messaging applications
open class MessageInputBar: UIView {
    
    // MARK: - Properties
    
    /// A delegate to broadcast notifications from the MessageInputBar
    open weak var delegate: MessageInputBarDelegate?
    
    /// The background UIView anchored to the bottom, left, and right of the MessageInputBar
    /// with a top anchor equal to the bottom of the top InputStackView
    open var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .inputBarGray
        return view
    }()
    
    /// Also sets the backgroundView's backgroundColor to the newValue
    open override var backgroundColor: UIColor? {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    
    /**
     A UIVisualEffectView that adds a blur effect to make the view appear transparent.
     
     ## Important Notes ##
     1. The blurView is initially not added to the backgroundView to improve performance when not needed. When `isTranslucent` is set to TRUE for the first time the blurView is added and anchored to the `backgroundView`s edge anchors
    */
    open var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Determines if the MessageInputBar should have a translucent effect
    open var isTranslucent: Bool = false {
        didSet {
            if isTranslucent && blurView.superview == nil {
                backgroundView.addSubview(blurView)
                blurView.fillSuperview()
            }
            blurView.isHidden = !isTranslucent
            backgroundView.backgroundColor = isTranslucent ? (backgroundView.backgroundColor?.withAlphaComponent(0.7) ?? UIColor.white.withAlphaComponent(0.7)) : .white
        }
    }

    /// A SeparatorLine that is initially placed in the topStackView
    open let separatorLine = SeparatorLine()
    
    /**
     The InputStackView at the InputStackView.top position
     
     ## Important Notes ##
     1. It's axis is initially set to .vertical
     */
    open let topStackView = InputStackView(axis: .vertical, spacing: 0)
    
    /**
     The InputStackView at the InputStackView.left position
     
     ## Important Notes ##
     1. It's axis is initially set to .horizontal
     */
    open let leftStackView = InputStackView(axis: .horizontal, spacing: 0)
    
    /**
     The InputStackView at the InputStackView.right position
     
     ## Important Notes ##
     1. It's axis is initially set to .horizontal
     */
    open let rightStackView = InputStackView(axis: .horizontal, spacing: 0)
    
    /**
     The InputStackView at the InputStackView.bottom position
     
     ## Important Notes ##
     1. It's axis is initially set to .horizontal
     2. It's spacing is initially set to 15
     */
    open let bottomStackView = InputStackView(axis: .horizontal, spacing: 15)
    
    open lazy var inputTextView: InputTextView = { [weak self] in
        let inputTextView = InputTextView()
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.messageInputBar = self
        return inputTextView
    }()
    
    /// A InputBarButtonItem used as the send button and initially placed in the rightStackView
    open var sendButton: InputBarButtonItem = {
        return InputBarButtonItem()
            .configure {
                $0.setSize(CGSize(width: 52, height: 30), animated: false)
                $0.isEnabled = false
                $0.title = "Send"
                $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            }.onTouchUpInside {
                $0.messageInputBar?.didSelectSendButton()
        }
    }()
    
    /**
     The anchor contants used by the InputStackView's and InputTextView to create padding
     within the MessageInputBar
     
     ## Important Notes ##
     
     ````
     V:|...-[InputStackView.top]-(padding.top)-[InputTextView]-(textViewPadding.bottom)-[InputStackView.bottom]-(padding.bottom)-|
     
     H:|-(padding.left)-[InputStackView.left(leftStackViewWidthConstant)]-(textViewPadding.left)-[InputTextView]-(textViewPadding.right)-[InputStackView.right(rightStackViewWidthConstant)]-(padding.right)-|
     ````
     
     */
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12) {
        didSet {
            updatePadding()
        }
    }
    
    /**
     The anchor constants used by the top InputStackView
     
     ## Important Notes ##
     1. The topStackViewPadding.bottom property is not used. Use padding.top
     
     ````
     V:|-(topStackViewPadding.top)-[InputStackView.top]-(padding.top)-[InputTextView]-...|
     
     H:|-(topStackViewPadding.left)-[InputStackView.top]-(topStackViewPadding.right)-|
     ````
     
     */
    open var topStackViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            updateTopStackViewPadding()
        }
    }
    
    /**
     The anchor constants used by the InputStackView
     
     ## Important Notes ##
     1. The inputTextViewPadding.top property is not used. Use padding.top
     
     ````
     V:|...-(padding.top)-[InputTextView]-(inputTextViewPadding.bottom)-[InputStackView.bottom]-...|
     
     H:|...-[InputStackView.left]-(inputTextViewPadding.left)-[InputTextView]-(inputTextViewPadding.left)-[InputStackView.left.right]-...|
     ````
     
     */
    open var inputTextViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            updateTextViewPadding()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = calculateIntrinsicContentSize()
        if previousIntrinsicContentSize != size {
            delegate?.messageInputBar(self, didChangeIntrinsicContentTo: size)
        }
        previousIntrinsicContentSize = size
        return size
    }
    
    /// The intrinsicContentSize can change a lot so the delegate method
    /// `inputBar(self, didChangeIntrinsicContentTo: size)` only needs to be called
    /// when it's different
    private var previousIntrinsicContentSize: CGSize?
    
    /// A boolean that indicates if the maxTextViewHeight has been met. Keeping track of this
    /// improves the performance
    private(set) public var isOverMaxTextViewHeight = false
    
    /// The maximum height that the InputTextView can reach
    open var maxTextViewHeight: CGFloat = (UIScreen.main.bounds.height / 4).rounded() {
        didSet {
            inputTextViewHeightAnchor?.constant = maxTextViewHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    /// The fixed widthAnchor constant of the leftStackView
    private(set) public var leftStackViewWidthConstant: CGFloat = 0 {
        didSet {
            leftStackViewLayoutSet?.width?.constant = leftStackViewWidthConstant
        }
    }
    
    /// The fixed widthAnchor constant of the rightStackView
    private(set) public var rightStackViewWidthConstant: CGFloat = 52 {
        didSet {
            rightStackViewLayoutSet?.width?.constant = rightStackViewWidthConstant
        }
    }
    
    /// Holds the InputManager plugins that can be used to extend the functionality of the MessageInputBar
    open var inputManagers = [InputManager]()

    /// The InputBarItems held in the leftStackView
    private(set) public var leftStackViewItems: [InputItem] = []
    
    /// The InputBarItems held in the rightStackView
    private(set) public var rightStackViewItems: [InputItem] = []
    
    /// The InputBarItems held in the bottomStackView
    private(set) public var bottomStackViewItems: [InputItem] = []
    
    /// The InputBarItems held in the topStackView
    private(set) public var topStackViewItems: [InputItem] = []
    
    /// The InputBarItems held to make use of their hooks but they are not automatically added to a UIStackView
    open var nonStackViewItems: [InputItem] = []
    
    /// Returns a flatMap of all the items in each of the UIStackViews
    public var items: [InputItem] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems, topStackViewItems, nonStackViewItems].flatMap { $0 }
    }

    // MARK: - Auto-Layout Constraint Sets
    
    private var inputTextViewLayoutSet: NSLayoutConstraintSet?
    private var inputTextViewHeightAnchor: NSLayoutConstraint?
    private var topStackViewHeightAnchor: NSLayoutConstraint?
    private var topStackViewLayoutSet: NSLayoutConstraintSet?
    private var leftStackViewLayoutSet: NSLayoutConstraintSet?
    private var rightStackViewLayoutSet: NSLayoutConstraintSet?
    private var bottomStackViewLayoutSet: NSLayoutConstraintSet?
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        autoresizingMask = [.flexibleHeight]
        setupSubviews()
        setupConstraints()
        setupObservers()
    }
    
    /// Adds the required notification observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.orientationDidChange),
                                               name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.inputTextViewDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.inputTextViewDidBeginEditing),
                                               name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.inputTextViewDidEndEditing),
                                               name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    /// Adds all of the subviews
    private func setupSubviews() {
        addSubview(backgroundView)
        addSubview(topStackView)
        addSubview(inputTextView)
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(bottomStackView)
        topStackView.addArrangedSubview(separatorLine)
        setStackViewItems([sendButton], forStack: .right, animated: false)
    }
    
    /// Sets up the initial constraints of each subview
    private func setupConstraints() {
        
        topStackViewLayoutSet = NSLayoutConstraintSet(
            top:    topStackView.topAnchor.constraint(equalTo: topAnchor, constant: topStackViewPadding.top),
            bottom: topStackView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -padding.top),
            left:   topStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: topStackViewPadding.left),
            right:  topStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -topStackViewPadding.right)
        ).activate()
        
        backgroundView.addConstraints(topStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        inputTextViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: padding.top),
            bottom: inputTextView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -inputTextViewPadding.bottom),
            left:   inputTextView.leftAnchor.constraint(equalTo: leftStackView.rightAnchor, constant: inputTextViewPadding.left),
            right:  inputTextView.rightAnchor.constraint(equalTo: rightStackView.leftAnchor, constant: -inputTextViewPadding.right)
        ).activate()
        inputTextViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxTextViewHeight)
        
        leftStackViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: padding.top),
            bottom: leftStackView.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 0),
            left:   leftStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            width:  leftStackView.widthAnchor.constraint(equalToConstant: leftStackViewWidthConstant)
        ).activate()
        
        rightStackViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: padding.top),
            bottom: rightStackView.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 0),
            right:  rightStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            width:  rightStackView.widthAnchor.constraint(equalToConstant: rightStackViewWidthConstant)
        ).activate()
        
        bottomStackViewLayoutSet = NSLayoutConstraintSet(
            top:    bottomStackView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: inputTextViewPadding.bottom),
            bottom: bottomStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -padding.bottom),
            left:   bottomStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  bottomStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
        ).activate()
    }
    
    // MARK: - Constraint Layout Updates
    
    /// Updates the constraint constants that correspond to the padding UIEdgeInsets
    private func updatePadding() {
        inputTextViewLayoutSet?.top?.constant = padding.top
        leftStackViewLayoutSet?.top?.constant = padding.top
        leftStackViewLayoutSet?.left?.constant = padding.left
        rightStackViewLayoutSet?.top?.constant = padding.top
        rightStackViewLayoutSet?.right?.constant = -padding.right
        bottomStackViewLayoutSet?.left?.constant = padding.left
        bottomStackViewLayoutSet?.right?.constant = -padding.right
        bottomStackViewLayoutSet?.bottom?.constant = -padding.bottom
    }
    
    /// Updates the constraint constants that correspond to the inputTextViewPadding UIEdgeInsets
    private func updateTextViewPadding() {
        inputTextViewLayoutSet?.left?.constant = inputTextViewPadding.left
        inputTextViewLayoutSet?.right?.constant = -inputTextViewPadding.right
        inputTextViewLayoutSet?.bottom?.constant = -inputTextViewPadding.bottom
        bottomStackViewLayoutSet?.top?.constant = inputTextViewPadding.bottom
    }
    
    /// Updates the constraint constants that correspond to the topStackViewPadding UIEdgeInsets
    private func updateTopStackViewPadding() {
        topStackViewLayoutSet?.top?.constant = topStackViewPadding.top
        topStackViewLayoutSet?.left?.constant = topStackViewPadding.left
        topStackViewLayoutSet?.right?.constant = -topStackViewPadding.right
    }
    
    /// Calculates the correct intrinsicContentSize of the MessageInputBar
    ///
    /// - Returns: The required intrinsicContentSize
    open func calculateIntrinsicContentSize() -> CGSize {
        
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        var heightToFit = inputTextView.sizeThatFits(maxTextViewSize).height.rounded()
        if heightToFit >= maxTextViewHeight {
            if !isOverMaxTextViewHeight {
                inputTextViewHeightAnchor?.isActive = true
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            heightToFit = maxTextViewHeight
        } else {
            if isOverMaxTextViewHeight {
                inputTextViewHeightAnchor?.isActive = false
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
            }
            inputTextView.invalidateIntrinsicContentSize()
        }
        return CGSize(width: bounds.width, height: heightToFit)
    }
    
    // MARK: - Layout Helper Methods
    
    /// Layout the given InputStackView's
    ///
    /// - Parameter positions: The InputStackView's to layout
    public func layoutStackViews(_ positions: [InputStackView.Position] = [.left, .right, .bottom]) {
        for position in positions {
            switch position {
            case .left:
                leftStackView.setNeedsLayout()
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.setNeedsLayout()
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.setNeedsLayout()
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.setNeedsLayout()
                topStackView.layoutIfNeeded()
            }
        }
    }
    
    /// Performs a layout over the main thread
    ///
    /// - Parameters:
    ///   - animated: If the layout should be animated
    ///   - animations: Animation logic
    internal func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
        defer {
            inputTextViewLayoutSet?.activate()
            leftStackViewLayoutSet?.activate()
            rightStackViewLayoutSet?.activate()
            bottomStackViewLayoutSet?.activate()
        }
        inputTextViewLayoutSet?.deactivate()
        leftStackViewLayoutSet?.deactivate()
        rightStackViewLayoutSet?.deactivate()
        bottomStackViewLayoutSet?.deactivate()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
            
        } else {
            animations()
        }
    }
    
    /// Removes all of the arranged subviews from the InputStackView and adds the given items.
    /// Sets the messageInputBar property of the InputBarButtonItem
    ///
    /// - Parameters:
    ///   - items: New InputStackView arranged views
    ///   - position: The targeted InputStackView
    ///   - animated: If the layout should be animated
    open func setStackViewItems(_ items: [InputItem], forStack position: InputStackView.Position, animated: Bool) {
        
        func setNewItems() {
            switch position {
            case .left:
                leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                leftStackViewItems = items
                leftStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        leftStackView.addArrangedSubview(view)
                    }
                }
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        rightStackView.addArrangedSubview(view)
                    }
                }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        bottomStackView.addArrangedSubview(view)
                    }
                }
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                topStackViewItems = items
                topStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        topStackView.addArrangedSubview(view)
                    }
                }
                topStackView.layoutIfNeeded()
            }
        }
        
        performLayout(animated) {
            setNewItems()
        }
    }
    
    /// Sets the leftStackViewWidthConstant
    ///
    /// - Parameters:
    ///   - newValue: New widthAnchor constant
    ///   - animated: If the layout should be animated
    open func setLeftStackViewWidthConstant(to newValue: CGFloat, animated: Bool) {
        performLayout(animated) { 
            self.leftStackViewWidthConstant = newValue
            self.layoutStackViews([.left])
            self.layoutIfNeeded()
        }
    }
    
    /// Sets the rightStackViewWidthConstant
    ///
    /// - Parameters:
    ///   - newValue: New widthAnchor constant
    ///   - animated: If the layout should be animated
    open func setRightStackViewWidthConstant(to newValue: CGFloat, animated: Bool) {
        performLayout(animated) { 
            self.rightStackViewWidthConstant = newValue
            self.layoutStackViews([.right])
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Notifications/Hooks
    
    /// Invalidates the intrinsicContentSize
    @objc
    open func orientationDidChange() {
        invalidateIntrinsicContentSize()
    }

    /// Enables/Disables the sendButton based on the InputTextView's text being empty
    /// Calls each items `textViewDidChangeAction` method
    /// Calls the delegates `textViewTextDidChangeTo` method
    /// Invalidates the intrinsicContentSize
    @objc
    open func inputTextViewDidChange() {
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !inputTextView.text.isEmpty
        items.forEach { $0.textViewDidChangeAction(with: self.inputTextView) }
        delegate?.messageInputBar(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    /// Calls each items `keyboardEditingBeginsAction` method
    @objc
    open func inputTextViewDidBeginEditing() {
        items.forEach { $0.keyboardEditingBeginsAction() }
    }
    
    /// Calls each items `keyboardEditingEndsAction` method
    @objc
    open func inputTextViewDidEndEditing() {
        items.forEach { $0.keyboardEditingEndsAction() }
    }
    
    // MARK: - User Actions
    
    /// Calls the delegates `didPressSendButtonWith` method
    /// Assumes that the InputTextView's text has been set to empty and calls `inputTextViewDidChange()`
    /// Invalidates each of the inputManagers
    open func didSelectSendButton() {
        delegate?.messageInputBar(self, didPressSendButtonWith: inputTextView.text)
        inputTextViewDidChange()
        inputManagers.forEach { $0.invalidate() }
    }
}
