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

struct MockMessage: MessageType {

    var messageId: String
    var sender: Sender
    var sentDate: Date
    var data: MessageData

    private init(data: MessageData, sender: Sender, messageId: String) {
        self.data = data
        self.sender = sender
        self.messageId = messageId
        self.sentDate = Date()
    }

    init(text: String, sender: Sender, messageId: String) {
        self.init(data: .text(text), sender: sender, messageId: messageId)
    }

    init(attributedText: NSAttributedString, sender: Sender, messageId: String) {
        self.init(data: .attributedText(attributedText), sender: sender, messageId: messageId)
    }

    init(image: UIImage, sender: Sender, messageId: String) {
        self.init(data: .photo(image), sender: sender, messageId: messageId)
    }

    init(thumbnail: UIImage, sender: Sender, messageId: String) {
        let url = URL(fileURLWithPath: "")
        self.init(data: .video(file: url, thumbnail: thumbnail), sender: sender, messageId: messageId)
    }

    init(location: CLLocation, sender: Sender, messageId: String) {
        self.init(data: .location(location), sender: sender, messageId: messageId)
    }

    init(emoji: String, sender: Sender, messageId: String) {
        self.init(data: .emoji(emoji), sender: sender, messageId: messageId)
    }

}
