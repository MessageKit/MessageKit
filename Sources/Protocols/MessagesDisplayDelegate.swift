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

/// A protocol used by the `MessagesViewController` to customize the appearance of a `TextMessageCell`.
public protocol TextMessageDisplayDelegate: AnyObject {

    /// Specifies the color of the text for a `TextMessageCell`.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageData` case of `.text` or `.attributedText` to which the color will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is determined by the messages `Sender`:
    ///
    /// Current Sender: UIColor.white
    ///
    /// All other Senders: UIColor.darkText
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// Specifies the `DetectorType`s to check for the `MessageType`'s text against.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageData` case of `.text` or `.attributedText` to which the detectors will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is all available detector types.
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType]

}

public extension TextMessageDisplayDelegate {

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .darkText }
        return dataSource.isFromCurrentSender(message: message) ? .white : .darkText
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return []
    }

}

/// A protocol used by the `MessagesViewController` to customize the appearance of a `MessagesCollectionViewCell`.
public protocol MessagesDisplayDelegate: AnyObject {

    /// Specifies the `MessageStyle` to be used for a `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `MessageStyle.bubble`.
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle

    /// Specifies the background color of the `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value is `UIColor.clear` for emoji messages. For all other `MessageData` cases, the color depends on the `Sender`:
    ///
    /// Current Sender: Green
    ///
    /// All other Senders: Gray
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// The section header to use for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this header.
    ///   - indexPath: The `IndexPath` of the header.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this header will be displayed.
    ///
    /// The default value returned by this method is a `MessageDateHeaderView`.
    func messageHeaderView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageHeaderView

    /// Used by the `MessageLayoutDelegate` method `headerViewSize(_:_:_:)` to determine if a header should be displayed.
    /// This method checks `MessageCollectionView`'s `showsDateHeaderAfterTimeInterval` property and returns true if
    /// the current messages sent date occurs after the specified time interval when compared to the previous message.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this header.
    ///   - indexPath: The `IndexPath` of the header.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this header will be displayed.
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool

    /// The section footer to use for a given `MessageType`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this footer.
    ///   - indexPath: The `IndexPath` of the footer.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this footer will be displayed.
    ///
    /// The default value returned by this method is a `MessageFooterView`.
    func messageFooterView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageFooterView

}

public extension MessagesDisplayDelegate {

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }

    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {

        switch message.data {
        case .emoji:
            return .clear
        default:
            guard let dataSource = messagesCollectionView.messagesDataSource else { return .white }
            return dataSource.isFromCurrentSender(message: message) ? .outgoingGreen : .incomingGray
        }
    }
    
    func messageHeaderView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageHeaderView {
        let header = messagesCollectionView.dequeueReusableHeaderView(MessageDateHeaderView.self, for: indexPath)
        header.dateLabel.text = MessageKitDateFormatter.shared.string(from: message.sentDate)
        return header
    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return false }
        if indexPath.section == 0 { return false }
        let previousSection = indexPath.section - 1
        let previousIndexPath = IndexPath(item: 0, section: previousSection)
        let previousMessage = dataSource.messageForItem(at: previousIndexPath, in: messagesCollectionView)
        let timeIntervalSinceLastMessage = message.sentDate.timeIntervalSince(previousMessage.sentDate)
        return timeIntervalSinceLastMessage >= messagesCollectionView.showsDateHeaderAfterTimeInterval
    }

    func messageFooterView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageFooterView {
        return messagesCollectionView.dequeueReusableFooterView(MessageFooterView.self, for: indexPath)
    }

}
