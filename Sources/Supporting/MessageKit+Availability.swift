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

import Foundation

// MARK: - MessagesViewController

public extension MessagesViewController {

    @available(*, deprecated: 0.10.0, message: "Removed in MessageKit 0.10.0. Please use the messagesCollectionView.contentInsets.top property.")
    public var additionalTopContentInset: CGFloat {
        get {
            return messagesCollectionView.contentInset.top
        }
        set {
            messagesCollectionView.contentInset.top = newValue
        }
    }

}

// MARK: - MessagesCollectionView

public extension MessagesCollectionView {

    @available(*, deprecated: 0.9.0, message: "Removed in MessageKit 0.9.0. Please use dequeueReusableHeaderView")
    public func dequeueMessageHeaderView(withReuseIdentifier identifier: String = "MessageHeaderView", for indexPath: IndexPath) -> MessageHeaderView {
        return dequeueReusableHeaderView(MessageHeaderView.self, for: indexPath)
    }

    @available(*, deprecated: 0.9.0, message: "Removed in MessageKit 0.9.0. Please use dequeueReusableFooterView")
    public func dequeueMessageFooterView(withReuseIdentifier identifier: String = "MessageFooterView", for indexPath: IndexPath) -> MessageFooterView {
        return dequeueReusableFooterView(MessageFooterView.self, for: indexPath)
    }

}

// MARK: - MessagesCollectionViewFlowLayout

public extension MessagesCollectionViewFlowLayout {

    @available(*, deprecated: 0.9.0, message: "Removed in MessageKit 0.9.0. Please use messageLabelInsets(for:indexPath:messagesCollectionView)")
    public var messageLabelInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
    }

    @available(*, deprecated: 0.9.0, message: "Removed in MessageKit 0.9.0. Please use associated value of LabelAlignment")
    public var cellTopLabelInsets: UIEdgeInsets {
        return .zero
    }
    @available(*, deprecated: 0.9.0, message: "Removed in MessageKit 0.9.0. Please use associated value of LabelAlignment")
    public var cellBottomLabelInsets: UIEdgeInsets {
        return .zero
    }

    @available(*, deprecated: 0.9.0, message: "Removed in MessageKit 0.9.0. Please use messagePadding(for:at:in) method of MessagesLayoutDelegate")
    public var messageToViewEdgePadding: CGFloat {
        return 30
    }

}
