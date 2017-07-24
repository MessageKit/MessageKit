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

public protocol MessagesDataSource: class {

    var currentSender: Sender { get } // if this is a function we can conform via extension

    func messageForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> MessageType
    
    func numberOfMessages(in collectionView: UICollectionView) -> Int
    
    func headerForMessage(at indexPath: IndexPath, ofKind kind: String, in collectionView: UICollectionView) -> UICollectionReusableView

    func footerForMessage(at indexPath: IndexPath, ofKind kind: String, in collectionView: UICollectionView) -> UICollectionReusableView
}

public extension MessagesDataSource {

    
    // Pros and cons of not having this defined in the protocol? No idea yet.
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender == currentSender
    }
    
    // Automatically pass message in here or only by indexPath?
    
    func headerForMessage(at indexPath: IndexPath, ofKind kind: String, in collectionView: UICollectionView) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! MessageReusableHeaderView
    }
    
    func footerForMessage(at indexPath: IndexPath, ofKind kind: String, in collectionView: UICollectionView) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! MessageReusableFooterView
    }
    
}


public protocol MessagesDisplayDataSource {

    func bubbleForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> MessageBubble

    func avatarForMessage(_ message: MessageType, at indexPath: IndexPath, in collectionView: UICollectionView) -> Avatar
}
