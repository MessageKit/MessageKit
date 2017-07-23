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

class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties
    
    let avatarSizeCalculator = AvatarSizeCalculator()
    
    let messageContainerSizeCalculator = MessageContainerSizeCalculator()
    
    var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    var incomingAvatarSize: CGSize = CGSize(width: 30, height: 30)
    
    var outgoingAvatarSize: CGSize = CGSize(width: 30, height: 30)
    
    var messageLeftRightPadding: CGFloat = 16
    
    let avatarToEdgePadding: CGFloat = 4
    let avatarBottomPadding: CGFloat = 4
    let avatarToContainerPadding: CGFloat = 2
    
    override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }
    
    var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - self.sectionInset.left - self.sectionInset.right
    }
    
    // MARK: - Methods
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messageType = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else { return .zero }
        
        let containerHeight = messageContainerSizeCalculator.messageContainerSizeFor(messageType: messageType, with: self).height
        
        return CGSize(width: itemWidth, height: containerHeight)
  
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else { return nil }
        attributesArray.forEach { configureLayoutAttributes($0) }
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else { return nil }
        configureLayoutAttributes(attributes)
        return attributes
    }
    
    func configureLayoutAttributes(_ layoutAttributes: MessagesCollectionViewLayoutAttributes) {

        let indexPath = layoutAttributes.indexPath

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        
        let messageType = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let messageDirection: MessageDirection = messagesDataSource.isFromCurrentSender(message: messageType) ? .outgoing : .incoming
        
        // Maybe we can cache this somewhere? It seems like we're calculating it a lot
        let messageContainerSize = messageContainerSizeCalculator.messageContainerSizeFor(messageType: messageType, with: self)
        let avatarSize = avatarSizeCalculator.avatarSizeFor(messageType: messageType, with: self)
        
        layoutAttributes.direction = messageDirection
        layoutAttributes.messageFont = messageFont
        layoutAttributes.messageLeftRightPadding = messageLeftRightPadding
        layoutAttributes.avatarSize = avatarSize
        layoutAttributes.messageContainerSize = messageContainerSize

    }

}


