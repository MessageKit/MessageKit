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
import class CoreLocation.CLLocation

/// An enum representing the kind of message and its underlying data.
public enum MessageData: Equatable {

    /// A standard text message.
    ///
    /// NOTE: The font used for this message will be the value of the
    /// `messageLabelFont` property in the `MessagesCollectionViewFlowLayout` object.
    ///
    /// Tip: Using `MessageData.attributedText(NSAttributedString)` doesn't require you
    /// to set this property and results in higher performance.
    case text(String)
    
    /// A message with attributed text.
    case attributedText(NSAttributedString)

    /// A photo message.
    case photo(UIImage)

    /// A video message.
    case video(file: URL, thumbnail: UIImage)

    /// A location message.
    case location(CLLocation)

    /// An emoji message.
    case emoji(String)

    // MARK: - Not supported yet

//    case audio(Data)
//
//    case system(String)
//    
//    case custom(Any)
//    
//    case placeholder

    // MARK: - Equatable

    public static func ==(lhs: MessageData, rhs: MessageData) -> Bool {
        switch (lhs, rhs) {
        case (let .text(string1), let .text(string2)):
            return true

        case (let .attributedText(string1), let .attributedText(string2)):
            return true

        case (let .photo(image1), let .photo(image2)):
             return true

        case (let .video(file: url1, thumbnail: thumbnail1), let .video(file: url2, thumbnail: thumbnail2)):
            return true

        case (let .location(location1), let .location(location2)):
            return true

        case (let .emoji(string1), let .emoji(string2)):
            return true

        default:
            return false
        }
    }
}

extension MessageData: RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        switch rawValue {
        case "text": self = .text("")
        case "attributedText": self = .attributedText(NSAttributedString())
        case "photo": self = .photo(UIImage())
        case "video": self = .video(file: URL(string: "")!, thumbnail: UIImage())
        case "emoji": self = .emoji("")
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case let .text(string1):
            return "text"

        case let .attributedText(string1):
            return "attributedText"

        case let .photo(image1):
            return "photo"

        case let .video(file: url1, thumbnail: thumbnail1):
            return "video"

        case let .location(location1):
            return "location"

        case let .emoji(string1):
            return "emoji"
        }
    }
}
