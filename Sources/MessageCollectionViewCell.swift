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

class MessageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let messageContainerView: UIView = {
        
        let messageContainerView = UIView()
        messageContainerView.layer.cornerRadius = 12.0
        messageContainerView.layer.masksToBounds = true
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        return messageContainerView
    }()
    
    let avatarImageView: UIImageView = {
        
        let avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .lightGray
        avatarImageView.layer.masksToBounds = true
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    // MARK: - Initializer
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        //self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        contentView.addSubview(messageContainerView)
        contentView.addSubview(avatarImageView)
        messageContainerView.addSubview(messageLabel)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        print("THE GIVEN FRAME IS: \(layoutAttributes.frame)")
        
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        
        print("THE GIVEN FRAME IS: \(attributes.frame)")
        
        let avatarWidth = attributes.avatarSize.width
        let avatarHeight = attributes.avatarSize.height
        
        let containerHeight = attributes.messageContainerSize.height
        let containerWidth = attributes.messageContainerSize.width
        
        let avatarY = contentView.frame.height - avatarHeight - attributes.avatarBottomPadding
        let containerY: CGFloat = 0
        
        switch attributes.direction {
            
        case .incoming:
            
                        constraints.forEach { removeConstraint($0) }
            
            messageLabel.backgroundColor = .magenta
            
            let avatarX = attributes.messageLeftRightPadding
            let containerX = avatarWidth + attributes.messageLeftRightPadding + attributes.avatarToContainerPadding
            
            avatarImageView.frame = CGRect(x: avatarX, y: avatarY, width: avatarWidth, height: avatarHeight)
            messageContainerView.frame = CGRect(x: containerX, y: containerY, width: containerWidth, height: containerHeight)
            
            messageLabel.font = attributes.messageFont
            messageLabel.frame = CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight)
            
            
                        addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: attributes.messageLeftRightPadding))
                        addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -attributes.avatarBottomPadding))
                        addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .trailing, relatedBy: .equal, toItem: messageContainerView, attribute: .leading, multiplier: 1, constant: -attributes.avatarToContainerPadding))
                        addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: avatarHeight))
                        addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: avatarWidth))
            
                        addConstraint(NSLayoutConstraint(item: messageContainerView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0))
                        addConstraint(NSLayoutConstraint(item: messageContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: containerHeight))
            
        case .outgoing:
            
            constraints.forEach { removeConstraint($0) }
            

            
            messageLabel.backgroundColor = .cyan
            
            let avatarX = contentView.frame.width - attributes.messageLeftRightPadding - avatarWidth
            let containerX = contentView.frame.width - avatarWidth - attributes.messageLeftRightPadding - attributes.avatarToContainerPadding - containerWidth
            
            avatarImageView.frame = CGRect(x: avatarX, y: avatarY, width: avatarWidth, height: avatarHeight)
            messageContainerView.frame = CGRect(x: containerX, y: containerY, width: containerWidth, height: containerHeight)
            
            messageLabel.font = attributes.messageFont
            messageLabel.frame = CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight)
            
            addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: avatarX))
            addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -attributes.avatarBottomPadding))
            addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .trailing, relatedBy: .equal, toItem: messageContainerView, attribute: .leading, multiplier: 1, constant: attributes.avatarToContainerPadding))
            addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: avatarHeight))
            addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: avatarWidth))
            
            addConstraint(NSLayoutConstraint(item: messageContainerView, attribute: .trailing, relatedBy: .equal, toItem: avatarImageView, attribute: .leading, multiplier: 1, constant: -attributes.avatarToContainerPadding))
            addConstraint(NSLayoutConstraint(item: messageContainerView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: messageContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: containerHeight))

            
            
        }
    
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        
    }
}
