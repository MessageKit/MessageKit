/*
 MIT License

 Copyright (c) 2017-2020 MessageKit

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
import CoreLocation
import AVFoundation
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

private struct MockAudiotem: AudioItem {

    var url: URL
    var size: CGSize
    var duration: Float

    init(url: URL, duration: Float) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        self.duration = duration
    }

}

struct MockLinkItem: LinkItem {
    let text: String?
    let attributedText: NSAttributedString?
    let url: URL
    let title: String?
    let teaser: String
    let thumbnailImage: UIImage
}

struct MockMessage: MessageType {

    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind
    var user: MockUser

    private init(kind: MessageKind, user: MockUser, messageId: String) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = Date()
    }

    init(text: String, user: MockUser, messageId: String) {
        self.init(kind: .text(text), user: user, messageId: messageId)
    }

    init(attributedText: NSAttributedString, user: MockUser, messageId: String) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId)
    }

    init(image: UIImage, user: MockUser, messageId: String) {
        let mediaItem = MockMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId)
    }

    init(thumbnail: UIImage, user: MockUser, messageId: String) {
        let mediaItem = MockMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId)
    }

    init(location: CLLocation, user: MockUser, messageId: String) {
        let locationItem = MockLocationItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId)
    }

    init(emoji: String, user: MockUser, messageId: String) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId)
    }

    init(audioURL: URL, duration: Float, user: MockUser, messageId: String) {
        let audioItem = MockAudiotem(url: audioURL, duration: duration)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId)
    }

    init(linkItem: LinkItem, user: MockUser, messageId: String) {
        self.init(kind: .linkPreview(linkItem), user: user, messageId: messageId)
    }
}
