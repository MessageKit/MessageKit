//
//  InputBarButtonItem.swift
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

/**
 A InputItem that inherits from UIButton
 
 ## Important Notes ##
 1. Intended to be used in an `InputStackView`
 */
open class InputBarButtonItem: UIButton, InputItem {
    
    /// The spacing properties of the InputBarButtonItem
    ///
    /// - fixed: The spacing is fixed
    /// - flexible: The spacing is flexible
    /// - none: There is no spacing
    public enum Spacing {
        case fixed(CGFloat)
        case flexible
        case none
    }
    
    public typealias InputBarButtonItemAction = ((InputBarButtonItem) -> Void)
    
    // MARK: - Properties
    
    /// A weak reference to the InputBarAccessoryView that the InputBarButtonItem used in
    open weak var inputBarAccessoryView: InputBarAccessoryView?
    
    /// The spacing property of the InputBarButtonItem that determines the contentHuggingPriority and any
    /// additional space to the intrinsicContentSize
    open var spacing: Spacing = .none {
        didSet {
            switch spacing {
            case .flexible:
                setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
            case .fixed:
                setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            case .none:
                setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
            }
        }
    }
    
    /// When not nil this size overrides the intrinsicContentSize
    private var size: CGSize? = CGSize(width: 20, height: 20) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = size ?? super.intrinsicContentSize
        switch spacing {
        case .fixed(let width):
            contentSize.width += width
        case .flexible, .none:
            break
        }
        return contentSize
    }
    
    /// A reference to the stack view position that the InputBarButtonItem is held in
    open var parentStackViewPosition: InputStackView.Position?
    
    /// The title for the UIControlState.normal
    open var title: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// The image for the UIControlState.normal
    open var image: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    /// Calls the onSelectedAction or onDeselectedAction when set
    open override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            guard newValue != isHighlighted else { return }
            super.isHighlighted = newValue
            if newValue {
                onSelectedAction?(self)
            } else {
                onDeselectedAction?(self)
            }

        }
    }

    /// Calls the onEnabledAction or onDisabledAction when set
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                onEnabledAction?(self)
            } else {
                onDisabledAction?(self)
            }
        }
    }
    
    // MARK: - Reactive Hooks
    
    private var onTouchUpInsideAction: InputBarButtonItemAction?
    private var onKeyboardEditingBeginsAction: InputBarButtonItemAction?
    private var onKeyboardEditingEndsAction: InputBarButtonItemAction?
    private var onKeyboardSwipeGestureAction: ((InputBarButtonItem, UISwipeGestureRecognizer) -> Void)?
    private var onTextViewDidChangeAction: ((InputBarButtonItem, InputTextView) -> Void)?
    private var onSelectedAction: InputBarButtonItemAction?
    private var onDeselectedAction: InputBarButtonItemAction?
    private var onEnabledAction: InputBarButtonItemAction?
    private var onDisabledAction: InputBarButtonItemAction?
    
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
    
    // MARK: - Setup
    
    /// Sets up the default properties
    open func setup() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .vertical)
        setTitleColor(.systemBlue, for: .normal)
        setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        if #available(iOS 13, *) {
            setTitleColor(.systemGray2, for: .disabled)
        } else {
            setTitleColor(.lightGray, for: .disabled)
        }
        adjustsImageWhenHighlighted = false
        addTarget(self, action: #selector(InputBarButtonItem.touchUpInsideAction), for: .touchUpInside)
    }
    
    // MARK: - Size Adjustment
    
    /// Sets the size of the InputBarButtonItem which overrides the intrinsicContentSize. When set to nil
    /// the default intrinsicContentSize is used. The new size will be laid out in the UIStackView that
    /// the InputBarButtonItem is held in
    ///
    /// - Parameters:
    ///   - newValue: The new size
    ///   - animated: If the layout should be animated
    open func setSize(_ newValue: CGSize?, animated: Bool) {
        size = newValue
        if animated, let position = parentStackViewPosition {
            inputBarAccessoryView?.performLayout(animated) { [weak self] in
                self?.inputBarAccessoryView?.layoutStackViews([position])
            }
        }
    }
    
    // MARK: - Hook Setup Methods
    
    /// Used to setup your own initial properties
    ///
    /// - Parameter item: A reference to Self
    /// - Returns: Self
    @discardableResult
    open func configure(_ item: InputBarButtonItemAction) -> Self {
        item(self)
        return self
    }
    
    /// Sets the onKeyboardEditingBeginsAction
    ///
    /// - Parameter action: The new onKeyboardEditingBeginsAction
    /// - Returns: Self
    @discardableResult
    open func onKeyboardEditingBegins(_ action: @escaping InputBarButtonItemAction) -> Self {
        onKeyboardEditingBeginsAction = action
        return self
    }
    
    /// Sets the onKeyboardEditingEndsAction
    ///
    /// - Parameter action: The new onKeyboardEditingEndsAction
    /// - Returns: Self
    @discardableResult
    open func onKeyboardEditingEnds(_ action: @escaping InputBarButtonItemAction) -> Self {
        onKeyboardEditingEndsAction = action
        return self
    }
    
    
    /// Sets the onKeyboardSwipeGestureAction
    ///
    /// - Parameter action: The new onKeyboardSwipeGestureAction
    /// - Returns: Self
    @discardableResult
    open func onKeyboardSwipeGesture(_ action: @escaping (_ item: InputBarButtonItem, _ gesture: UISwipeGestureRecognizer) -> Void) -> Self {
        onKeyboardSwipeGestureAction = action
        return self
    }
    
    /// Sets the onTextViewDidChangeAction
    ///
    /// - Parameter action: The new onTextViewDidChangeAction
    /// - Returns: Self
    @discardableResult
    open func onTextViewDidChange(_ action: @escaping (_ item: InputBarButtonItem, _ textView: InputTextView) -> Void) -> Self {
        onTextViewDidChangeAction = action
        return self
    }
    
    /// Sets the onTouchUpInsideAction
    ///
    /// - Parameter action: The new onTouchUpInsideAction
    /// - Returns: Self
    @discardableResult
    open func onTouchUpInside(_ action: @escaping InputBarButtonItemAction) -> Self {
        onTouchUpInsideAction = action
        return self
    }
    
    /// Sets the onSelectedAction
    ///
    /// - Parameter action: The new onSelectedAction
    /// - Returns: Self
    @discardableResult
    open func onSelected(_ action: @escaping InputBarButtonItemAction) -> Self {
        onSelectedAction = action
        return self
    }
    
    /// Sets the onDeselectedAction
    ///
    /// - Parameter action: The new onDeselectedAction
    /// - Returns: Self
    @discardableResult
    open func onDeselected(_ action: @escaping InputBarButtonItemAction) -> Self {
        onDeselectedAction = action
        return self
    }
    
    /// Sets the onEnabledAction
    ///
    /// - Parameter action: The new onEnabledAction
    /// - Returns: Self
    @discardableResult
    open func onEnabled(_ action: @escaping InputBarButtonItemAction) -> Self {
        onEnabledAction = action
        return self
    }
    
    /// Sets the onDisabledAction
    ///
    /// - Parameter action: The new onDisabledAction
    /// - Returns: Self
    @discardableResult
    open func onDisabled(_ action: @escaping InputBarButtonItemAction) -> Self {
        onDisabledAction = action
        return self
    }
    
    // MARK: - InputItem Protocol
    
    /// Executes the onTextViewDidChangeAction with the given textView
    ///
    /// - Parameter textView: A reference to the InputTextView
    open func textViewDidChangeAction(with textView: InputTextView) {
        onTextViewDidChangeAction?(self, textView)
    }
    
    /// Executes the onKeyboardSwipeGestureAction with the given gesture
    ///
    /// - Parameter gesture: A reference to the gesture that was recognized
    open func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        onKeyboardSwipeGestureAction?(self, gesture)
    }
    
    /// Executes the onKeyboardEditingEndsAction
    open func keyboardEditingEndsAction() {
        onKeyboardEditingEndsAction?(self)
    }
    
    /// Executes the onKeyboardEditingBeginsAction
    open func keyboardEditingBeginsAction() {
        onKeyboardEditingBeginsAction?(self)
    }
    
    /// Executes the onTouchUpInsideAction
    @objc
    open func touchUpInsideAction() {
        onTouchUpInsideAction?(self)
    }
    
    // MARK: - Static Spacers
    
    /// An InputBarButtonItem that's spacing property is set to be .flexible
    public static var flexibleSpace: InputBarButtonItem {
        let item = InputBarButtonItem()
        item.setSize(.zero, animated: false)
        item.spacing = .flexible
        return item
    }
    
    /// An InputBarButtonItem that's spacing property is set to be .fixed with the width arguement
    public static func fixedSpace(_ width: CGFloat) -> InputBarButtonItem {
        let item = InputBarButtonItem()
        item.setSize(.zero, animated: false)
        item.spacing = .fixed(width)
        return item
    }
}
