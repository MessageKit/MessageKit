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

open class PlayButtonView: UIView {

    override open var frame: CGRect {
        didSet {
            commonSetup()
        }
    }

    let triangleView: UIView = {
        let triangleView = UIView()
        triangleView.layer.masksToBounds = true
        triangleView.clipsToBounds = true
        return triangleView
    }()

    func triangleMask(for frame: CGRect) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()
        let point1 = CGPoint(x: frame.minX, y: frame.minY)
        let point2 = CGPoint(x: frame.maxX, y: frame.maxY/2)
        let point3 = CGPoint(x: frame.minX, y: frame.maxY)
        trianglePath .move(to: point1)
        trianglePath .addLine(to: point2)
        trianglePath .addLine(to: point3)
        trianglePath .close()
        shapeLayer.path = trianglePath.cgPath
        return shapeLayer
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        commonSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        addSubview(triangleView)
    }

    func commonSetup() {

        let size = CGSize(width: frame.width/2, height: frame.height/2)
        triangleView.bounds.size = size
        triangleView.layer.mask = triangleMask(for: triangleView.bounds)

        let centerOffset = triangleView.bounds.width/8
        triangleView.center = CGPoint(x: center.x + centerOffset, y: center.y)

        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }

}

open class MediaMessageCell: MessageCollectionViewCell<UIImageView> {

    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        playButtonView.triangleView.backgroundColor = .black
        playButtonView.backgroundColor = .playButtonLightGray
        playButtonView.frame = CGRect(origin: .zero, size: CGSize(width: 35, height: 35))
        return playButtonView
    }()

    override func setupSubviews() {
        super.setupSubviews()
        messageContentView.addSubview(playButtonView)
    }

    override open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        switch message.data {
        case .photo(let image):
            messageContentView.image = image
            playButtonView.isHidden = true
        case .video(_, let image):
            messageContentView.image = image
            playButtonView.isHidden = false
            playButtonView.center = messageContentView.center
        default:
            break
        }
    }

}
