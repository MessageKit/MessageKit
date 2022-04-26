//
//  InputBarAccessoryView.swift
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

/// A powerful InputAccessoryView ideal for messaging applications
open class InputBarAccessoryView: UIView {
    
    // MARK: - Properties
    
    /// A delegate to broadcast notifications from the `InputBarAccessoryView`
    open weak var delegate: InputBarAccessoryViewDelegate?
    
    /// The background UIView anchored to the bottom, left, and right of the InputBarAccessoryView
    /// with a top anchor equal to the bottom of the top InputStackView
    open var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = InputBarAccessoryView.defaultBackgroundColor
        return view
    }()
    
    /// A content UIView that holds the left/right/bottom InputStackViews
    /// and the middleContentView. Anchored to the bottom of the
    /// topStackView and inset by the padding UIEdgeInsets
    open var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /**
     A UIVisualEffectView that adds a blur effect to make the view appear transparent.
     
     ## Important Notes ##
     1. The blurView is initially not added to the backgroundView to improve performance when not needed. When `isTranslucent` is set to TRUE for the first time the blurView is added and anchored to the `backgroundView`s edge anchors
    */
    open lazy var blurView: UIVisualEffectView = {
        var blurEffect = UIBlurEffect(style: .light)
        if #available(iOS 13, *) {
            blurEffect = UIBlurEffect(style: .systemMaterial)
        }
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Determines if the InputBarAccessoryView should have a translucent effect
    open var isTranslucent: Bool = false {
        didSet {
            if isTranslucent && blurView.superview == nil {
                backgroundView.addSubview(blurView)
                blurView.fillSuperview()
            }
            blurView.isHidden = !isTranslucent
            let color: UIColor = backgroundView.backgroundColor ?? InputBarAccessoryView.defaultBackgroundColor
            backgroundView.backgroundColor = isTranslucent ? color.withAlphaComponent(0.75) : color
        }
    }

    /// A SeparatorLine that is anchored at the top of the InputBarAccessoryView
    public let separatorLine = SeparatorLine()
    
    /**
     The InputStackView at the InputStackView.top position
     
     ## Important Notes ##
     1. It's axis is initially set to .vertical
     2. It's alignment is initially set to .fill
     */
    public let topStackView: InputStackView = {
        let stackView = InputStackView(axis: .vertical, spacing: 0)
        stackView.alignment = .fill
        return stackView
    }()
    
    /**
     The InputStackView at the InputStackView.left position
     
     ## Important Notes ##
     1. It's axis is initially set to .horizontal
     */
    public let leftStackView = InputStackView(axis: .horizontal, spacing: 0)
    
    /**
     The InputStackView at the InputStackView.right position
     
     ## Important Notes ##
     1. It's axis is initially set to .horizontal
     */
    public let rightStackView = InputStackView(axis: .horizontal, spacing: 0)
    
    /**
     The InputStackView at the InputStackView.bottom position
     
     ## Important Notes ##
     1. It's axis is initially set to .horizontal
     2. It's spacing is initially set to 15
     */
    public let bottomStackView = InputStackView(axis: .horizontal, spacing: 15)

    /**
     The main view component of the InputBarAccessoryView

     The default value is the `InputTextView`.

     ## Important Notes ##
     1. This view should self-size with constraints or an
        intrinsicContentSize to auto-size the InputBarAccessoryView
     2. Override with `setMiddleContentView(view: UIView?, animated: Bool)`
     */
    public private(set) weak var middleContentView: UIView?

    /// A view to wrap the `middleContentView` inside
    private let middleContentViewWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private static let defaultBackgroundColor: UIColor = {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }()
    
    /// The InputTextView a user can input a message in
    open lazy var inputTextView: InputTextView = {
        let inputTextView = InputTextView()
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.inputBarAccessoryView = self
        return inputTextView
    }()
    
    /// A InputBarButtonItem used as the send button and initially placed in the rightStackView
    open var sendButton: InputBarSendButton = {
        return InputBarSendButton()
            .configure {
                $0.setSize(CGSize(width: 52, height: 36), animated: false)
                $0.isEnabled = false
                $0.title = "Send"
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            }.onTouchUpInside {
                $0.inputBarAccessoryView?.didSelectSendButton()
        }
    }()

    /**
     The anchor contants used to add horizontal inset from the InputBarAccessoryView and the
     window. By default, an `inputAccessoryView` spans the entire width of the UIWindow. You
     can manage these insets if you wish to implement designs that do not have the bar spanning
     the entire width.

     ## Important Notes ##

     USE AT YOUR OWN RISK

     ````
     H:|-(frameInsets.left)-[InputBarAccessoryView]-(frameInsets.right)-|
     ````

     */
    open var frameInsets: HorizontalEdgePadding = .zero {
        didSet {
            updateFrameInsets()
        }
    }
    
    /**
     The anchor constants used by the InputStackView's and InputTextView to create padding
     within the InputBarAccessoryView
     
     ## Important Notes ##
     
     ````
     V:|...[InputStackView.top]-(padding.top)-[contentView]-(padding.bottom)-|
     
     H:|-(frameInsets.left)-(padding.left)-[contentView]-(padding.right)-(frameInsets.right)-|
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
     V:|-(topStackViewPadding.top)-[InputStackView.top]-(padding.top)-[middleContentView]-...|
     
     H:|-(frameInsets.left)-(topStackViewPadding.left)-[InputStackView.top]-(topStackViewPadding.right)-(frameInsets.right)-|
     ````
     
     */
    open var topStackViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            updateTopStackViewPadding()
        }
    }
    
    /**
     The anchor constants used by the middleContentView
     
     ````
     V:|...-(padding.top)-(middleContentViewPadding.top)-[middleContentView]-(middleContentViewPadding.bottom)-[InputStackView.bottom]-...|
     
     H:|...-[InputStackView.left]-(middleContentViewPadding.left)-[middleContentView]-(middleContentViewPadding.right)-[InputStackView.right]-...|
     ````
     
     */
    open var middleContentViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) {
        didSet {
            updateMiddleContentViewPadding()
        }
    }
    
    /// Returns the most recent size calculated by `calculateIntrinsicContentSize()`
    open override var intrinsicContentSize: CGSize {
        return cachedIntrinsicContentSize
    }
    
    /// The intrinsicContentSize can change a lot so the delegate method
    /// `inputBar(self, didChangeIntrinsicContentTo: size)` only needs to be called
    /// when it's different
    public private(set) var previousIntrinsicContentSize: CGSize?
    
    /// The most recent calculation of the intrinsicContentSize
    private lazy var cachedIntrinsicContentSize: CGSize = calculateIntrinsicContentSize()
    
    /// A boolean that indicates if the maxTextViewHeight has been met. Keeping track of this
    /// improves the performance
    /// The default value is `FALSE`
    public private(set) var isOverMaxTextViewHeight = false
    
    /// A boolean that when set as `TRUE` will always enable the `InputTextView` to be anchored to the
    /// height of `maxTextViewHeight`
    /// The default value is `FALSE`
    public private(set) var shouldForceTextViewMaxHeight = false
    
    /// A boolean that determines if the `maxTextViewHeight` should be maintained automatically.
    /// To control the maximum height of the view yourself, set this to `false`.
    /// The default value is `TRUE`
    open var shouldAutoUpdateMaxTextViewHeight = true

    /// The maximum height that the InputTextView can reach.
    /// This is set automatically when `shouldAutoUpdateMaxTextViewHeight` is true.
    /// To control the height yourself, make sure to set `shouldAutoUpdateMaxTextViewHeight` to false.
    /// The default value is `0`
    open var maxTextViewHeight: CGFloat = 0 {
        didSet {
            textViewHeightAnchor?.constant = maxTextViewHeight
        }
    }
    
    /// A boolean that determines whether the sendButton's `isEnabled` state should be managed automatically.
    /// The default value is `TRUE`
    open var shouldManageSendButtonEnabledState = true

    /// A boolean that determines if the layout required for new or typed text should
    /// be animated.
    /// The default value is `FALSE`
    open var shouldAnimateTextDidChangeLayout = false
    
    /// The height that will fit the current text in the InputTextView based on its current bounds
    public var requiredInputTextViewHeight: CGFloat {
        guard middleContentView == inputTextView else {
            return middleContentView?.intrinsicContentSize.height ?? 0
        }
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        return inputTextView.sizeThatFits(maxTextViewSize).height.rounded(.down)
    }
    
    /// The fixed widthAnchor constant of the leftStackView
    /// The default value is `0`
    public private(set) var leftStackViewWidthConstant: CGFloat = 0 {
        didSet {
            leftStackViewLayoutSet?.width?.constant = leftStackViewWidthConstant
        }
    }
    
    /// The fixed widthAnchor constant of the rightStackView
    /// The default value is `52`
    public private(set) var rightStackViewWidthConstant: CGFloat = 52 {
        didSet {
            rightStackViewLayoutSet?.width?.constant = rightStackViewWidthConstant
        }
    }
    
    /// Holds the InputPlugin plugins that can be used to extend the functionality of the InputBarAccessoryView
    open var inputPlugins = [InputPlugin]()

    /// The InputBarItems held in the leftStackView
    public private(set) var leftStackViewItems: [InputItem] = []
    
    /// The InputBarItems held in the rightStackView
    public private(set) var rightStackViewItems: [InputItem] = []
    
    /// The InputBarItems held in the bottomStackView
    public private(set) var bottomStackViewItems: [InputItem] = []
    
    /// The InputBarItems held in the topStackView
    public private(set) var topStackViewItems: [InputItem] = []
    
    /// The InputBarItems held to make use of their hooks but they are not automatically added to a UIStackView
    open var nonStackViewItems: [InputItem] = []
    
    /// Returns a flatMap of all the items in each of the UIStackViews
    public var items: [InputItem] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems, topStackViewItems, nonStackViewItems].flatMap { $0 }
    }

    // MARK: - Auto-Layout Constraint Sets
    
    private var middleContentViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
    private var topStackViewLayoutSet: NSLayoutConstraintSet?
    private var leftStackViewLayoutSet: NSLayoutConstraintSet?
    private var rightStackViewLayoutSet: NSLayoutConstraintSet?
    private var bottomStackViewLayoutSet: NSLayoutConstraintSet?
    private var contentViewLayoutSet: NSLayoutConstraintSet?
    private var windowAnchor: NSLayoutConstraint?
    private var backgroundViewLayoutSet: NSLayoutConstraintSet?
    
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

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            deactivateConstraints()
            return
        }
        activateConstraints()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        setupConstraints(to: window)
    }
    
    // MARK: - Setup
    
    /// Sets up the default properties
    open func setup() {

        backgroundColor = InputBarAccessoryView.defaultBackgroundColor
        autoresizingMask = [.flexibleHeight]
        setupSubviews()
        setupConstraints()
        setupObservers()
        setupGestureRecognizers()
    }
    
    /// Adds the required notification observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.orientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.inputTextViewDidChange),
                                               name: UITextView.textDidChangeNotification, object: inputTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.inputTextViewDidBeginEditing),
                                               name: UITextView.textDidBeginEditingNotification, object: inputTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.inputTextViewDidEndEditing),
                                               name: UITextView.textDidEndEditingNotification, object: inputTextView)
    }
    
    /// Adds a UISwipeGestureRecognizer for each direction to the InputTextView
    private func setupGestureRecognizers() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(InputBarAccessoryView.didSwipeTextView(_:)))
            gesture.direction = direction
            inputTextView.addGestureRecognizer(gesture)
        }
    }
    
    /// Adds all of the subviews
    private func setupSubviews() {
        
        addSubview(backgroundView)
        addSubview(topStackView)
        addSubview(contentView)
        addSubview(separatorLine)
        contentView.addSubview(middleContentViewWrapper)
        contentView.addSubview(leftStackView)
        contentView.addSubview(rightStackView)
        contentView.addSubview(bottomStackView)
        middleContentViewWrapper.addSubview(inputTextView)
        middleContentView = inputTextView
        setStackViewItems([sendButton], forStack: .right, animated: false)
    }
    
    /// Sets up the initial constraints of each subview
    private func setupConstraints() {
        
        // The constraints within the InputBarAccessoryView
        separatorLine.addConstraints(topAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, heightConstant: separatorLine.height)

        backgroundViewLayoutSet = NSLayoutConstraintSet(
            top: backgroundView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            bottom: backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            left: backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: frameInsets.left),
            right: backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -frameInsets.right)
        )
        
        topStackViewLayoutSet = NSLayoutConstraintSet(
            top:    topStackView.topAnchor.constraint(equalTo: topAnchor, constant: topStackViewPadding.top),
            bottom: topStackView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -padding.top),
            left:   topStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: topStackViewPadding.left + frameInsets.left),
            right:  topStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -(topStackViewPadding.right + frameInsets.right))
        )
        
        contentViewLayoutSet = NSLayoutConstraintSet(
            top:    contentView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: padding.top),
            bottom: contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom),
            left:   contentView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left + frameInsets.left),
            right:  contentView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -(padding.right + frameInsets.right))
        )

        // Constraints Within the contentView
        middleContentViewLayoutSet = NSLayoutConstraintSet(
            top:    middleContentViewWrapper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: middleContentViewPadding.top),
            bottom: middleContentViewWrapper.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -middleContentViewPadding.bottom),
            left:   middleContentViewWrapper.leftAnchor.constraint(equalTo: leftStackView.rightAnchor, constant: middleContentViewPadding.left),
            right:  middleContentViewWrapper.rightAnchor.constraint(equalTo: rightStackView.leftAnchor, constant: -middleContentViewPadding.right)
        )

        inputTextView.fillSuperview()
        maxTextViewHeight = calculateMaxTextViewHeight()
        textViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxTextViewHeight)
        
        leftStackViewLayoutSet = NSLayoutConstraintSet(
            top:    leftStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            bottom: leftStackView.bottomAnchor.constraint(equalTo: middleContentViewWrapper.bottomAnchor, constant: 0),
            left:   leftStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            width:  leftStackView.widthAnchor.constraint(equalToConstant: leftStackViewWidthConstant)
        )
        
        rightStackViewLayoutSet = NSLayoutConstraintSet(
            top:    rightStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            bottom: rightStackView.bottomAnchor.constraint(equalTo: middleContentViewWrapper.bottomAnchor, constant: 0),
            right:  rightStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            width:  rightStackView.widthAnchor.constraint(equalToConstant: rightStackViewWidthConstant)
        )
        
        bottomStackViewLayoutSet = NSLayoutConstraintSet(
            top:    bottomStackView.topAnchor.constraint(equalTo: middleContentViewWrapper.bottomAnchor, constant: middleContentViewPadding.bottom),
            bottom: bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            left:   bottomStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            right:  bottomStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
        )
    }
    
    /// Respect window safeAreaInsets
    /// Adds a constraint to anchor the bottomAnchor of the contentView to the window's safeAreaLayoutGuide.bottomAnchor
    ///
    /// - Parameter window: The window to anchor to
    private func setupConstraints(to window: UIWindow?) {
        guard let window = window, window.safeAreaInsets.bottom > 0 else { return }
        windowAnchor?.isActive = false
        windowAnchor = contentView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
        windowAnchor?.constant = -padding.bottom
        windowAnchor?.priority = UILayoutPriority(rawValue: 750)
        windowAnchor?.isActive = true
        backgroundViewLayoutSet?.bottom?.constant = window.safeAreaInsets.bottom
    }
    
    // MARK: - Constraint Layout Updates

    private func updateFrameInsets() {
        backgroundViewLayoutSet?.left?.constant = frameInsets.left
        backgroundViewLayoutSet?.right?.constant = -frameInsets.right
        updatePadding()
        updateTopStackViewPadding()
    }
    
    /// Updates the constraint constants that correspond to the padding UIEdgeInsets
    private func updatePadding() {
        topStackViewLayoutSet?.bottom?.constant = -padding.top
        contentViewLayoutSet?.top?.constant = padding.top
        contentViewLayoutSet?.left?.constant = padding.left + frameInsets.left
        contentViewLayoutSet?.right?.constant = -(padding.right + frameInsets.right)
        contentViewLayoutSet?.bottom?.constant = -padding.bottom
        windowAnchor?.constant = -padding.bottom
    }
    
    /// Updates the constraint constants that correspond to the middleContentViewPadding UIEdgeInsets
    private func updateMiddleContentViewPadding() {
        middleContentViewLayoutSet?.top?.constant = middleContentViewPadding.top
        middleContentViewLayoutSet?.left?.constant = middleContentViewPadding.left
        middleContentViewLayoutSet?.right?.constant = -middleContentViewPadding.right
        middleContentViewLayoutSet?.bottom?.constant = -middleContentViewPadding.bottom
        bottomStackViewLayoutSet?.top?.constant = middleContentViewPadding.bottom
    }
    
    /// Updates the constraint constants that correspond to the topStackViewPadding UIEdgeInsets
    private func updateTopStackViewPadding() {
        topStackViewLayoutSet?.top?.constant = topStackViewPadding.top
        topStackViewLayoutSet?.left?.constant = topStackViewPadding.left + frameInsets.left
        topStackViewLayoutSet?.right?.constant = -(topStackViewPadding.right + frameInsets.right)
    }

    /// Invalidates the view’s intrinsic content size
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        cachedIntrinsicContentSize = calculateIntrinsicContentSize()
        if previousIntrinsicContentSize != cachedIntrinsicContentSize {
            delegate?.inputBar(self, didChangeIntrinsicContentTo: cachedIntrinsicContentSize)
            previousIntrinsicContentSize = cachedIntrinsicContentSize
        }
    }
    
    /// Calculates the correct intrinsicContentSize of the InputBarAccessoryView
    ///
    /// - Returns: The required intrinsicContentSize
    open func calculateIntrinsicContentSize() -> CGSize {
        
        var inputTextViewHeight = requiredInputTextViewHeight
        if inputTextViewHeight >= maxTextViewHeight {
            if !isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = true
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            inputTextViewHeight = maxTextViewHeight
        } else {
            if isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = false || shouldForceTextViewMaxHeight
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
                inputTextView.invalidateIntrinsicContentSize()
            }
        }
        
        // Calculate the required height
        let totalPadding = padding.top + padding.bottom + topStackViewPadding.top + middleContentViewPadding.top + middleContentViewPadding.bottom
        let topStackViewHeight = topStackView.arrangedSubviews.count > 0 ? topStackView.bounds.height : 0
        let bottomStackViewHeight = bottomStackView.arrangedSubviews.count > 0 ? bottomStackView.bounds.height : 0
        let verticalStackViewHeight = topStackViewHeight + bottomStackViewHeight
        let requiredHeight = inputTextViewHeight + totalPadding + verticalStackViewHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: requiredHeight)
    }

    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        inputTextView.layoutIfNeeded()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard frameInsets.left != 0 || frameInsets.right != 0 else {
            return super.point(inside: point, with: event)
        }
        // Allow touches to pass through base view
        return subviews.contains {
            !$0.isHidden && $0.point(inside: convert(point, to: $0), with: event)
        }
    }
    
    /// Returns the max height the InputTextView can grow to based on the UIScreen
    ///
    /// - Returns: Max Height
    open func calculateMaxTextViewHeight() -> CGFloat {
        if traitCollection.verticalSizeClass == .regular {
            return (UIScreen.main.bounds.height / 3).rounded(.down)
        }
        return (UIScreen.main.bounds.height / 5).rounded(.down)
    }
    
    // MARK: - Layout Helper Methods
    
    /// Layout the given InputStackView's
    ///
    /// - Parameter positions: The InputStackView's to layout
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
        deactivateConstraints()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
        } else {
            UIView.performWithoutAnimation { animations() }
        }
        activateConstraints()
    }
    
    /// Activates the NSLayoutConstraintSet's
    private func activateConstraints() {
        backgroundViewLayoutSet?.activate()
        contentViewLayoutSet?.activate()
        middleContentViewLayoutSet?.activate()
        leftStackViewLayoutSet?.activate()
        rightStackViewLayoutSet?.activate()
        bottomStackViewLayoutSet?.activate()
        topStackViewLayoutSet?.activate()
    }
    
    /// Deactivates the NSLayoutConstraintSet's
    private func deactivateConstraints() {
        backgroundViewLayoutSet?.deactivate()
        contentViewLayoutSet?.deactivate()
        middleContentViewLayoutSet?.deactivate()
        leftStackViewLayoutSet?.deactivate()
        rightStackViewLayoutSet?.deactivate()
        bottomStackViewLayoutSet?.deactivate()
        topStackViewLayoutSet?.deactivate()
    }

    /// Removes the current `middleContentView` and assigns a new one.
    ///
    /// WARNING: This will remove the `InputTextView`
    ///
    /// - Parameters:
    ///   - view: New view
    ///   - animated: If the layout should be animated
    open func setMiddleContentView(_ view: UIView?, animated: Bool) {
        middleContentView?.removeFromSuperview()
        middleContentView = view
        guard let view = view else { return }
        middleContentViewWrapper.addSubview(view)
        view.fillSuperview()

        performLayout(animated) { [weak self] in
            guard self?.superview != nil else { return }
            self?.middleContentViewWrapper.layoutIfNeeded()
            self?.invalidateIntrinsicContentSize()
        }
    }
    
    /// Removes all of the arranged subviews from the InputStackView and adds the given items.
    /// Sets the inputBarAccessoryView property of the InputBarButtonItem
    ///
    /// Note: If you call `animated = true`, the `items` property of the stack view items will not be updated until the 
    /// views are done being animated. If you perform a check for the items after they're set, setting animated to `false`
    /// will apply the body of the closure immediately.
    ///
    /// The send button is attached to `rightStackView` so remember to remove it if you're setting it to a different
    /// stack.
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
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        leftStackView.addArrangedSubview(view)
                    }
                }
                guard superview != nil else { return }
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        rightStackView.addArrangedSubview(view)
                    }
                }
                guard superview != nil else { return }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        bottomStackView.addArrangedSubview(view)
                    }
                }
                guard superview != nil else { return }
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                topStackViewItems = items
                topStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    if let view = $0 as? UIView {
                        topStackView.addArrangedSubview(view)
                    }
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
    ///   - extraAnimations: Any extra operations that should also be animated
    open func setLeftStackViewWidthConstant(to newValue: CGFloat, animated: Bool, animations : (() -> Void)? = nil) {
        performLayout(animated) { 
            self.leftStackViewWidthConstant = newValue
            self.layoutStackViews([.left])
            self.layoutContainerViewIfNeeded()
            animations?()
        }
    }
    
    /// Sets the rightStackViewWidthConstant
    ///
    /// - Parameters:
    ///   - newValue: New widthAnchor constant
    ///   - animated: If the layout should be animated
    ///   - extraAnimations: Any extra operations that should also be animated
    open func setRightStackViewWidthConstant(to newValue: CGFloat, animated: Bool, animations : (() -> Void)? = nil) {
        performLayout(animated) { 
            self.rightStackViewWidthConstant = newValue
            self.layoutStackViews([.right])
            self.layoutContainerViewIfNeeded()
            animations?()
        }
    }
    
    /// Sets the `shouldForceTextViewMaxHeight` property
    ///
    /// - Parameters:
    ///   - newValue: New boolean value
    ///   - animated: If the layout should be animated
    open func setShouldForceMaxTextViewHeight(to newValue: Bool, animated: Bool) {
        performLayout(animated) {
            self.shouldForceTextViewMaxHeight = newValue
            self.textViewHeightAnchor?.isActive = newValue
            self.layoutContainerViewIfNeeded()
        }
    }

    /// Calls `layoutIfNeeded()` on the `UIInputSetContainerView` that holds the
    /// `InputBarAccessoryView`, if it exists, else `layoutIfNeeded()` is called
    /// on the `superview`.
    /// Use this for invoking a smooth layout of a size change when used as
    /// an `inputAccessoryView`
    public func layoutContainerViewIfNeeded() {
        guard
            let UIInputSetContainerViewKind: AnyClass = NSClassFromString("UIInputSetContainerView"),
            let container = superview?.superview,
            container.isKind(of: UIInputSetContainerViewKind) else {
            superview?.layoutIfNeeded()
            return
        }
        superview?.superview?.layoutIfNeeded()
    }
    
    // MARK: - Notifications/Hooks
    
    /// Invalidates the intrinsicContentSize
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass || traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            if shouldAutoUpdateMaxTextViewHeight {
                maxTextViewHeight = calculateMaxTextViewHeight()
            } else {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    /// Invalidates the intrinsicContentSize
    @objc
    open func orientationDidChange() {
        if shouldAutoUpdateMaxTextViewHeight {
            maxTextViewHeight = calculateMaxTextViewHeight()
        }
        invalidateIntrinsicContentSize()
    }

    /// Enables/Disables the sendButton based on the InputTextView's text being empty
    /// Calls each items `textViewDidChangeAction` method
    /// Calls the delegates `textViewTextDidChangeTo` method
    /// Invalidates the intrinsicContentSize
    @objc
    open func inputTextViewDidChange() {
        
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if shouldManageSendButtonEnabledState {
            var isEnabled = !trimmedText.isEmpty
            if !isEnabled {
                // The images property is more resource intensive so only use it if needed
                isEnabled = inputTextView.images.count > 0
            }
            sendButton.isEnabled = isEnabled
        }
        
        // Capture change before iterating over the InputItem's
        let shouldInvalidateIntrinsicContentSize = requiredInputTextViewHeight != inputTextView.bounds.height
        
        items.forEach { $0.textViewDidChangeAction(with: self.inputTextView) }
        delegate?.inputBar(self, textViewTextDidChangeTo: trimmedText)
        
        if shouldInvalidateIntrinsicContentSize {
            // Prevent un-needed content size invalidation
            invalidateIntrinsicContentSize()
            if shouldAnimateTextDidChangeLayout {
                inputTextView.layoutIfNeeded()
                UIView.animate(withDuration: 0.15) {
                    self.layoutContainerViewIfNeeded()
                }
            }
        }
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
    
    // MARK: - Plugins
    
    /// Reloads each of the plugins
    open func reloadPlugins() {
        inputPlugins.forEach { $0.reloadData() }
    }
    
    /// Invalidates each of the plugins
    open func invalidatePlugins() {
        inputPlugins.forEach { $0.invalidate() }
    }
    
    // MARK: - User Actions
    
    /// Calls each items `keyboardSwipeGestureAction` method
    /// Calls the delegates `didSwipeTextViewWith` method
    @objc
    open func didSwipeTextView(_ gesture: UISwipeGestureRecognizer) {
        items.forEach { $0.keyboardSwipeGestureAction(with: gesture) }
        delegate?.inputBar(self, didSwipeTextViewWith: gesture)
    }
    
    /// Calls the delegates `didPressSendButtonWith` method
    /// Assumes that the InputTextView's text has been set to empty and calls `inputTextViewDidChange()`
    /// Invalidates each of the InputPlugins
    open func didSelectSendButton() {
        delegate?.inputBar(self, didPressSendButtonWith: inputTextView.text)
    }
}
