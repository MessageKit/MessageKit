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
import CoreGraphics
import UIKit

/// A protocol used to represent the data for a link preview message.
public protocol LinkItem {

    /// A link item needs a message to present, it can be a simple String or
    /// a NSAttributedString, but only one will be shown.
    /// LinkItem.text has priority over LinkeItem.attributedText.

    /// The message text.
    var text: String? { get }

    /// The message attributed text.
    var attributedText: NSAttributedString? { get }

    /// The URL.
    var url: URL { get }

    /// The title.
    var title: String? { get }

    /// The teaser text.
    var teaser: String { get }

    /// The thumbnail image.
    var thumbnailImage: UIImage { get }
}

public extension LinkItem {
    var textKind: MessageKind {
        let kind: MessageKind
        if let text = self.text {
            kind = .text(text)
        } else if let attributedText = self.attributedText {
            kind = .attributedText(attributedText)
        } else {
            fatalError("LinkItem must have \"text\" or \"attributedText\"")
        }
        return kind
    }
}
