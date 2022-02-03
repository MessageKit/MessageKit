/*
 MIT License

 Copyright (c) 2017-2022 MessageKit

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
import UIKit

/// A protocol used by the `MessagesCollectionViewFlowLayout` object to determine
/// the size and layout of a `MessageCollectionViewCell` and its contents.
public protocol MessagesLayoutDelegate: AnyObject {

    /// Specifies the size to use for a header view.
    ///
    /// - Parameters:
    ///   - section: The section number of the header.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this header will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is a size of `GGSize.zero`.
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// Specifies the size to use for a footer view.
    ///
    /// - Parameters:
    ///   - section: The section number of the footer.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this footer will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is a size of `GGSize.zero`.
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize

    /// Specifies the size to use for a typing indicator view.
    ///
    /// - Parameters:
    ///   - layout: The `MessagesCollectionViewFlowLayout` layout.
    ///
    /// - Note:
    ///   The default value returned by this method is the width of the `messagesCollectionView` minus insets and a height of 62.
    func typingIndicatorViewSize(for layout: MessagesCollectionViewFlowLayout) -> CGSize

    /// Specifies the top inset to use for a typing indicator view.
    ///
    /// - Parameters:
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this view will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is a top inset of 15.
    func typingIndicatorViewTopInset(in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// Specifies the height for the `MessageContentCell`'s top label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is zero.
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    
    /// Specifies the height for the `MessageContentCell`'s bottom label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is zero.
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    
    /// Specifies the height for the message bubble's top label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is zero.
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// Specifies the label alignment for the message bubble's top label.
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView:  The `MessagesCollectionView` in which this cell will be displayed.
    /// - Returns: Optional LabelAlignment for the message bubble's top label. If nil is returned or the delegate method is not implemented,
    ///  alignment from MessageSizeCalculator will be used depending if the message is outgoing or incoming
    func messageTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment?

    /// Specifies the height for the `MessageContentCell`'s bottom label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is zero.
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat

    /// Specifies the label alignment for the message bubble's bottom label.
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView:  The `MessagesCollectionView` in which this cell will be displayed.
    /// - Returns: Optional LabelAlignment for the message bubble's bottom label. If nil is returned or the delegate method is not implemented,
    ///  alignment from MessageSizeCalculator will be used depending if the message is outgoing or incoming
    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment?

    /// Text cell size calculator for messages with MessageType.text.
    ///
    /// - Parameters:
    ///   - message: The text message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.text.
    func textCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Attributed text cell size calculator for messages with MessageType.attributedText.
    ///
    /// - Parameters:
    ///   - message: The attributedText message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.attributedText.
    func attributedTextCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Emoji cell size calculator for messages with MessageType.emoji.
    ///
    /// - Parameters:
    ///   - message: The emoji message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.emoji.
    func emojiCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Photo cell size calculator for messages with MessageType.photo.
    ///
    /// - Parameters:
    ///   - message: The photo message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.text.
    func photoCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Video cell size calculator for messages with MessageType.video.
    ///
    /// - Parameters:
    ///   - message: The video message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.video.
    func videoCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Location cell size calculator for messages with MessageType.location.
    ///
    /// - Parameters:
    ///   - message: The location message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.location.
    func locationCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Audio cell size calculator for messages with MessageType.audio.
    ///
    /// - Parameters:
    ///   - message: The audio message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.audio.
    func audioCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Contact cell size calculator for messages with MessageType.contact.
    ///
    /// - Parameters:
    ///   - message: The contact message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will return nil. You must override this method if you are using your own cell for messages with MessageType.contact.
    func contactCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator?
    
    /// Custom cell size calculator for messages with MessageType.custom.
    ///
    /// - Parameters:
    ///   - message: The custom message
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default implementation will throw fatalError(). You must override this method if you are using messages with MessageType.custom.
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator
}

public extension MessagesLayoutDelegate {

    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func typingIndicatorViewSize(for layout: MessagesCollectionViewFlowLayout) -> CGSize {
        let collectionViewWidth = layout.messagesCollectionView.bounds.width
        let contentInset = layout.messagesCollectionView.contentInset
        let inset = layout.sectionInset.horizontal + contentInset.horizontal
        return CGSize(width: collectionViewWidth - inset, height: 62)
    }

    func typingIndicatorViewTopInset(in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 15
    }

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func messageTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return nil
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return nil
    }
    
    func textCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func attributedTextCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func emojiCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func photoCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func videoCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func locationCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func audioCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func contactCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        fatalError("Must return a CellSizeCalculator for MessageKind.custom(Any?)")
    }
}
