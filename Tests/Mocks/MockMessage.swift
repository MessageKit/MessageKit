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
import CoreLocation
@testable import MessageKit

struct MockLocationItem: LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }

}

struct MockMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

}

struct MockMessage: MessageType {

    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind

    private init(kind: MessageKind, sender: Sender, messageId: String) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = Date()
    }

    init(text: String, sender: Sender, messageId: String) {
        self.init(kind: .text(text), sender: sender, messageId: messageId)
    }

    init(attributedText: NSAttributedString, sender: Sender, messageId: String) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId)
    }

    init(image: UIImage, sender: Sender, messageId: String) {
        let mediaItem = MockMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId)
    }

    init(thumbnail: UIImage, sender: Sender, messageId: String) {
        let mediaItem = MockMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId)
    }

    init(location: CLLocation, sender: Sender, messageId: String) {
        let locationItem = MockLocationItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId)
    }

    init(emoji: String, sender: Sender, messageId: String) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId)
    }

}
