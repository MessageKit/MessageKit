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

open class MessagesAvatarImageFactory {
    // MARK: - Properties
    
    private let diameter: Int
    
    // MARK: - Initializer
    
    public init(diameter: Int = 30) {
        self.diameter = diameter
    }
    
    // MARK: - Public
    
    public func avatarImage(withPlaceholder placeholderImage: UIImage) -> Avatar {
        let circlePlaceholderImage = circularImage(placeholderImage, highlightedColor: nil)
        
        return Avatar.avatar(withPlaceholder: circlePlaceholderImage)
    }
    
    public func avatarImage(withImage image: UIImage) -> Avatar {
        let avatar = circularAvatarImage(image)
        let highlightedAvatar = circularAvatarHighlightedImage(image)
        
        return Avatar(image: avatar, highlightedImage: highlightedAvatar, placeholderImage: avatar)
    }
    
    public func avatarImage(withInitials initials: String = "?",
                            backgroundColor: UIColor,
                            textColor: UIColor,
                            font: UIFont) -> Avatar {
        let avatarImage = image(withInitials: initials, backgroundColor: backgroundColor, textColor: textColor, font: font)
        let avatarHighlightedImage = circularImage(avatarImage, highlightedColor: UIColor.avatarHighlightedColor)
        
        return Avatar(image: avatarImage, highlightedImage: avatarHighlightedImage, placeholderImage: avatarImage)
    }
    
    public func circularAvatarImage(_ image: UIImage) -> UIImage {
        return circularImage(image, highlightedColor: nil)
    }
    
    public func circularAvatarHighlightedImage(_ image: UIImage) -> UIImage {
        return circularImage(image, highlightedColor: UIColor.avatarHighlightedColor)
    }
    
    // MARK: - Private
    
    private func image(withInitials initials: String,
                       backgroundColor: UIColor,
                       textColor: UIColor,
                       font: UIFont) -> UIImage {
        let frame = CGRect(0, 0, self.diameter, self.diameter)
        let attributes: [NSAttributedStringKey: Any] = [.font: font,
                                                        .foregroundColor: textColor]
        
        let textFrame = initials.boundingRect(with: frame.size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        let frameMidPoint = CGPoint(x: frame.midX, y: frame.midY)
        let textFrameMidPoint = CGPoint(x: textFrame.midX, y: textFrame.midY)
        
        let dx = frameMidPoint.x - textFrameMidPoint.x
        let dy = frameMidPoint.y - textFrameMidPoint.y
        let drawPoint = CGPoint(x: dx, y: dy)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(frame)
        initials.draw(at: drawPoint, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        return circularImage(image, highlightedColor: nil)
    }
    
    private func circularImage(_ image: UIImage, highlightedColor: UIColor?) -> UIImage {
        let frame = CGRect(0, 0, self.diameter, self.diameter)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        
        let imgPath = UIBezierPath(ovalIn: frame)
        imgPath.addClip()
        image.draw(in: frame)
        
        if let highlightedColor = highlightedColor {
            context?.setFillColor(highlightedColor.cgColor)
            context?.fillEllipse(in: frame)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        return image
    }
    
}
