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
    
    public enum UIStackViewPosition {
        case left, right, bottom, top
    }
    
    // MARK: - Properties
    
    open weak var delegate: MessageInputBarDelegate?
    
    /// The background UIView anchored to the bottom, left, and right of the MessageInputBar with a top anchor equal to the bottom of the top UIStackView
    open var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .inputBarGray
        return view
    }()
    
    /// A backgroundView subview that adds a blur effect. Only added to the view when 'isTransparent' is set to TRUE
    open var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// When set to true, the blurView is added to the backgroundView and anchored to all of its edges
    open var isTranslucent: Bool = false {
        didSet {
            if isTranslucent && blurView.superview == nil {
                backgroundView.addSubview(blurView)
                blurView.fillSuperview()
            }
            blurView.isHidden = !isTranslucent
            backgroundView.backgroundColor = isTranslucent ? .clear : .white
        }
    }

    open let separatorLine = SeparatorLine()
    
    open let topStackView = InputStackView(axis: .vertical, spacing: 0)
    
    open let leftStackView = InputStackView(axis: .horizontal, spacing: 0)
    
    open let rightStackView = InputStackView(axis: .horizontal, spacing: 0)
    
    open let bottomStackView = InputStackView(axis: .horizontal, spacing: 15)
    
    open lazy var inputTextView: InputTextView = { [weak self] in
        let textView = InputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageInputBar = self
        return textView
    }()
    
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
    
    /// The anchor contants used by the UIStackViews and InputTextView to create padding within the MessageInputBar
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12) {
        didSet {
            updatePadding()
        }
    }
    
    /// Changes the padding insets on the top UIStackView's top, left and right constraint anchors
    open var topStackViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            updateTopStackViewPadding()
        }
    }
    
    /// Changes the padding insets on the UITextView's left, right and bottom constraint anchors
    open var textViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4) {
        didSet {
            updateTextViewPadding()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let size = calculateIntrinsicContentSize()
        if previousIntrinsicContentSize != size {
            delegate?.messageInputBar(self, didChangeIntrinsicContentTo: size)
        }
        previousIntrinsicContentSize = size
        return size
    }
    
    private var previousIntrinsicContentSize: CGSize?
    
    private(set) var isOverMaxTextViewHeight = false
    
    /// The maximum height of content not including the topStackView. When reached the delegate 'didChangeIntrinsicContentTo' will be called.
    open var maxTextViewHeight: CGFloat = (UIScreen.main.bounds.height / 4).rounded() {
        didSet {
            textViewHeightAnchor?.constant = maxTextViewHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    /// The fixed widthAnchor constant of the leftStackView
    private(set) var leftStackViewWidthConstant: CGFloat = 0 {
        didSet {
            leftStackViewLayoutSet?.width?.constant = leftStackViewWidthConstant
        }
    }
    
    /// The fixed widthAnchor constant of the rightStackView
    private(set) var rightStackViewWidthConstant: CGFloat = 52 {
        didSet {
            rightStackViewLayoutSet?.width?.constant = rightStackViewWidthConstant
        }
    }

    /// The InputBarItems held in the leftStackView
    private(set) var leftStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the rightStackView
    private(set) var rightStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the bottomStackView
    private(set) var bottomStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the topStackView
    private(set) var topStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held to make use of their hooks but they are not automatically added to a UIStackView
    open var nonStackViewItems: [InputBarButtonItem] = []
    
    /// Returns a flatMap of all the items in each of the UIStackViews
    public var items: [InputBarButtonItem] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems, topStackViewItems, nonStackViewItems].flatMap { $0 }
    }

    // MARK: - Auto-Layout Constraints
    
    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
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
    
    open func setup() {
        tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        backgroundColor = .clear
        autoresizingMask = [.flexibleHeight, .flexibleBottomMargin]
        setupSubviews()
        setupConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.orientationDidChange),
                                               name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.textViewDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.textViewDidBeginEditing),
                                               name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MessageInputBar.textViewDidEndEditing),
                                               name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
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
    
    private func setupConstraints() {
        
        topStackViewLayoutSet = NSLayoutConstraintSet(
            top:    topStackView.topAnchor.constraint(equalTo: topAnchor, constant: topStackViewPadding.top),
            bottom: topStackView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -padding.top),
            left:   topStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: topStackViewPadding.left),
            right:  topStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -topStackViewPadding.right)
        ).activate()
        
        backgroundView.addConstraints(topStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    inputTextView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: padding.top),
            bottom: inputTextView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -textViewPadding.bottom),
            left:   inputTextView.leftAnchor.constraint(equalTo: leftStackView.rightAnchor, constant: textViewPadding.left),
            right:  inputTextView.rightAnchor.constraint(equalTo: rightStackView.leftAnchor, constant: -textViewPadding.right)
        ).activate()
        textViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxTextViewHeight)
        
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
            top:    bottomStackView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: textViewPadding.bottom),
            bottom: bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   bottomStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  bottomStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
        ).activate()
    }
    
    // MARK: - Constraint Layout Updates
    
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
    
    private func updateTextViewPadding() {
        textViewLayoutSet?.left?.constant = textViewPadding.left
        textViewLayoutSet?.right?.constant = -textViewPadding.right
        textViewLayoutSet?.bottom?.constant = -textViewPadding.bottom
        bottomStackViewLayoutSet?.top?.constant = textViewPadding.bottom
    }
    
    private func updateTopStackViewPadding() {
        topStackViewLayoutSet?.top?.constant = topStackViewPadding.top
        topStackViewLayoutSet?.left?.constant = topStackViewPadding.left
        topStackViewLayoutSet?.right?.constant = -topStackViewPadding.right
    }
    
    open func calculateIntrinsicContentSize() -> CGSize {
        
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        var heightToFit = inputTextView.sizeThatFits(maxTextViewSize).height.rounded()
        if heightToFit >= maxTextViewHeight {
            if !isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = true
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            heightToFit = maxTextViewHeight
        } else {
            if isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = false
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
            }
            inputTextView.invalidateIntrinsicContentSize()
        }
        return CGSize(width: bounds.width, height: heightToFit)
    }
    
    // MARK: - Layout Helper Methods
    
    /// Layout the given UIStackView's
    ///
    /// - Parameter positions: The UIStackView's to layout
    public func layoutStackViews(_ positions: [UIStackViewPosition] = [.left, .right, .bottom]) {
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
    
    /// Performs layout changes over the main thread
    ///
    /// - Parameters:
    ///   - animated: If the layout should be animated
    ///   - animations: Code
    internal func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
        
        topStackViewLayoutSet?.deactivate()
        textViewLayoutSet?.deactivate()
        leftStackViewLayoutSet?.deactivate()
        rightStackViewLayoutSet?.deactivate()
        bottomStackViewLayoutSet?.deactivate()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
        } else {
            UIView.performWithoutAnimation { animations() }
        }
        topStackViewLayoutSet?.activate()
        textViewLayoutSet?.activate()
        leftStackViewLayoutSet?.activate()
        rightStackViewLayoutSet?.activate()
        bottomStackViewLayoutSet?.activate()
    }
    
    // MARK: - UIStackView InputBarButtonItem Methods
    
    /// Removes all of the arranged subviews from the UIStackView and adds the given items. Sets the messageInputBar property of the InputBarButtonItem
    ///
    /// - Parameters:
    ///   - items: New UIStackView arranged views
    ///   - position: The targeted UIStackView
    ///   - animated: If the layout should be animated
    open func setStackViewItems(_ items: [InputBarButtonItem], forStack position: UIStackViewPosition, animated: Bool) {
        
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
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    rightStackView.addArrangedSubview($0)
                }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    bottomStackView.addArrangedSubview($0)
                }
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                topStackViewItems = items
                topStackViewItems.forEach {
                    $0.messageInputBar = self
                    $0.parentStackViewPosition = position
                    topStackView.addArrangedSubview($0)
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
    
    @objc
    open func orientationDidChange() {
        invalidateIntrinsicContentSize()
    }
    
    @objc
    open func textViewDidChange() {
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !inputTextView.text.isEmpty
        items.forEach { $0.textViewDidChangeAction(with: self.inputTextView) }
        delegate?.messageInputBar(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    @objc
    open func textViewDidBeginEditing() {
        items.forEach { $0.keyboardEditingBeginsAction() }
    }
    
    @objc
    open func textViewDidEndEditing() {
        items.forEach { $0.keyboardEditingEndsAction() }
    }
    
    // MARK: - User Actions
    
    open func didSelectSendButton() {
        delegate?.messageInputBar(self, didPressSendButtonWith: inputTextView.text)
        textViewDidChange()
    }
}
