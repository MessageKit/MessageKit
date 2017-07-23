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
        messageContainerView.backgroundColor = .green
        messageContainerView.layer.cornerRadius = 12.0
        messageContainerView.layer.masksToBounds = true
        return messageContainerView
    }()
    
    let avatarImageView: UIImageView = {
        
        let avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .red
        return avatarImageView
    }()
    
    // MARK: - Initializer
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        addSubview(messageContainerView)
        addSubview(avatarImageView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        print(attributes.avatarSize)
        print(attributes.messageContainerSize)
        let avatarWidth = attributes.avatarSize.width
        let avatarHeight = attributes.avatarSize.height
        
        let containerHeight = attributes.messageContainerSize.height
        let containerWidth = attributes.messageContainerSize.width
        
        switch attributes.direction {
        case .incoming, .outgoing:
            let avatarX = attributes.avatarToEdgePadding
            let avatarY = contentView.frame.height - attributes.avatarBottomPadding - attributes.avatarSize.height
            avatarImageView.frame = CGRect(x: avatarX, y: avatarY, width: avatarWidth, height: avatarHeight)
            
            let containerX = contentView.frame.width - attributes.messageLeftRightPadding - containerWidth
            let containerY: CGFloat = 0
            messageContainerView.frame = CGRect(x: containerX, y: containerY, width: containerWidth, height: containerHeight)
        }
    }
    
}
