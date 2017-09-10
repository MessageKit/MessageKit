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

    open weak var messagesLayoutDelegate: MessagesLayoutDelegate?

    open weak var messageCellDelegate: MessageCellDelegate?

    open weak var messageLabelDelegate: MessageLabelDelegate?

    private var indexPathForLastItem: IndexPath? {

        let lastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        guard lastSection > 0, numberOfItems(inSection: lastSection) > 0 else { return nil }
        return IndexPath(item: numberOfItems(inSection: lastSection) - 1, section: lastSection)

    }

    // MARK: - Initializers

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    public func scrollToBottom(animated: Bool = false) {
        guard let indexPath = indexPathForLastItem else { return }
        scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }

    open func dequeueMessageHeaderView(withReuseIdentifier identifier: String = "MessageHeader", for indexPath: IndexPath) -> MessageHeaderView {
        let header = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
        return header as? MessageHeaderView ?? MessageHeaderView()
    }

    open func dequeueMessageFooterView(withReuseIdentifier identifier: String = "MessageFooter", for indexPath: IndexPath) -> MessageFooterView {
        let footer = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
        return footer as? MessageFooterView ?? MessageFooterView()
    }

}
