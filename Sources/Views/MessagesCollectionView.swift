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

open class MessagesCollectionView: UICollectionView {

    // MARK: - Properties

    open weak var messagesDataSource: MessagesDataSource?

    open weak var messagesDisplayDelegate: MessagesDisplayDelegate?

    open weak var messagesLayoutDelegate: MessagesLayoutDelegate?

    open weak var messageCellDelegate: MessageCellDelegate?
    
    open var messageLoadMoreControl = UIRefreshControl()

    open var showsDateHeaderAfterTimeInterval: TimeInterval = 3600

    private var indexPathForLastItem: IndexPath? {

        let lastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        guard lastSection > 0, numberOfItems(inSection: lastSection) > 0 else { return nil }
        return IndexPath(item: numberOfItems(inSection: lastSection) - 1, section: lastSection)

    }

    // MARK: - Initializers

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        addSubview(messageLoadMoreControl)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: MessagesCollectionViewFlowLayout())
    }

    // MARK: - Methods

    public func scrollToBottom(animated: Bool = false) {
        guard let indexPath = indexPathForLastItem else { return }
        scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    override open func reloadData() {
        if !messageLoadMoreControl.isRefreshing {
            super.reloadData()
            return
        }
        
        // wait util the refreshing animation is stop
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // stop scrolling
            self.setContentOffset(self.contentOffset, animated: false)
            
            // calculate the offset and reloadData
            let beforeContentSize = self.contentSize
            super.reloadData()
            self.layoutIfNeeded()
            let afterContentSize = self.contentSize
            
            // reset the contentOffset after data is updated
            self.setContentOffset(CGPoint(
                x: self.contentOffset.x + (afterContentSize.width - beforeContentSize.width),
                y: self.contentOffset.y + (afterContentSize.height - beforeContentSize.height)), animated: false)
            
            self.messageLoadMoreControl.endRefreshing()
        }
    }

}
