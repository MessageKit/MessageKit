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
    
    var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - self.sectionInset.left - self.sectionInset.right
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else { return .zero }
        guard let messageType = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else { return .zero }
        
        switch messageType.data {
        case .text(let text):
            let height = text.height(considering: itemWidth, font: messageFont)
            print(height)
            return CGSize(width: itemWidth, height: height)
        default:
            return .zero
        }
    }

}

fileprivate extension String {

    func height(considering width: CGFloat, font: UIFont) -> CGFloat {
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundRect = self.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundRect.height
    }

}
