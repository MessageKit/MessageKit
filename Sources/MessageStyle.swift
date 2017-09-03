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

public enum MessageStyle {

    case none
    case bubble
    case bubbleOutline
    case bubbleTail(TailCorner)
    case bubbleTailOutline(TailCorner)

    public var image: UIImage? {

        guard let path = imagePath else { return nil }

        guard var image = UIImage(contentsOfFile: path) else { return nil }

        switch self {
        case .none:
            return nil
        case .bubble, .bubbleOutline:
            break
        case .bubbleTail(let corner), .bubbleTailOutline(let corner):
            guard let cgImage = image.cgImage else { return nil }
            image = UIImage(cgImage: cgImage, scale: image.scale, orientation: corner.imageOrientation)
        }

        return stretch(image).withRenderingMode(.alwaysTemplate)
    }

    private var imageName: String? {
        switch self {
        default: return "bubble_tailed"
        }
    }

    private var imagePath: String? {
        guard let imageName = imageName else { return nil }
        let assetBundle = Bundle.messageKitAssetBundle()
        return assetBundle.path(forResource: imageName, ofType: "png", inDirectory: "Images")
    }

    private func stretch(_ image: UIImage) -> UIImage {
        let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
        let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }

}
