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

    internal var initalsLabel = UILabel()
    internal var imageView = UIImageView()
    internal var initals: String = "?"

    // MARK: - initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    convenience public init(size: CGFloat = 30, image: UIImage? = nil, highlightedImage: UIImage? = nil, initals inInitals: String = "?", cornerRounding: CGFloat? = nil) {
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.init(frame: frame)
        roundCorners(by: cornerRounding)
        setBackground(color: UIColor.gray)
        imageView.image = image
        imageView.highlightedImage = highlightedImage
        initals = inInitals
        prepareView()
    }

    convenience public init() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.init(frame: frame)
        setBackground(color: UIColor.gray)
        roundCorners(by: nil)
        prepareView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal methods

    internal func prepareView() {
        prepareInitalsLabel()
        prepareImageView()
        imageView.isHidden = imageView.image == nil
    }

    internal func prepareInitalsLabel() {
        initalsLabel.text = initals
        initalsLabel.textAlignment = .center
        setInitalsFont()
        addSubview(initalsLabel)
        initalsLabel.center = center
        initalsLabel.frame = frame
    }

    internal func prepareImageView() {
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = frame
    }

    // MARK: - Open methods

    open func set(image: UIImage) {
        imageView.image = image
    }

    open func setInitalsFont(size: CGFloat = 16, color: UIColor = .white) {
        initalsLabel.font = UIFont.systemFont(ofSize: size)
        initalsLabel.textColor = color
    }

    open func setBackground(color: UIColor) {
        backgroundColor = color
    }

    open func getImage() -> UIImage? {
        return imageView.image
    }

    open func roundCorners(by radius: CGFloat?) {
        //if corner radius not set default to Circle
        layer.cornerRadius = radius ?? frame.height/2
    }
}
