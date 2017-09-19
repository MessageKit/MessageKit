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
import MapKit

open class LocationMessageCell: MessageCollectionViewCell<UIImageView> {

    override open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        switch message.data {
        case .location(let location):
            guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else { return }

            let options = displayDelegate.snapshotOptionsForLocation(message: message, at: indexPath, in: messagesCollectionView)
            let snapshotOptions = MKMapSnapshotOptions()

            snapshotOptions.scale = options.scale
            snapshotOptions.region = MKCoordinateRegion(center: location.coordinate, span: options.span)
            snapshotOptions.size = messageContainerView.frame.size
            snapshotOptions.showsBuildings = options.showsBuildings
            snapshotOptions.showsPointsOfInterest = options.showsPointsOfInterest

            let snapShotter = MKMapSnapshotter(options: snapshotOptions)
            snapShotter.start { (snapshot: MKMapSnapshot?, error: Error?) in
                if error == nil { self.messageContentView.image = snapshot?.image }
            }
        default:
            break
        }
    }

}
