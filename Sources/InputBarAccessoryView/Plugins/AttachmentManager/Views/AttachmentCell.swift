//
//  AttachmentCell.swift
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

open class AttachmentCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    open class var reuseIdentifier: String {
        return "AttachmentCell"
    }
    
    public let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            view.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .groupTableViewBackground
        }
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) {
        didSet {
            updateContainerPadding()
        }
    }
    
    open lazy var deleteButton: UIButton = { [weak self] in
        let button = UIButton()
        let textColor: UIColor
        if #available(iOS 13, *) {
            textColor = .systemBackground
        } else {
            textColor = .white
        }
        button.setAttributedTitle(NSMutableAttributedString().bold("X", fontSize: 15, textColor: textColor), for: .normal)
        button.setAttributedTitle(NSMutableAttributedString().bold("X", fontSize: 15, textColor: textColor.withAlphaComponent(0.5)), for: .highlighted)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(deleteAttachment), for: .touchUpInside)
        return button
    }()
    
    open var attachment: AttachmentManager.Attachment?
    
    open var indexPath: IndexPath?
    
    open weak var manager: AttachmentManager?
    
    private var containerViewLayoutSet: NSLayoutConstraintSet?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
        manager = nil
        attachment = nil
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        
        contentView.addSubview(containerView)
        contentView.addSubview(deleteButton)
    }

    private func setupConstraints() {
        
        containerViewLayoutSet = NSLayoutConstraintSet(
            top:    containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.top),
            bottom: containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding.bottom),
            left:   containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.left),
            right:  containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding.right)
        ).activate()
        deleteButton.addConstraints(contentView.topAnchor, right: contentView.rightAnchor, widthConstant: 20, heightConstant: 20)
    }
    
    private func updateContainerPadding() {
        
        containerViewLayoutSet?.top?.constant = padding.top
        containerViewLayoutSet?.bottom?.constant = -padding.bottom
        containerViewLayoutSet?.left?.constant = padding.left
        containerViewLayoutSet?.right?.constant = -padding.right
    }
    
    // MARK: - User Actions
    
    @objc
    func deleteAttachment() {
        
        guard let index = indexPath?.row else { return }
        manager?.removeAttachment(at: index)
    }
}
