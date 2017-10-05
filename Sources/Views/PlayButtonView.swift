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

    // MARK: - Properties

    open let triangleView = UIView()

    private var triangleHeightConstraint: NSLayoutConstraint?
    private var triangleWidthConstraint: NSLayoutConstraint?
    private var triangleCenterXConstraint: NSLayoutConstraint?

    private var triangleViewSize: CGSize {
        return CGSize(width: frame.width/2, height: frame.height/2)
    }

    open override var frame: CGRect {
        didSet {
            updateTriangleConstraints()
            applyCornerRadius()
            applyTriangleMask()
        }
    }

    open override var bounds: CGRect {
        didSet {
            updateTriangleConstraints()
            applyCornerRadius()
            applyTriangleMask()
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupConstraints()
        applyCornerRadius()
        applyTriangleMask()

        triangleView.clipsToBounds = true
        triangleView.backgroundColor = .black
        backgroundColor = .playButtonLightGray
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setupSubviews() {
        addSubview(triangleView)
    }

    private func setupConstraints() {
        triangleView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = triangleView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: triangleViewSize.width/8)
        let centerY = triangleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let width = triangleView.widthAnchor.constraint(equalToConstant: triangleViewSize.width)
        let height = triangleView.heightAnchor.constraint(equalToConstant: triangleViewSize.height)

        triangleWidthConstraint = width
        triangleHeightConstraint = height
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
        triangleWidthConstraint?.constant = triangleViewSize.width
        triangleHeightConstraint?.constant = triangleViewSize.height
        triangleCenterXConstraint?.constant = triangleViewSize.width/8
    }

    private func applyTriangleMask() {
        let rect = CGRect(origin: .zero, size: triangleViewSize)
        triangleView.layer.mask = triangleMask(for: rect)
    }

    private func applyCornerRadius() {
        layer.cornerRadius = frame.width / 2
    }
    
}
