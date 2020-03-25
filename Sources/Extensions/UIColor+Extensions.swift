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

    static var incomingGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGray5
        } else {
            return UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
        }
    }

    static var outgoingGreen: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGreen
        } else {
            return UIColor(red: 69/255, green: 214/255, blue: 93/255, alpha: 1.0)
        }
    }

    static var inputBarGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGray2
        } else {
            return UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        }
    }

    static var playButtonLightGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGray6
        } else {
            return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        }
    }

    static var sendButtonBlue: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemBlue
        } else {
            return UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
        }
    }
}

internal extension UIColor {

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

