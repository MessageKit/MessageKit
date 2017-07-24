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
    
    let avatarBottomPadding: CGFloat = 4
    let avatarToContainerPadding: CGFloat = 4
    
    var contentHeight: CGFloat = 0
    
    var scrollPadding = 100
    
    override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }
    
    var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - self.sectionInset.left - self.sectionInset.right
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: 1000)
    }
    
    // MARK: - Methods
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messageType = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else { return .zero }
        
        let containerHeight = messageContainerSizeCalculator.messageContainerSizeFor(messageType: messageType, with: self).height
        
        let minimumCellHeight = max(incomingAvatarSize.height, outgoingAvatarSize.height) + avatarBottomPadding
        
        if containerHeight <  minimumCellHeight {
            return CGSize(width: itemWidth, height: minimumCellHeight.rounded())
        } else {
            return CGSize(width: itemWidth, height: containerHeight.rounded())
        }
  
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        //attributesArray.forEach { configureLayoutAttributes($0) }
        print("THERE ARE \(attributesArray.count) ATTRIBUTES")
        

        guard let attrCopy = NSArray(array: attributesArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        attrCopy.forEach { attr in
        
            if attr.representedElementCategory == UICollectionElementCategory.cell {
                self.configureLayoutAttributes(attr as! MessagesCollectionViewLayoutAttributes)
            } else {
                attr.zIndex = -1
            }
        
        }
        
        
        attrCopy.forEach {
            
            print(
            "MESSAGE NUMBER \($0.indexPath.section)",
            "IndexPath: \($0.indexPath)",
            "Frame: \($0.frame)",
            "Bounds: \($0.bounds)",
            "Center: \($0.center)",
            "zIndex: \($0.zIndex)",
            "Hidden: \($0.isHidden)", separator: "\n", terminator: "\n ==================== \n")
        }
        return attrCopy
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else { return nil }
        
        if attributes.representedElementCategory == UICollectionElementCategory.cell {
            
            configureLayoutAttributes(attributes)
        }

        return attributes
    }
    
    func configureLayoutAttributes(_ layoutAttributes: MessagesCollectionViewLayoutAttributes) {

        let indexPath = layoutAttributes.indexPath

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        
        let messageType = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let messageDirection: MessageDirection = messagesDataSource.isFromCurrentSender(message: messageType) ? .outgoing : .incoming
        
        // Maybe we can cache this somewhere? It seems like we're calculating it a lot
        // TODO: Attribute caching
        let messageContainerSize = messageContainerSizeCalculator.messageContainerSizeFor(messageType: messageType, with: self)
        let avatarSize = avatarSizeCalculator.avatarSizeFor(messageType: messageType, with: self)
        
        layoutAttributes.direction = messageDirection
        layoutAttributes.messageFont = messageFont
        layoutAttributes.messageLeftRightPadding = messageLeftRightPadding
        layoutAttributes.avatarSize = avatarSize
        layoutAttributes.messageContainerSize = messageContainerSize
        layoutAttributes.avatarBottomPadding = avatarBottomPadding
        layoutAttributes.avatarToContainerPadding = avatarToContainerPadding

    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds != newBounds
    }
    
}


