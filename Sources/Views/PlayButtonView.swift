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

open class PlayButtonView: UIView {

    // MARK: - Properties

    public let triangleView = UIView()

    private var triangleCenterXConstraint: NSLayoutConstraint?
    private var cacheFrame: CGRect = .zero

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubviews()
        setupConstraints()
        setupView()
    }

    // MARK: - Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !cacheFrame.equalTo(frame) else { return }
        cacheFrame = frame
        
        updateTriangleConstraints()
        applyCornerRadius()
        applyTriangleMask()
    }

    private func setupSubviews() {
        addSubview(triangleView)
    }
    
    private func setupView() {
        triangleView.clipsToBounds = true
        triangleView.backgroundColor = .black
        
        backgroundColor = .playButtonLightGray
    }

    private func setupConstraints() {
        triangleView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = triangleView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = triangleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let width = triangleView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        let height = triangleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)

        triangleCenterXConstraint = centerX

        NSLayoutConstraint.activate([centerX, centerY, width, height])
    }

    private func triangleMask(for frame: CGRect) -> CAShapeLayer {
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

    private func updateTriangleConstraints() {
        triangleCenterXConstraint?.constant = frame.width/8
    }

    private func applyTriangleMask() {
        let rect = CGRect(origin: .zero, size: triangleView.bounds.size)
        triangleView.layer.mask = triangleMask(for: rect)
    }

    private func applyCornerRadius() {
        layer.cornerRadius = frame.width / 2
    }
    
}
