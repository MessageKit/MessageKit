//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://messagekit.github.io
//
//
//  GitHub
//  https://github.com/MessageKit/MessageKit
//
//
//  License
//  Copyright (c) 2016-present Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import CoreLocation


public struct Sender {

    public let id: String

    public let displayName: String
}


extension Sender: Equatable {
    static public func ==(left: Sender, right: Sender) -> Bool {
        return left.id == right.id
    }
}


public enum MessageData {

    case text(String)

    case attributedText(NSAttributedString)

    case audio(Data)

    case location(CLLocation)

    case photo(UIImage)

    case video(file: NSURL, thumbnail: UIImage)

    case system(String)

    case custom(Any)

    case placeholder
}


public protocol MessageType {

    var sender: Sender { get }

    var messageId: String { get }

    var sentDate: Date { get }

    var data: MessageData { get }
}
