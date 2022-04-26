//
//  InputTextView.swift
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

import Foundation
import UIKit

/**
 A UITextView that has a UILabel embedded for placeholder text
 
 ## Important Notes ##
 1. Changing the font, textAlignment or textContainerInset automatically performs the same modifications to the placeholderLabel
 2. Intended to be used in an `InputBarAccessoryView`
 3. Default placeholder text is "Aa"
 4. Will pass a pasted image it's `InputBarAccessoryView`'s `InputPlugin`s
 */
open class InputTextView: UITextView {
    
    // MARK: - Properties
    
    open override var text: String! {
        didSet {
            postTextViewDidChangeNotification()
        }
    }
    
    open override var attributedText: NSAttributedString! {
        didSet {
            postTextViewDidChangeNotification()
        }
    }
    
    /// The images that are currently stored as NSTextAttachment's
    open var images: [UIImage] {
        return parseForAttachedImages()
    }
    
    open var components: [Any] {
        return parseForComponents()
    }
    
    open var isImagePasteEnabled: Bool = true

    private var canBecomeFirstResponderStorage: Bool = true
    open override var canBecomeFirstResponder: Bool {
        get { canBecomeFirstResponderStorage }
        set(newValue) { canBecomeFirstResponderStorage = newValue }
    }

    /// A UILabel that holds the InputTextView's placeholder text
    public let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        if #available(iOS 13, *) {
            label.textColor = .systemGray2
        } else {
            label.textColor = .lightGray
        }
        label.text = "Aa"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The placeholder text that appears when there is no text
    open var placeholder: String? = "Aa" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    /// The placeholderLabel's textColor
    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    
    /// The UIEdgeInsets the placeholderLabel has within the InputTextView
    open var placeholderLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    /// The font of the InputTextView. When set the placeholderLabel's font is also updated
    open override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    /// The textAlignment of the InputTextView. When set the placeholderLabel's textAlignment is also updated
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    /// The textContainerInset of the InputTextView. When set the placeholderLabelInsets is also updated
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabelInsets = textContainerInset
        }
    }
    
    open override var scrollIndicatorInsets: UIEdgeInsets {
        didSet {
            // When .zero a rendering issue can occur
            if scrollIndicatorInsets == .zero {
                scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                                     left: .leastNonzeroMagnitude,
                                                     bottom: .leastNonzeroMagnitude,
                                                     right: .leastNonzeroMagnitude)
            }
        }
    }
    
    /// A weak reference to the InputBarAccessoryView that the InputTextView is contained within
    open weak var inputBarAccessoryView: InputBarAccessoryView?
    
    /// The constraints of the placeholderLabel
    private var placeholderLabelConstraintSet: NSLayoutConstraintSet?
 
    // MARK: - Initializers
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        
        backgroundColor = .clear
        font = UIFont.preferredFont(forTextStyle: .body)
        isScrollEnabled = false
        scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                             left: .leastNonzeroMagnitude,
                                             bottom: .leastNonzeroMagnitude,
                                             right: .leastNonzeroMagnitude)
        setupPlaceholderLabel()
        setupObservers()
    }
    
    /// Adds the placeholderLabel to the view and sets up its initial constraints
    private func setupPlaceholderLabel() {

        addSubview(placeholderLabel)
        placeholderLabelConstraintSet = NSLayoutConstraintSet(
            top:     placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeholderLabelInsets.top),
            bottom:  placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -placeholderLabelInsets.bottom),
            left:    placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: placeholderLabelInsets.left),
            right:   placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -placeholderLabelInsets.right),
            centerX: placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerY: placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        )
        placeholderLabelConstraintSet?.centerX?.priority = .defaultLow
        placeholderLabelConstraintSet?.centerY?.priority = .defaultLow
        placeholderLabelConstraintSet?.activate()
    }
    
    /// Adds a notification for .UITextViewTextDidChange to detect when the placeholderLabel
    /// should be hidden or shown
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputTextView.redrawTextAttachments),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputTextView.textViewTextDidChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }

    /// Updates the placeholderLabels constraint constants to match the placeholderLabelInsets
    private func updateConstraintsForPlaceholderLabel() {

        placeholderLabelConstraintSet?.top?.constant = placeholderLabelInsets.top
        placeholderLabelConstraintSet?.bottom?.constant = -placeholderLabelInsets.bottom
        placeholderLabelConstraintSet?.left?.constant = placeholderLabelInsets.left
        placeholderLabelConstraintSet?.right?.constant = -placeholderLabelInsets.right
    }
    
    // MARK: - Notifications
    
    private func postTextViewDidChangeNotification() {
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc
    private func textViewTextDidChange() {
        let isPlaceholderHidden = !text.isEmpty
        placeholderLabel.isHidden = isPlaceholderHidden
        // Adjust constraints to prevent unambiguous content size
        if isPlaceholderHidden {
            placeholderLabelConstraintSet?.deactivate()
        } else {
            placeholderLabelConstraintSet?.activate()
        }
    }
    
    // MARK: - Image Paste Support
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == NSSelectorFromString("paste:") && UIPasteboard.general.hasImages {
            return isImagePasteEnabled
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    open override func paste(_ sender: Any?) {
        
        guard isImagePasteEnabled, let image = UIPasteboard.general.image else {
            return super.paste(sender)
        }
        for plugin in inputBarAccessoryView?.inputPlugins ?? [] {
            if plugin.handleInput(of: image) {
                return
            }
        }
        pasteImageInTextContainer(with: image)
    }
    
    /// Addes a new UIImage to the NSTextContainer as an NSTextAttachment
    ///
    /// - Parameter image: The image to add
    private func pasteImageInTextContainer(with image: UIImage) {
        
        // Add the new image as an NSTextAttachment
        let attributedImageString = NSAttributedString(attachment: textAttachment(using: image))
        
        let isEmpty = attributedText.length == 0
        
        // Add a new line character before the image, this is what iMessage does
        let newAttributedStingComponent = isEmpty ? NSMutableAttributedString(string: "") : NSMutableAttributedString(string: "\n")
        newAttributedStingComponent.append(attributedImageString)
        
        // Add a new line character after the image, this is what iMessage does
        newAttributedStingComponent.append(NSAttributedString(string: "\n"))
        
        // The attributes that should be applied to the new NSAttributedString to match the current attributes
        let defaultTextColor: UIColor
        if #available(iOS 13, *) {
            defaultTextColor = .label
        } else {
            defaultTextColor = .black
        }
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font ?? UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor: textColor ?? defaultTextColor
        ]
        newAttributedStingComponent.addAttributes(attributes, range: NSRange(location: 0, length: newAttributedStingComponent.length))
        
        textStorage.beginEditing()
        // Paste over selected text
        textStorage.replaceCharacters(in: selectedRange, with: newAttributedStingComponent)
        textStorage.endEditing()
        
        // Advance the range to the selected range plus the number of characters added
        let location = selectedRange.location + (isEmpty ? 2 : 3)
        selectedRange = NSRange(location: location, length: 0)
        
        // Broadcast a notification to recievers such as the MessageInputBar which will handle resizing
        postTextViewDidChangeNotification()
    }
    
    /// Returns an NSTextAttachment the provided image that will fit inside the NSTextContainer
    ///
    /// - Parameter image: The image to create an attachment with
    /// - Returns: The formatted NSTextAttachment
    private func textAttachment(using image: UIImage) -> NSTextAttachment {
        
        guard let cgImage = image.cgImage else { return NSTextAttachment() }
        let scale = image.size.width / (frame.width - 2 * (textContainerInset.left + textContainerInset.right))
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(cgImage: cgImage, scale: scale, orientation: image.imageOrientation)
        return textAttachment
    }
    
    /// Returns all images that exist as NSTextAttachment's
    ///
    /// - Returns: An array of type UIImage
    private func parseForAttachedImages() -> [UIImage] {
        
        var images = [UIImage]()
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.attachment, in: range, options: [], using: { value, range, _ -> Void in
            
            if let attachment = value as? NSTextAttachment {
                if let image = attachment.image {
                    images.append(image)
                } else if let image = attachment.image(forBounds: attachment.bounds,
                                                       textContainer: nil,
                                                       characterIndex: range.location) {
                    images.append(image)
                }
            }
        })
        return images
    }
    
    /// Returns an array of components (either a String or UIImage) that makes up the textContainer in
    /// the order that they were typed
    ///
    /// - Returns: An array of objects guaranteed to be of UIImage or String
    private func parseForComponents() -> [Any] {
        
        var components = [Any]()
        var attachments = [(NSRange, UIImage)]()
        let length = attributedText.length
        let range = NSRange(location: 0, length: length)
        attributedText.enumerateAttribute(.attachment, in: range) { (object, range, _) in
            if let attachment = object as? NSTextAttachment {
                if let image = attachment.image {
                    attachments.append((range, image))
                } else if let image = attachment.image(forBounds: attachment.bounds,
                                                       textContainer: nil,
                                                       characterIndex: range.location) {
                    attachments.append((range,image))
                }
            }
        }
        
        var curLocation = 0
        if attachments.count == 0 {
            let text = attributedText.string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                components.append(text)
            }
        }
        else {
            attachments.forEach { (attachment) in
                let (range, image) = attachment
                if curLocation < range.location {
                    let textRange = NSMakeRange(curLocation, range.location - curLocation)
                    let text = attributedText.attributedSubstring(from: textRange).string.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !text.isEmpty {
                        components.append(text)
                    }
                }
                
                curLocation = range.location + range.length
                components.append(image)
            }
            if curLocation < length - 1  {
                let text = attributedText.attributedSubstring(from: NSMakeRange(curLocation, length - curLocation)).string.trimmingCharacters(in: .whitespacesAndNewlines)
                if !text.isEmpty {
                    components.append(text)
                }
            }
        }
        
        return components
    }
    
    /// Redraws the NSTextAttachments in the NSTextContainer to fit the current bounds
    @objc
    private func redrawTextAttachments() {
        
        guard images.count > 0 else { return }
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.attachment, in: range, options: [], using: { value, _, _ -> Void in
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                
                // Calculates a new width/height ratio to fit the image in the current frame
                let newWidth = frame.width - 2 * (textContainerInset.left + textContainerInset.right)
                let ratio = image.size.height / image.size.width
                attachment.bounds.size = CGSize(width: newWidth, height: ratio * newWidth)
            }
        })
        layoutManager.invalidateLayout(forCharacterRange: range, actualCharacterRange: nil)
    }
    
}

