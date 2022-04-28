//
//  AutocompleteCell.swift
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
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

open class AutocompleteCell: UITableViewCell {
    
    // MARK: - Properties
    
    open class var reuseIdentifier: String {
        return "AutocompleteCell"
    }
    
    /// A boarder line anchored to the top of the view
    public let separatorLine = SeparatorLine()
    
    open var imageViewEdgeInsets: UIEdgeInsets = .zero { didSet { setNeedsLayout() } }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.image = nil
        imageViewEdgeInsets = .zero
        if #available(iOS 13, *) {
            separatorLine.backgroundColor = .systemGray2
        } else {
            separatorLine.backgroundColor = .lightGray
        }
        separatorLine.isHidden = false
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        setupSubviews()
        setupConstraints()
    }
    
    open func setupSubviews() {
        
        addSubview(separatorLine)
    }
    
    open func setupConstraints() {
        
        separatorLine.addConstraints(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, heightConstant: 0.5)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageViewFrame = imageView?.frame else { return }
        let imageViewOrigin = CGPoint(x: imageViewFrame.origin.x + imageViewEdgeInsets.left, y: imageViewFrame.origin.y + imageViewEdgeInsets.top)
        let imageViewSize = CGSize(width: imageViewFrame.size.width - imageViewEdgeInsets.left - imageViewEdgeInsets.right, height: imageViewFrame.size.height - imageViewEdgeInsets.top - imageViewEdgeInsets.bottom)
        imageView?.frame = CGRect(origin: imageViewOrigin, size: imageViewSize)
    }
    
    // MARK: - API [Public]
    
    @available(*, deprecated, message: "This function has been moved to the `AutocompleteManager`")
    open func attributedText(matching session: AutocompleteSession) -> NSMutableAttributedString {
        fatalError("Please use `func attributedText(matching:, fontSize:)` implemented in the `AutocompleteManager`")
    }
}
