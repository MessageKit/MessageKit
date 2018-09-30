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

import UIKit

public enum MessageStyle {

    // MARK: - TailCorner

    public enum TailCorner: String {

        case topLeft
        case bottomLeft
        case topRight
        case bottomRight

        internal var imageOrientation: UIImage.Orientation {
            switch self {
            case .bottomRight: return .up
            case .bottomLeft: return .upMirrored
            case .topLeft: return .down
            case .topRight: return .downMirrored
            }
        }
    }

    // MARK: - TailStyle

    public enum TailStyle {

        case curved
        case pointedEdge

        internal var imageNameSuffix: String {
            switch self {
            case .curved:
                return "_tail_v2"
            case .pointedEdge:
                return "_tail_v1"
            }
        }
    }

    // MARK: - MessageStyle

    case none
    case bubble
    case bubbleOutline(UIColor)
    case bubbleTail(TailCorner, TailStyle)
    case bubbleTailOutline(UIColor, TailCorner, TailStyle)
    case custom((MessageContainerView) -> Void)

    // MARK: - Public

    public var image: UIImage? {
        
        guard let imageCacheKey = imageCacheKey, let path = imagePath else { return nil }

        let cache = MessageStyle.bubbleImageCache

        if let cachedImage = cache.object(forKey: imageCacheKey as NSString) {
            return cachedImage
        }
        guard var image = UIImage(contentsOfFile: path) else { return nil }
        
        switch self {
        case .none, .custom:
            return nil
        case .bubble, .bubbleOutline:
            break
        case .bubbleTail(let corner, _), .bubbleTailOutline(_, let corner, _):
            guard let cgImage = image.cgImage else { return nil }
            image = UIImage(cgImage: cgImage, scale: image.scale, orientation: corner.imageOrientation)
        }
        
        let stretchedImage = stretch(image)
        cache.setObject(stretchedImage, forKey: imageCacheKey as NSString)
        return stretchedImage
    }

    // MARK: - Internal
    
    internal static let bubbleImageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "com.messagekit.MessageKit.bubbleImageCache"
        return cache
    }()
    
    // MARK: - Private
    
    private var imageCacheKey: String? {
        guard let imageName = imageName else { return nil }
        
        switch self {
        case .bubble, .bubbleOutline:
            return imageName
        case .bubbleTail(let corner, _), .bubbleTailOutline(_, let corner, _):
            return imageName + "_" + corner.rawValue
        default:
            return nil
        }
    }

    private var imageName: String? {
        switch self {
        case .bubble:
            return "bubble_full"
        case .bubbleOutline:
            return "bubble_outlined"
        case .bubbleTail(_, let tailStyle):
            return "bubble_full" + tailStyle.imageNameSuffix
        case .bubbleTailOutline(_, _, let tailStyle):
            return "bubble_outlined" + tailStyle.imageNameSuffix
        case .none, .custom:
            return nil
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
