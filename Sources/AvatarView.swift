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

import Foundation

open class AvatarView: UIView {

    // MARK: - Properties

    open var avatar: Avatar = Avatar()
    open var imageView = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    convenience public init() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.init(frame: frame)
        prepareView()
    }
    
    private func getImageFrom(initals: String, withColor color: UIColor = UIColor.white, fontSize: CGFloat = 14) -> UIImage {
        _ = UIGraphicsBeginImageContext(CGSize(width: 30, height: 30))
        let context = UIGraphicsGetCurrentContext()!
        
        //// Text Drawing
        let textRect = CGRect(x: 5, y: 6, width: 20, height: 20)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = initals.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        initals.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        guard let renderedImage = UIGraphicsGetImageFromCurrentImageContext() else { assertionFailure("Could not create image from context"); return UIImage()}
        return renderedImage
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    internal func prepareView() {
        setBackground(color: UIColor.gray)
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = frame
        imageView.image = avatar.image ?? getImageFrom(initals: avatar.initals)
        setCorner(radius: nil)
    }
    
    // MARK: - Open setters
    
    open func set(avatar: Avatar) {
        imageView.image = avatar.image ?? getImageFrom(initals: avatar.initals)
    }
    
    open func setBackground(color: UIColor) {
        backgroundColor = color
    }
    
    open func setCorner(radius: CGFloat?) {
        guard let radius = radius else {
            //if corner radius not set default to Circle
            layer.cornerRadius = frame.height/2
            return
        }
        layer.cornerRadius = radius
    }
    
    // MARK: - Open getters
    
    open func getImage() -> UIImage? {
        return imageView.image
    }
}
