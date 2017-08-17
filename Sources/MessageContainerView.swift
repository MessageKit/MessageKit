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

open class MessageContainerView: UIView {

    func setStyle(_ style: MessageStyle) {
        switch style {
        case .bubble(let cornerRadius):
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        case .bubbleOutline(let thickness, let color, let cornerRadius):
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.borderWidth = thickness
            self.layer.borderColor = color.cgColor
        case .bubbleTailed(let edge, let cornerRadius):
            fatalError(".bubbleTailed is not currently supported")
        case .bubbleTailedOutline(let thickness, let color, let cornerRadius, let edge):
            fatalError(".bubbleTailedOutline is not currently supported")
        case .none:
            self.layer.cornerRadius = 0
            self.layer.masksToBounds = false
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
        }
    }

}

public enum MessageStyle {

    case bubble(cornerRadius: CGFloat)
    case bubbleOutline(thickness: CGFloat, color: UIColor, cornerRadius: CGFloat)
    case bubbleTailed(edge: CGRectEdge, cornerRadius: CGFloat)
    case bubbleTailedOutline(thickness: CGFloat, color: UIColor, cornerRadius: CGFloat, edge: CGRectEdge)
    case none
}

