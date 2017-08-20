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

open class MessageLabel: UILabel {

    // MARK: - Private Properties

    private lazy var layoutManager: NSLayoutManager = {
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(self.textContainer)
        return layoutManager
    }()

    private lazy var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer()
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.size = self.bounds.size
        return textContainer
    }()

    private lazy var textStorage: NSTextStorage = {
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(self.layoutManager)
        return textStorage
    }()

    private lazy var activeDetectorRanges = [DetectorType: [NSRange]]()

    // MARK: - Public Properties

    // MARK: Text Properties

    open override var attributedText: NSAttributedString? {
        didSet {
            guard attributedText != oldValue else { return }
            setTextStorage()
        }
    }

    open override var text: String? {
        didSet {
            guard text != oldValue else { return }
            setTextStorage()
        }
    }

    open override var font: UIFont! {
        didSet {
            guard font != oldValue else { return }
            guard let attributedText = attributedText else { return }
            textStorage.setAttributedString(attributedText)
            setNeedsDisplay()
        }
    }

    open override var textColor: UIColor! {
        didSet {
            guard textColor != oldValue else { return }
            guard let attributedText = attributedText else { return }
            textStorage.setAttributedString(attributedText)
            setNeedsDisplay()
        }
    }

    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            guard lineBreakMode != oldValue else { return }
            textContainer.lineBreakMode = lineBreakMode
            setNeedsDisplay()
        }
    }

    open override var numberOfLines: Int {
        didSet {
            guard numberOfLines != oldValue else { return }
            textContainer.maximumNumberOfLines = numberOfLines
            setNeedsDisplay()
        }
    }

    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            guard textInsets != oldValue else { return }
            setNeedsDisplay()
        }
    }

    // MARK: DetectorType Properties

    open var enabledDetectors: [DetectorType] = [.phoneNumber, .address]

    open var addressAttributes: [String: Any] = [:] {
        didSet {
            updateAttributes(for: .address)
            setNeedsDisplay()
        }
    }

    open var phoneNumberAttributes: [String: Any] = [:] {
        didSet {
            updateAttributes(for: .phoneNumber)
            setNeedsDisplay()
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        // Message Label Specific
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        // End

        let defaultAttributes: [String: Any] = [
            NSForegroundColorAttributeName: self.textColor,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
            NSUnderlineColorAttributeName: self.textColor
        ]

        self.addressAttributes = defaultAttributes
        self.phoneNumberAttributes = defaultAttributes

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    open override func drawText(in rect: CGRect) {

        let insetRect = UIEdgeInsetsInsetRect(rect, textInsets)
        textContainer.size = CGSize(width: insetRect.width, height: rect.height)

        let origin = insetRect.origin
        let range = layoutManager.glyphRange(for: textContainer)

        layoutManager.drawBackground(forGlyphRange: range, at: origin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: origin)
    }

    // MARK: - Private Methods

    private func addDetectorAttributes(to text: NSAttributedString) -> NSMutableAttributedString {
        guard let checkingResults = parse(text: text, for: enabledDetectors), checkingResults.isEmpty == false else {
            return NSMutableAttributedString(attributedString: text)
        }

        setRangesForActiveDetectors(from: checkingResults)

        let mutableAttributedString = NSMutableAttributedString(attributedString: text)

        checkingResults.forEach { result in
            let detectorTypeAttributes = attributes(for: result.resultType)
            mutableAttributedString.addAttributes(detectorTypeAttributes, range: result.range)
        }

        return mutableAttributedString
    }

    private func updateAttributes(for detectorType: DetectorType) {
        guard let attributedText = attributedText, attributedText.length > 0 else { return }
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)

        switch detectorType {
        case .address:
            guard let ranges = activeDetectorRanges[.address] else { return }
            ranges.forEach { mutableAttributedString.addAttributes(addressAttributes, range: $0) }
        case .phoneNumber:
            guard let ranges = activeDetectorRanges[.phoneNumber] else { return }
            ranges.forEach { mutableAttributedString.addAttributes(phoneNumberAttributes, range: $0) }
        }

        textStorage.setAttributedString(mutableAttributedString)

    }

    // MARK: - Text Parsing

    private func parse(text: NSAttributedString, for detectorTypes: [DetectorType]) -> [NSTextCheckingResult]? {

        let checkingTypes = detectorTypes.reduce(0) { $0 | $1.textCheckingType.rawValue }
        let detector = try? NSDataDetector(types: checkingTypes)

        return detector?.matches(in: text.string, options: [], range: NSRange(location: 0, length: text.length))
    }

    private func setTextStorage() {

        guard let attributedText = attributedText, attributedText.length > 0 else {
            activeDetectorRanges.removeAll()
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }

        var mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)

        mutableAttributedString = addDetectorAttributes(to: mutableAttributedString)

        textStorage.setAttributedString(mutableAttributedString)

        setNeedsDisplay()
        
    }

    private func attributes(for checkingResultType: NSTextCheckingResult.CheckingType) -> [String: Any] {
        switch checkingResultType {
        case NSTextCheckingResult.CheckingType.address:
            return addressAttributes
        case NSTextCheckingResult.CheckingType.phoneNumber:
            return phoneNumberAttributes
        default:
            fatalError("Received an unrecognized NSTextCheckingResult.CheckingType")
        }
    }

    private func setRangesForActiveDetectors(from checkingResults: [NSTextCheckingResult]) {
        checkingResults.forEach { result in

            switch result.resultType {
            case NSTextCheckingResult.CheckingType.address:
                var ranges = activeDetectorRanges[.address] ?? []
                ranges.append(result.range)
                activeDetectorRanges.updateValue(ranges, forKey: .address)
            case NSTextCheckingResult.CheckingType.phoneNumber:
                var ranges = activeDetectorRanges[.phoneNumber] ?? []
                ranges.append(result.range)
                activeDetectorRanges.updateValue(ranges, forKey: .phoneNumber)
            default:
                fatalError("Received an unrecognized NSTextCheckingResult.CheckingType")
            }
        }
    }

}
