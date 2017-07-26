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
        messageContainerView.backgroundColor = .green
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
//        messageLabel.layer.cornerRadius = 12.0
//        messageLabel.layer.masksToBounds = true
        messageLabel.numberOfLines = 0
        messageLabel.backgroundColor = .clear
        return messageLabel
    }()
    
    // MARK: - Initializer
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        //setupConstraints()
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
        
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            
            messageLabel.font = attributes.messageFont
            
            setAvatarFrameFor(attributes: attributes)
            setMessageContainerFrameFor(attributes: attributes)
            setMessageLabelFor(attributes: attributes)
            

        }
        
    }
    
    func setMessageContainerFrameFor(attributes: MessagesCollectionViewLayoutAttributes) {
        switch attributes.direction {
        case .incoming:
            let x = attributes.avatarSize.width + attributes.avatarContainerSpacing
            messageContainerView.frame = CGRect(x: x, y: 0, width: attributes.messageContainerSize.width, height: attributes.messageContainerSize.height)
        case .outgoing:
            let x = contentView.frame.width - attributes.avatarSize.width - attributes.avatarContainerSpacing - attributes.messageContainerSize.width
            messageContainerView.frame = CGRect(x: x, y: 0, width: attributes.messageContainerSize.width, height: attributes.messageContainerSize.height)
        }
    }
    
    func setAvatarFrameFor(attributes: MessagesCollectionViewLayoutAttributes) {
        switch attributes.direction {
        case .incoming:
            let y = frame.height - attributes.avatarSize.height - attributes.avatarBottomSpacing
            avatarImageView.frame = CGRect(x: 0, y: y, width: attributes.avatarSize.width, height: attributes.avatarSize.height)
        case .outgoing:
            let y = frame.height - attributes.avatarSize.height - attributes.avatarBottomSpacing
            let x = contentView.frame.width - attributes.avatarSize.width
            avatarImageView.frame = CGRect(x: x, y: y, width: attributes.avatarSize.width, height: attributes.avatarSize.height)
        }
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    func setMessageLabelFor(attributes: MessagesCollectionViewLayoutAttributes) {
        let frame =  CGRect(x: 0, y: 0, width: attributes.messageContainerSize.width, height: attributes.messageContainerSize.height)
        let insetFrame = UIEdgeInsetsInsetRect(frame, attributes.messageContainerInsets)
        messageLabel.frame = insetFrame
    }
    
    func configure(with message: MessageType) {
        switch message.data {
        case .text(let text):
            messageLabel.text = text
        }
    }

}
