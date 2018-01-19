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
public enum MessageData {

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

}
