/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
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
import MapKit

/// A protocol used by the `MessagesViewController` to customize the appearance of a `MessageCollectionViewCell`.
public protocol MessagesDisplayDelegate: AnyObject {

    // MARK: - All Messages

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
    
    /// Configure `AvatarView`‘s image.
    ///
    /// - Parameters:
    ///   - avatarView: The `AvatarView` of the cell.
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default image configured by this method is `?`.
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    // MARK: - Text Messages

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

    /// Specifies the attributes for a given `DetectorType`
    ///
    /// - Parameters:
    ///   - detector: The `DetectorType` for the applied attributes.
    ///   - message: A `MessageType` with a `MessageData` case of `.text` or `.attributedText`
    ///   to which the detectors will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any]

    // MARK: - Location Messages

    /// Ask the delegate for a LocationMessageSnapshotOptions instance to customize the MapView on the given message
    ///
    /// - Parameters:
    ///   - message: The location message to be customized
    ///   - indexPath: Message's index path
    ///   - messagesCollectionView: The collection view requesting the information
    /// - Returns: Your LocationMessageSnapshotOptions instance with the options to customize map style
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions

    /// Ask the delegate for a custom MKAnnotationView to show on the given message.
    /// You can return nil if you don't want to show any annotation.
    ///
    /// default: MKPinAnnotationView
    ///
    /// - Parameters:
    ///   - message: The location message with the annotation to customize
    ///   - indexPath: Message's index path
    ///   - messageCollectionView: The collection view requesting the information
    /// - Returns: Your customized MKAnnotationView or nil to not show any.
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView?

    /// Ask the delegate for a custom animation block to run when whe map screenshot is ready to be displaied in the given location message
    /// The animation block is called with the image view to be animated. You can animate it with CoreAnimation, UIView.animate or any library you prefer.
    ///
    /// default: nil
    ///
    /// - Parameters:
    ///   - message: The location message with the map to animate
    ///   - indexPath: Message's index path
    ///   - messagesCollectionView: The collection view requesting the information
    /// - Returns: Your customized animation block.
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)?
}

public extension MessagesDisplayDelegate {

    // MARK: - All Messages Defaults

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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.initials = "?"
    }

    // MARK: - Text Messages Defaults

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return dataSource.isFromCurrentSender(message: message) ? .white : .darkText
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return []
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
        return MessageLabel.defaultAttributes
    }

    // MARK: - Location Messages Defaults

    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        return LocationMessageSnapshotOptions()
    }

    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        return MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
    }

    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return nil
    }

}
