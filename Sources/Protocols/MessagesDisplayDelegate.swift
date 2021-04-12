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

import Foundation
import UIKit
import MapKit

/// A protocol used by the `MessagesViewController` to customize the appearance of a `MessageContentCell`.
public protocol MessagesDisplayDelegate: AnyObject {

    // MARK: - All Messages

    /// Specifies the `MessageStyle` to be used for a `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is `MessageStyle.bubble`.
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle

    /// Specifies the background color of the `MessageContainerView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value is `UIColor.clear` for emoji messages.
    ///   For all other `MessageKind` cases, the color depends on the `SenderType`.
    ///
    ///   Current sender: Green
    ///
    ///   All other senders: Gray
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// The section header to use for a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed for this header.
    ///   - indexPath: The `IndexPath` of the header.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this header will be displayed.
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView

    /// The section footer to use for a given `IndexPath`.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` of the footer.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this footer will be displayed.
    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView
    
    /// Used to configure the `AvatarView`‘s image in a `MessageContentCell` class.
    ///
    /// - Parameters:
    ///   - avatarView: The `AvatarView` of the cell.
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default image configured by this method is `?`.
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    /// Used to configure the `AccessoryView` in a `MessageContentCell` class.
    ///
    /// - Parameters:
    ///   - accessoryView: The `AccessoryView` of the cell.
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default image configured by this method is `?`.
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    // MARK: - Text Messages

    /// Specifies the color of the text for a `TextMessageCell`.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageKind` case of `.text` to which the color will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is determined by the messages `SenderType`.
    ///
    ///   Current sender: UIColor.white
    ///
    ///   All other senders: UIColor.darkText
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// Specifies the `DetectorType`s to check for the `MessageType`'s text against.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageKind` case of `.text` or `.attributedText` to which the detectors will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   This method returns an empty array by default.
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType]

    /// Specifies the attributes for a given `DetectorType`
    ///
    /// - Parameters:
    ///   - detector: The `DetectorType` for the applied attributes.
    ///   - message: A `MessageType` with a `MessageKind` case of `.text` or `.attributedText` to which the detectors will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any]

    // MARK: - Location Messages

    /// Used to configure a `LocationMessageSnapshotOptions` instance to customize the map image on the given location message.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageKind` case of `.location`.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` requesting the information.
    /// - Returns: The LocationMessageSnapshotOptions instance with the options to customize map style.
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions

    /// Used to configure the annoation view of the map image on the given location message.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageKind` case of `.location`.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` requesting the information.
    /// - Returns: The `MKAnnotationView` to use as the annotation view.
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView?

    /// Ask the delegate for a custom animation block to run when whe map screenshot is ready to be displaied in the given location message.
    /// The animation block is called with the `UIImageView` to be animated.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageKind` case of `.location`.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` requesting the information.
    /// - Returns: The animation block to use to apply the location image.
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)?

    // MARK: - Media Messages

    /// Used to configure the `UIImageView` of a `MediaMessageCell`.
    ///
    /// - Parameters:
    ///   - imageView: The `UIImageView` of the cell.
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)

    // MARK: - Audio Message
    
    /// Used to configure the audio cell UI:
    ///     1. play button selected state;
    ///     2. progresssView progress;
    ///     3. durationLabel text;
    ///
    /// - Parameters:
    ///   - cell: The `AudioMessageCell` that needs to be configure.
    ///   - message: The `MessageType` that configures the cell.
    ///
    /// - Note:
    ///   This protocol method is called by MessageKit every time an audio cell needs to be configure
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType)

    /// Specifies the tint color of play button and progress bar for an `AudioMessageCell`.
    ///
    /// - Parameters:
    ///   - message: A `MessageType` with a `MessageKind` case of `.audio` to which the color will apply.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value returned by this method is UIColor.sendButtonBlue
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor

    /// Used to format the audio sound duration in a readable string
    ///
    /// - Parameters:
    ///   - duration: The audio sound duration is seconds.
    ///   - audioCell: The `AudioMessageCell` that ask for formated duration.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// - Note:
    ///   The default value is computed like fallow:
    ///     1. return the time as 0:ss if duration is up to 59 seconds                         (e.g. 0:03     means 0 minutes and 3 seconds)
    ///     2. return the time as m:ss if duration is greater than 59 and lower than 3600      (e.g. 12:23    means 12 mintues and 23 seconds)
    ///     3. return the time as h:mm:ss for anything longer that 3600 seconds                (e.g. 1:19:08  means 1 hour 19 minutes and 8 seconds)
    func audioProgressTextFormat(_ duration: Float, for audioCell: AudioMessageCell, in messageCollectionView: MessagesCollectionView) -> String

    /// Used to configure the `UIImageView` of a `LinkPreviewMessageCell`.
    /// - Parameters:
    ///   - imageView: The `UIImageView` of the cell.
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    func configureLinkPreviewImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
}

public extension MessagesDisplayDelegate {

    // MARK: - All Messages Defaults

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }

    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {

        switch message.kind {
        case .emoji:
            return .clear
        default:
            guard let dataSource = messagesCollectionView.messagesDataSource else {
                return .white
            }
            return dataSource.isFromCurrentSender(message: message) ? .outgoingMessageBackground : .incomingMessageBackground
        }
    }
    
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        return messagesCollectionView.dequeueReusableHeaderView(MessageReusableView.self, for: indexPath)
    }

    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        return messagesCollectionView.dequeueReusableFooterView(MessageReusableView.self, for: indexPath)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.initials = "?"
    }

    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {}

    // MARK: - Text Messages Defaults

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return dataSource.isFromCurrentSender(message: message) ? .outgoingMessageLabel : .incomingMessageLabel
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return []
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
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

    // MARK: - Media Message Defaults

    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    }

    // MARK: - Audio Message Defaults
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        
    }

    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        return dataSource.isFromCurrentSender(message: message) ? .outgoingAudioMessageTint : .incomingAudioMessageTint
    }

    func audioProgressTextFormat(_ duration: Float, for audioCell: AudioMessageCell, in messageCollectionView: MessagesCollectionView) -> String {
        var returnValue = "0:00"
        // print the time as 0:ss if duration is up to 59 seconds
        // print the time as m:ss if duration is up to 59:59 seconds
        // print the time as h:mm:ss for anything longer
        if duration < 60 {
            returnValue = String(format: "0:%.02d", Int(duration.rounded(.up)))
        } else if duration < 3600 {
            returnValue = String(format: "%.02d:%.02d", Int(duration/60), Int(duration) % 60)
        } else {
            let hours = Int(duration/3600)
            let remainingMinutsInSeconds = Int(duration) - hours*3600
            returnValue = String(format: "%.02d:%.02d:%.02d", hours, Int(remainingMinutsInSeconds/60), Int(remainingMinutsInSeconds) % 60)
        }
        return returnValue
    }

    // MARK: - LinkPreview Message Defaults

    func configureLinkPreviewImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    }
}
