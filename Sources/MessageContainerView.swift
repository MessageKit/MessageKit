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

    var style: MessageStyle = .none {
        didSet {
            // ***** IMPORTANT ********
            // do not check against oldValue and skip updating as the view gets created in cell and it is dequeued,
            // it gets created for a limited number of times but gets used many times,
            // therefore we need to draw it each time the style is set
            // DO NOT DO THIS --> guard style != oldValue else { return }
            setNeedsDisplay()
        }
    }

    fileprivate var tailHeight: CGFloat!
    fileprivate var tailWidth: CGFloat!

    open override func draw(_ rect: CGRect) {
        switch style {
        case .bubble(let border, let tailStyle):
            tailHeight = border.cornerRadius
            tailWidth = border.cornerRadius / 2
            drawBubble(in: rect, with: border, using: tailStyle)
        case .none:
            self.layer.cornerRadius = 0
            self.layer.masksToBounds = false
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
        }
    }

    private func drawBubble(in rect: CGRect, with border: MessageBorder, using tailStyle: MessageBubbleTailStyle) {
        let tailPath: UIBezierPath
        let outlinePath: UIBezierPath
        let bubbleTailBorder: MessageBorder?

        switch tailStyle {
        case .none:
            tailPath = UIBezierPath()
            outlinePath = UIBezierPath(roundedRect: rect, cornerRadius: border.cornerRadius)
            bubbleTailBorder = nil
        case .triangle(let corner, let tailBorder):
            (tailPath, outlinePath) = createTriangleTailedBubble(for: rect, with: border, for: corner)
            bubbleTailBorder = tailBorder
        case .tailCurved(let corner, let tailBorder):
            (tailPath, outlinePath) = createTailCurvedTailedBubble(for: rect, with: border, for: corner)
            bubbleTailBorder = tailBorder
        }

        border.fillColor.setFill()
        outlinePath.fill()

        if let bubbleTailBorder = bubbleTailBorder {
            bubbleTailBorder.fillColor.setFill()
            tailPath.fill()
            if let outlineColor = bubbleTailBorder.color {
                outlineColor.setStroke()
                tailPath.lineWidth = bubbleTailBorder.width
                tailPath.stroke()
            }
        } else {
            tailPath.fill()
        }

        if let borderColor = border.color {
            borderColor.setStroke()
            outlinePath.lineWidth = border.width
            outlinePath.stroke()
        }
    }

    private func createTriangleTailedBubble(for rect: CGRect, with border: MessageBorder, for corner: UIRectCorner) -> (tailPath: UIBezierPath, outlinePath: UIBezierPath) {
        let tailPath = UIBezierPath()
        switch corner {
        case UIRectCorner.bottomLeft:
            tailPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            tailPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY-border.cornerRadius))
            tailPath.addLine(to: CGPoint(x: rect.minX+border.cornerRadius, y: rect.maxY))
        case UIRectCorner.bottomRight:
            tailPath.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            tailPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY-border.cornerRadius))
            tailPath.addLine(to: CGPoint(x: rect.maxX-border.cornerRadius, y: rect.maxY))
        case UIRectCorner.topLeft:
            tailPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
            tailPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY+border.cornerRadius))
            tailPath.addLine(to: CGPoint(x: rect.minX+border.cornerRadius, y: rect.minY))
        case UIRectCorner.topRight:
            tailPath.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            tailPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+border.cornerRadius))
            tailPath.addLine(to: CGPoint(x: rect.maxX-border.cornerRadius, y: rect.minY))
        default:
            fatalError("FATAL ERROR unhandled UIRectCorner")
        }

        tailPath.close()
        let outlinePath = UIBezierPath(roundedRect: rect,
                                       byRoundingCorners: [.allCorners],
                                       cornerRadii: CGSize(width: border.cornerRadius, height: 0))
        return (tailPath, outlinePath)
    }

}

// MARK: - Style 1 related
extension MessageContainerView {
    fileprivate func createTailCurvedTailedBubble(for rect: CGRect, with border: MessageBorder, for corner: UIRectCorner) -> (tailPath: UIBezierPath, outlinePath: UIBezierPath) {
        let tailPath: UIBezierPath
        let insetRect: CGRect

        switch corner {
        case UIRectCorner.bottomLeft:
            let widthInset = UIEdgeInsets(top: 0, left: tailWidth, bottom: 0, right: 0)
            insetRect = UIEdgeInsetsInsetRect(rect, widthInset)
            tailPath = tailCurvedTailPathForBottomLeft(using: insetRect)

        case UIRectCorner.bottomRight:
            let widthInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tailWidth)
            insetRect = UIEdgeInsetsInsetRect(rect, widthInset)
            tailPath = tailCurvedTailPathForBottomLeft(using: insetRect)
            tailPath.mirrorOnXAxis(in: insetRect)

        case UIRectCorner.topLeft:
            let widthInset = UIEdgeInsets(top: 0, left: tailWidth, bottom: 0, right: 0)
            insetRect = UIEdgeInsetsInsetRect(rect, widthInset)
            tailPath = tailCurvedTailPathForTopLeft(using: insetRect)

        case UIRectCorner.topRight:
            let widthInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tailWidth)
            insetRect = UIEdgeInsetsInsetRect(rect, widthInset)
            tailPath = tailCurvedTailPathForTopLeft(using: insetRect)
            tailPath.mirrorOnXAxis(in: insetRect)

        default: fatalError("FATAL ERROR unhandled UIRectCorner")
        }

        let outlinePath = UIBezierPath(roundedRect: insetRect,
                                       byRoundingCorners: [.allCorners],
                                       cornerRadii: CGSize(width: border.cornerRadius, height: 0))
        return (tailPath, outlinePath)

    }

    private func tailCurvedTailPathForBottomLeft(using insetRect: CGRect) -> UIBezierPath {
        let tailPath = UIBezierPath()
        let tailStartPoint = CGPoint(x: insetRect.minX, y: insetRect.maxY - tailHeight)
        let tailBottomPoint = CGPoint(x: insetRect.minX - tailWidth, y: insetRect.maxY)
        let controlPoint1 = CGPoint(x: tailHeight/2, y: insetRect.maxY - tailWidth)
        tailPath.move(to: tailStartPoint)
        tailPath.addQuadCurve(to: tailBottomPoint, controlPoint: controlPoint1)
        let tailMiddlePoint = CGPoint(x: tailWidth * 2, y: insetRect.maxY - ((tailWidth * 2)/3))
        let controlPoint2 = CGPoint(x: tailWidth, y: insetRect.maxY - 1)
        tailPath.addQuadCurve(to: tailMiddlePoint, controlPoint: controlPoint2)
        tailPath.close()
        return tailPath
    }

    private func tailCurvedTailPathForTopLeft(using insetRect: CGRect) -> UIBezierPath {
        let tailPath = UIBezierPath()
        let tailStartPoint = CGPoint(x: insetRect.minX, y: insetRect.minY + tailHeight)
        let tailBottomPoint = CGPoint(x: insetRect.minX - tailWidth, y: insetRect.minY)
        let controlPoint1 = CGPoint(x: tailHeight/2, y: insetRect.minY + tailWidth)
        tailPath.move(to: tailStartPoint)
        tailPath.addQuadCurve(to: tailBottomPoint, controlPoint: controlPoint1)
        let tailMiddlePoint = CGPoint(x: tailWidth * 2, y: insetRect.minY + ((tailWidth * 2)/3))
        let controlPoint2 = CGPoint(x: tailWidth, y: insetRect.minY + 1)
        tailPath.addQuadCurve(to: tailMiddlePoint, controlPoint: controlPoint2)
        tailPath.close()
        return tailPath
    }

}

public enum MessageBubbleTailStyle {
    case none
    case triangle(corner: UIRectCorner, border: MessageBorder)
    case tailCurved(corner: UIRectCorner, border: MessageBorder)       // we should find a proper name for this

    public static let styleCount = 2
}

extension MessageBubbleTailStyle: CustomDebugStringConvertible {
    public var name: String {
        switch self {
        case .none: return "None"
        case .triangle: return "Triangle"
        case .tailCurved: return "TailCurved"
        }
    }

    public var debugDescription: String {
        switch self {
        case .triangle(let corner, let border):
            return "name: \(name), corner: \(corner), border: \(border)"
        case .tailCurved(let corner):
            return "name: \(name), corner: \(corner)"
        default:
            return "name: \(name)"
        }
    }
}

public struct MessageBorder {
    let color: UIColor?
    let width: CGFloat
    let cornerRadius: CGFloat
    let fillColor: UIColor

    public init(cornerRadius: CGFloat = 15, color: UIColor? = nil, width: CGFloat = 0, fillColor: UIColor) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor
    }
}

extension MessageBorder: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "color: \(color.debugDescription), width: \(width), cornerRadius: \(cornerRadius)"
    }
}

public enum MessageStyle {
    case none
    case bubble(border: MessageBorder, withTail: MessageBubbleTailStyle)
}

extension MessageStyle {
    public var name: String {
        switch self {
        case .bubble: return "Bubble"
        case .none: return "None"
        }
    }
}

extension MessageStyle: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .bubble(let border, let tailStyle):
            return "MessageStyle: Bubble, border: \(border.debugDescription), tailStyle: \(tailStyle.debugDescription)"
        case .none:
            return "MessageStyle: none"
        }
    }
}

extension MessageStyle: Equatable {
    static public func == (lhs: MessageStyle, rhs: MessageStyle) -> Bool {
        return lhs.name == rhs.name
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

public extension UIBezierPath {
    public func mirrorOnXAxis(in rect: CGRect) {
        apply(CGAffineTransform(translationX: -rect.origin.x, y: 0))
        apply(CGAffineTransform(scaleX: -1, y: 1))
        apply(CGAffineTransform(translationX: rect.origin.x+rect.width, y: 0))
    }
}
