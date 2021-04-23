/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
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

/// An object that adopts the `MessagesDataSource` protocol is responsible for providing
/// the data required by a `MessagesCollectionView`.
public protocol MessagesDataSource: AnyObject {

    /// The `SenderType` of new messages in the `MessagesCollectionView`.
    func currentSender() -> SenderType

    /// A helper method to determine if a given message is from the current `SenderType`.
    ///
    /// - Parameters:
    ///   - message: The message to check if it was sent by the current `SenderType`.
    ///
    /// - Note:
    ///   The default implementation of this method checks for equality between
    ///   the message's `SenderType` and the current `SenderType`.
    func isFromCurrentSender(message: MessageType) -> Bool

    /// The message to be used for a `MessageCollectionViewCell` at the given `IndexPath`.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which the message will be displayed.
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType

    /// The number of sections to be displayed in the `MessagesCollectionView`.
    ///
    /// - Parameters:
    ///   - messagesCollectionView: The `MessagesCollectionView` in which the messages will be displayed.
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int

    /// The number of cells to be displayed in the `MessagesCollectionView`.
    ///
    /// - Parameters:
    ///   - section: The number of the section in which the cells will be displayed.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which the messages will be displayed.
    /// - Note:
    ///   The default implementation of this method returns 1. Putting each message in its own section.
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int

    /// The attributed text to be used for cell's top label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `nil`.
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    
    /// The attributed text to be used for cell's bottom label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `nil`.
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    
    /// The attributed text to be used for message bubble's top label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `nil`.
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    /// The attributed text to be used for cell's bottom label.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `nil`.
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    /// The attributed text to be used for cell's timestamp label.
    /// The timestamp label is shown when showMessageTimestampOnSwipeLeft is enabled by swiping left over the chat controller.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `nil`.
    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    
    /// Text collectionView cell for message with `text`, `attributedText`, `emoji` message types.
    ///
    /// - Parameters:
    ///   - message: The `text`, `attributedText`, `emoji` message type
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method will return nil by default. You must override this method only if you want your own cell.
    func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell?
    
    /// Photo or Video collectionView cell for message with `photo`, `video` message types.
    ///
    /// - Parameters:
    ///   - message: The `photo`, `video` message type
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method will return nil by default. You must override this method only if you want your own cell.
    func photoCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell?
    
    /// Location collectionView cell for message with `location` message type.
    ///
    /// - Parameters:
    ///   - message: The `location` message type
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method will return nil by default. You must override this method only if you want your own cell.
    func locationCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell?
    
    /// Audio collectionView cell for message with `audio` message type.
    ///
    /// - Parameters:
    ///   - message: The `audio` message type
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method will return nil by default. You must override this method only if you want your own cell.
    func audioCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell?
    
    /// Contact collectionView cell for message with `contact` message type.
    ///
    /// - Parameters:
    ///   - message: The `contact` message type
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method will return nil by default. You must override this method only if you want your own cell.
    func contactCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell?
    
    /// Custom collectionView cell for message with `custom` message type.
    ///
    /// - Parameters:
    ///   - message: The `custom` message type
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method will call fatalError() on default. You must override this method if you are using MessageKind.custom messages.
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell

    /// Typing indicator cell used when the indicator is set to be shown
    ///
    /// - Parameters:
    ///   - indexPath: The index path to dequeue the cell at
    ///   - messagesCollectionView: The `MessagesCollectionView` the cell is to be rendered in
    /// - Returns: A `UICollectionViewCell` that indicates a user is typing
    func typingIndicator(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell
}

public extension MessagesDataSource {

    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == currentSender().senderId
    }

    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sentDate = message.sentDate
        let sentDateString = MessageKitDateFormatter.shared.string(from: sentDate)
        let timeLabelFont: UIFont = .boldSystemFont(ofSize: 10)
        let timeLabelColor: UIColor
        if #available(iOS 13, *) {
            timeLabelColor = .systemGray
        } else {
            timeLabelColor = .darkGray
        }
        return NSAttributedString(string: sentDateString, attributes: [NSAttributedString.Key.font: timeLabelFont, NSAttributedString.Key.foregroundColor: timeLabelColor])
    }
    
    func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
    
    func photoCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
    
    func locationCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
    
    func audioCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
    
    func contactCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
    
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        fatalError(MessageKitError.customDataUnresolvedCell)
    }

    func typingIndicator(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        return messagesCollectionView.dequeueReusableCell(TypingIndicatorCell.self, for: indexPath)
    }
}
