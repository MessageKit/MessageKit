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

internal extension UIColor {

    private static func colorFromAssetBundle(named: String) -> UIColor {
        guard let color = UIColor(named: named, in: Bundle.messageKitAssetBundle(), compatibleWith: nil) else {
            fatalError(MessageKitError.couldNotLoadAssetsBundle)
        }
        return color
    }
    
    static var incomingMessageBackground: UIColor { colorFromAssetBundle(named: "incomingMessageBackground") }

    static var outgoingMessageBackground: UIColor { colorFromAssetBundle(named: "outgoingMessageBackground") }
    
    static var incomingMessageLabel: UIColor { colorFromAssetBundle(named: "incomingMessageLabel") }
    
    static var outgoingMessageLabel: UIColor { colorFromAssetBundle(named: "outgoingMessageLabel") }

    static var sendButtonBlue: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemBlue
        } else {
            return UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
        }
    }

    static var backgroundColor: UIColor {
        if #available(iOS 13, *) {
            return systemBackground
        } else {
            return white
        }
    }

    static var labelColor: UIColor {
        if #available(iOS 13, *) {
            return label
        } else {
            return black
        }
    }
    

    static var placeholderTextColor: UIColor {
        if #available(iOS 13, *) {
            return placeholderText
        } else {
            return .darkGray
        }
    }

    static var grayColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        } else {
            return gray
        }
    }

    static var darkTextColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        } else {
            return darkText
        }
    }

    static var lightGrayColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray5
        } else {
            return .lightGray
        }
    }
}

