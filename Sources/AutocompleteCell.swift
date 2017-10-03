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

open class AutocompleteCell: UITableViewCell {
    
    // MARK: - Properties
    
    open class var reuseIdentifier: String {
        return "AutocompleteCell"
    }
    
    open var prefix: Character? {
        didSet {
            updateTextLabel()
        }
    }

    open var autocompleteText: String? {
        didSet {
            updateTextLabel()
        }
    }
    
    /// A boarder line anchored to the top of the view
    open let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        prefix = nil
        autocompleteText = nil
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
        
        separatorLine.addConstraints(topAnchor, left: leftAnchor, right: rightAnchor, heightConstant: 0.5)
    }
    
    private func updateTextLabel() {
        
        guard let prefix = prefix, let autocompleteText = autocompleteText else { return }
        textLabel?.text = String(prefix) + autocompleteText
    }
}
