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
import MapKit

/// Conform to this protocol to customize location messages's style
public protocol LocationMessageDisplayDelegate: MessagesDisplayDelegate {

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

public extension LocationMessageDisplayDelegate {

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
