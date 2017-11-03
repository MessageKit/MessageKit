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

// MediaMessageStyle
// corner radius
// border color
// border thickness

// TextMessageStyle
// corner radius
// border color
// border thickness
// path


public protocol MessageStyle {
    
    func configure(container: MessageContainerView)
    
}

public enum TextMessageStyle: MessageStyle {
    
    public enum TailStyle {
        case curved
        case pointed
    }
    
    public enum TailCorner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    case bubble(radius: CGFloat, corners: UIRectCorner)
    case bubbleOutline(color: UIColor, thickness: CGFloat, corners: UIRectCorner, radius: CGFloat)
    case bubbleTail(TailCorner, TailStyle)
    case bubbleTailOutline(color: UIColor, thickness: CGFloat, TailCorner, TailStyle)
    case custom((MessageContainerView) -> Void)
    case none
    
    private func shapeLayer(for container: MessageContainerView) -> CAShapeLayer {
        
        var layer = CAShapeLayer()
        
        switch self {
        case let .bubble(radius, corners):
            layer = CAShapeLayer()
            let radii = CGSize(width: radius, height: radius)
            let path = UIBezierPath(roundedRect: container.bounds, byRoundingCorners: corners, cornerRadii: radii)
            layer.path = path.cgPath
            return layer
        case let .bubbleOutline(color, thickness, corners, radius):
            layer = CAShapeLayer()
            let radii = CGSize(width: radius, height: radius)
            let path = UIBezierPath(roundedRect: container.bounds, byRoundingCorners: corners, cornerRadii: radii)
            layer.path = path.cgPath
            layer.strokeColor = color.cgColor
            layer.borderWidth = thickness
            return layer
        case let .bubbleTail(corner, style):
            return layer
        case let .bubbleTailOutline(color, thickness, corner, style):
            return layer
        default:
            return layer
        }
    }
    
    public func configure(container: MessageContainerView) {
        switch self {
        case .bubble, .bubbleOutline, .bubbleTail, .bubbleTailOutline:
            container.messageShapeLayer = shapeLayer(for: container)
        case .custom(let block):
            container.messageShapeLayer.removeFromSuperlayer()
            block(container)
        case .none:
            container.messageShapeLayer.removeFromSuperlayer()
            break
        }
    }
    
}

public enum MediaMessageStyle: MessageStyle {
    
    public enum TailStyle {
        case curved
        case pointed
    }
    
    public enum TailCorner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    case bubble(radius: CGFloat, corners: UIRectCorner)
    case bubbleOutline(color: UIColor, thickness: CGFloat, corners: UIRectCorner, radius: CGFloat)
    case custom((MessageContainerView) -> Void)
    case none
    
    private func shapeLayer(for container: MessageContainerView) -> CAShapeLayer {
        
        var layer = CAShapeLayer()
        
        switch self {
        case let .bubble(radius, corners):
            layer = CAShapeLayer()
            let radii = CGSize(width: radius, height: radius)
            let path = UIBezierPath(roundedRect: container.bounds, byRoundingCorners: corners, cornerRadii: radii)
            layer.path = path.cgPath
            return layer
        case let .bubbleOutline(color, thickness, corners, radius):
            layer = CAShapeLayer()
            let radii = CGSize(width: radius, height: radius)
            let path = UIBezierPath(roundedRect: container.bounds, byRoundingCorners: corners, cornerRadii: radii)
            layer.path = path.cgPath
            layer.strokeColor = color.cgColor
            layer.borderWidth = thickness
            return layer
        default:
            return layer
        }
    }
    
    public func configure(container: MessageContainerView) {
        switch self {
        case .bubble, .bubbleOutline:
            container.messageShapeLayer = shapeLayer(for: container)
        case .custom(let block):
            block(container)
        case .none:
            break
        }
    }
    
}

//public enum MessageStyle {
//
//    // MARK: - TailCorner
//
//    public enum TailCorner {
//
//        case topLeft
//        case bottomLeft
//        case topRight
//        case bottomRight
//
//        var imageOrientation: UIImageOrientation {
//            switch self {
//            case .bottomRight: return .up
//            case .bottomLeft: return .upMirrored
//            case .topLeft: return .down
//            case .topRight: return .downMirrored
//            }
//        }
//    }
//
//    // MARK: - TailStyle
//
//    public enum TailStyle {
//
//        case curved
//        case pointedEdge
//
//        var imageNameSuffix: String {
//            switch self {
//            case .curved:
//                return "_tail_v2"
//            case .pointedEdge:
//                return "_tail_v1"
//            }
//        }
//    }
//
//    // MARK: - MessageStyle
//
//    case none
//    case bubble
//    case bubbleOutline(UIColor)
//    case bubbleTail(TailCorner, TailStyle)
//    case bubbleTailOutline(UIColor, TailCorner, TailStyle)
//    case custom((MessageContainerView) -> Void)
//
//    // MARK: - Public
//
//    public var image: UIImage? {
//
//        guard let path = imagePath else { return nil }
//
//        guard var image = UIImage(contentsOfFile: path) else { return nil }
//
//        switch self {
//        case .none, .custom:
//            return nil
//        case .bubble, .bubbleOutline:
//            break
//        case .bubbleTail(let corner, _), .bubbleTailOutline(_, let corner, _):
//            guard let cgImage = image.cgImage else { return nil }
//            image = UIImage(cgImage: cgImage, scale: image.scale, orientation: corner.imageOrientation)
//        }
//
//        return stretch(image).withRenderingMode(.alwaysTemplate)
//    }
//
//    // MARK: - Private
//
//    private var imageName: String? {
//        switch self {
//        case .bubble:
//            return "bubble_full"
//        case .bubbleOutline:
//            return "bubble_outlined"
//        case .bubbleTail(_, let tailStyle):
//            return "bubble_full" + tailStyle.imageNameSuffix
//        case .bubbleTailOutline(_, _, let tailStyle):
//            return "bubble_outlined" + tailStyle.imageNameSuffix
//        case .none, .custom:
//            return nil
//        }
//    }
//
//    private var imagePath: String? {
//        guard let imageName = imageName else { return nil }
//        let assetBundle = Bundle.messageKitAssetBundle()
//        return assetBundle.path(forResource: imageName, ofType: "png", inDirectory: "Images")
//    }
//
//    private func stretch(_ image: UIImage) -> UIImage {
//        let center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
//        let capInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
//        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
//    }
//
//}

