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
    
    public enum UIStackViewPosition {
        case left, right, bottom
    }
    
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
            let color: UIColor = backgroundView.backgroundColor ?? .inputBarGray
            backgroundView.backgroundColor = isTranslucent ? color.withAlphaComponent(0.75) : color.withAlphaComponent(1.0)
        }
    }
    
    /// A SeparatorLine that is initially placed in the topStackView
    open let separatorLine = SeparatorLine()
    
    /**
     The InputStackView at the InputStackView.top position
     
     ## Important Notes ##
     1. It's axis is initially set to .vertical
     2. It's alignment is initially set to .fill
     */
    open let topStackView: InputStackView = {
        let stackView = InputStackView(axis: .vertical, spacing: 0)
        stackView.alignment = .fill
        return stackView
    }()
    
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
    
    /// The InputTextView a user can input a message in
    open lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageInputBar = self
        return textView
    }()

    /// A InputBarButtonItem used as the send button and initially placed in the rightStackView
    open var sendButton: InputBarButtonItem = {
        return InputBarButtonItem()
            .configure {
                $0.setSize(CGSize(width: 52, height: 28), animated: false)
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
    open var textViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) {
        didSet {
            updateTextViewPadding()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = calculateIntrinsicContentSize()
        if previousIntrinsicContentSize != size {
            delegate?.messageInputBar(self, didChangeIntrinsicContentTo: size)
            previousIntrinsicContentSize = size
        }
        return size
    }
    
    /// The intrinsicContentSize can change a lot so the delegate method
    /// `inputBar(self, didChangeIntrinsicContentTo: size)` only needs to be called
    /// when it's different
    public private(set) var previousIntrinsicContentSize: CGSize?
    
    /// A boolean that indicates if the maxTextViewHeight has been met. Keeping track of this
    /// improves the performance
    public private(set) var isOverMaxTextViewHeight = false
    
    /// The maximum height that the InputTextView can reach
    open var maxHeight: CGFloat = UIScreen.main.bounds.height / 3 {
        didSet {
            textViewHeightAnchor?.constant = maxHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    private var inputBarMinusTextViewHeight: CGFloat {
        return topStackViewPadding.top + padding.top + textViewPadding.bottom + padding.bottom + topStackView.bounds.height + bottomStackView.bounds.height
    }
    
    /// The fixed widthAnchor constant of the leftStackView
    public private(set) var leftStackViewWidthConstant: CGFloat = 0 {
        didSet {
            leftStackViewLayoutSet?.width?.constant = leftStackViewWidthConstant
        }
    }
    
    /// The fixed widthAnchor constant of the rightStackView
    public private(set) var rightStackViewWidthConstant: CGFloat = 52 {
        didSet {
            rightStackViewLayoutSet?.width?.constant = rightStackViewWidthConstant
        }
    }
    
    /// The InputBarItems held in the leftStackView
    public private(set) var leftStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the rightStackView
    public private(set) var rightStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the bottomStackView
    public private(set) var bottomStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the topStackView
    public private(set) var topStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held to make use of their hooks but they are not automatically added to a UIStackView
    open var nonStackViewItems: [InputBarButtonItem] = []
    
    /// Returns a flatMap of all the items in each of the UIStackViews
    public var items: [InputBarButtonItem] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems, nonStackViewItems].flatMap { $0 }
    }
    
    // MARK: - Auto-Layout Management
    
    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
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
        
        autoresizingMask = [.flexibleHeight]
        setupSubviews()
        setupConstraints()
        setupObservers()
    }
    
    /// Adds all of the subviews
    private func setupSubviews() {
        
        addSubview(backgroundView)
        addSubview(topStackView)
        addSubview(inputTextView)
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(bottomStackView)
        addSubview(separatorLine)
        setStackViewItems([sendButton], forStack: .right, animated: false)
    }
    
    /// Sets up the initial constraints of each subview
    private func setupConstraints() {
        
        separatorLine.addConstraints(topAnchor, left: leftAnchor, right: rightAnchor, heightConstant: 1)
        topStackViewLayoutSet = NSLayoutConstraintSet(
            top:    topStackView.topAnchor.constraint(equalTo: topAnchor, constant: topStackViewPadding.top),
            bottom: topStackView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -padding.top),
            left:   topStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: topStackViewPadding.left),
            right:  topStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -topStackViewPadding.right)
        )
        backgroundView.addConstraints(topStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: padding.top),
            bottom: inputTextView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -textViewPadding.bottom),
            left:   inputTextView.leftAnchor.constraint(equalTo: leftStackView.rightAnchor, constant: textViewPadding.left),
            right:  inputTextView.rightAnchor.constraint(equalTo: rightStackView.leftAnchor, constant: -textViewPadding.right)
            ).activate()
        textViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxHeight)
        
        leftStackViewLayoutSet = NSLayoutConstraintSet(
            top:    leftStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom: leftStackView.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 0),
            left:   leftStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            width:  leftStackView.widthAnchor.constraint(equalToConstant: leftStackViewWidthConstant)
        )
        
        rightStackViewLayoutSet = NSLayoutConstraintSet(
            top:    rightStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom: rightStackView.bottomAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 0),
            right:  rightStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            width:  rightStackView.widthAnchor.constraint(equalToConstant: rightStackViewWidthConstant)
        )
        
        bottomStackViewLayoutSet = NSLayoutConstraintSet(
            top:    bottomStackView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor),
            bottom: bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   bottomStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  bottomStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
        )
        
        if #available(iOS 11.0, *) {
            // Switch to safeAreaLayoutGuide
            topStackViewLayoutSet?.left = topStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: topStackViewPadding.left)
            topStackViewLayoutSet?.right = topStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: topStackViewPadding.right)
            leftStackViewLayoutSet?.left = leftStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left)
            rightStackViewLayoutSet?.right = rightStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right)
            bottomStackViewLayoutSet?.left = bottomStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left)
            bottomStackViewLayoutSet?.right = bottomStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right)
        }
        topStackViewLayoutSet?.activate()
        leftStackViewLayoutSet?.activate()
        rightStackViewLayoutSet?.activate()
        bottomStackViewLayoutSet?.activate()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            guard let window = window else { return }
            
            // bottomAnchor must be set to the window to avoid a memory leak issue
            bottomStackViewLayoutSet?.bottom?.isActive = false
            bottomStackViewLayoutSet?.bottom = bottomStackView.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
            bottomStackViewLayoutSet?.bottom?.isActive = true
        }
    }
    
    private func updatePadding() {

        textViewLayoutSet?.top?.constant = padding.top
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
        textViewLayoutSet?.left?.constant = textViewPadding.left
        textViewLayoutSet?.right?.constant = -textViewPadding.right
        textViewLayoutSet?.bottom?.constant = -textViewPadding.bottom
        bottomStackViewLayoutSet?.top?.constant = textViewPadding.bottom
    }
    
    /// Updates the constraint constants that correspond to the topStackViewPadding UIEdgeInsets
    private func updateTopStackViewPadding() {
        topStackViewLayoutSet?.top?.constant = topStackViewPadding.top
        topStackViewLayoutSet?.left?.constant = topStackViewPadding.left
        topStackViewLayoutSet?.right?.constant = -topStackViewPadding.right
    }
    
    /// Adds the required notification observers
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.orientationDidChange),
                                               name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.textViewDidChange),
                                               name: .UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.textViewDidBeginEditing),
                                               name: .UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.textViewDidEndEditing),
                                               name: .UITextViewTextDidEndEditing, object: nil)
    }
    
    /// Calculates the correct intrinsicContentSize of the MessageInputBar
    ///
    /// - Returns: The required intrinsicContentSize
    open func calculateIntrinsicContentSize() -> CGSize {
        
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        let inputTextViewHeight = inputTextView.sizeThatFits(maxTextViewSize).height.rounded()
        var heightToFit: CGFloat = inputBarMinusTextViewHeight
        
        if inputTextViewHeight >= maxHeight {
            if !isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = true
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            heightToFit += maxHeight
        } else {
            if isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = false
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
                inputTextView.invalidateIntrinsicContentSize()
            }
            heightToFit += inputTextViewHeight
        }
        return CGSize(width: bounds.width, height: heightToFit)
    }
    
    // MARK: - Layout Helper Methods
    
    /// Layout the given UIStackView's
    ///
    /// - Parameter positions: The UIStackView's to layout
    public func layoutStackViews(_ positions: [InputStackView.Position] = [.left, .right, .bottom, .top]) {
        
        guard superview != nil else { return }
        
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
                bottomStackView.setNeedsLayout()
                bottomStackView.layoutIfNeeded()
            }
        }
    }
    
    /// Performs layout changes over the main thread
    ///
    /// - Parameters:
    ///   - animated: If the layout should be animated
    ///   - animations: Code
    internal func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
        
        textViewLayoutSet?.deactivate()
        leftStackViewLayoutSet?.deactivate()
        rightStackViewLayoutSet?.deactivate()
        bottomStackViewLayoutSet?.deactivate()
        topStackViewLayoutSet?.deactivate()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
        } else {
            UIView.performWithoutAnimation { animations() }
        }
        textViewLayoutSet?.activate()
        leftStackViewLayoutSet?.activate()
        rightStackViewLayoutSet?.activate()
        bottomStackViewLayoutSet?.activate()
        topStackViewLayoutSet?.activate()
    }
    
    // MARK: - UIStackView InputBarItem Methods
    
    /// Removes all of the arranged subviews from the UIStackView and adds the given items. Sets the messageInputBar property of the InputBarButtonItem
    ///
    /// - Parameters:
    ///   - items: New UIStackView arranged views
    ///   - position: The targeted UIStackView
    ///   - animated: If the layout should be animated
    open func setStackViewItems(_ items: [InputBarButtonItem], forStack position: InputStackView.Position, animated: Bool) {
        
        func setNewItems() {
            switch position {
            case .left:
                leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                leftStackViewItems = items
                leftStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    leftStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    rightStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    bottomStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                topStackViewItems = items
                topStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    topStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                topStackView.layoutIfNeeded()
            }
            invalidateIntrinsicContentSize()
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
            guard self.superview != nil else { return }
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
            guard self.superview != nil else { return }
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
    open func textViewDidChange() {
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        sendButton.isEnabled = !trimmedText.isEmpty
        inputTextView.placeholderLabel.isHidden = !inputTextView.text.isEmpty

        items.forEach { $0.textViewDidChangeAction(with: inputTextView) }

        delegate?.messageInputBar(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    /// Calls each items `keyboardEditingBeginsAction` method
    @objc
    open func textViewDidBeginEditing() {
        self.items.forEach { $0.keyboardEditingBeginsAction() }
    }
    
    /// Calls each items `keyboardEditingEndsAction` method
    @objc
    open func textViewDidEndEditing() {
        self.items.forEach { $0.keyboardEditingEndsAction() }
    }
    
    // MARK: - User Actions
    
    /// Calls the delegates `didPressSendButtonWith` method
    /// Assumes that the InputTextView's text has been set to empty and calls `inputTextViewDidChange()`
    /// Invalidates each of the inputManagers
    open func didSelectSendButton() {
        delegate?.messageInputBar(self, didPressSendButtonWith: inputTextView.text)
        textViewDidChange()
    }
}
