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

open class MessageLabel: UILabel, UIGestureRecognizerDelegate {

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

    private lazy var rangesForDetectors: [DetectorType: [(NSRange, MessageTextCheckingType)]] = [:]

    // MARK: - Public Properties

    open weak var delegate: MessageLabelDelegate?

    open var enabledDetectors: [DetectorType] = [.phoneNumber, .address, .date, .url]

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

    open override var textAlignment: NSTextAlignment {
        didSet {
            guard textAlignment != oldValue else { return }
            setTextStorage()
        }
    }

    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            guard textInsets != oldValue else { return }
            setNeedsDisplay()
        }
    }

    open var addressAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .address)
            setNeedsDisplay()
        }
    }

    open var dateAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .date)
            setNeedsDisplay()
        }
    }

    open var phoneNumberAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .phoneNumber)
            setNeedsDisplay()
        }
    }

    open var urlAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .url)
            setNeedsDisplay()
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        // Message Label Specific
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping

        let defaultAttributes: [NSAttributedStringKey: Any] = [
          NSAttributedStringKey.foregroundColor: self.textColor,
          NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
          NSAttributedStringKey.underlineColor: self.textColor
        ]

        self.addressAttributes = defaultAttributes
        self.dateAttributes = defaultAttributes
        self.phoneNumberAttributes = defaultAttributes
        self.urlAttributes = defaultAttributes

        setupGestureRecognizers()

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Open Methods

    open override func drawText(in rect: CGRect) {

        let insetRect = UIEdgeInsetsInsetRect(rect, textInsets)
        textContainer.size = CGSize(width: insetRect.width, height: rect.height)

        let origin = insetRect.origin
        let range = layoutManager.glyphRange(for: textContainer)

        layoutManager.drawBackground(forGlyphRange: range, at: origin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: origin)
    }

    // MARK: - Public Methods

    // MARK: UIGestureRecognizer Delegate

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    //swiftlint:disable cyclomatic_complexity
    // Yeah we're disabling this because the whole file is a mess :D
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        let touchLocation = touch.location(in: self)

        switch true {
        case gestureRecognizer.view != self.superview && gestureRecognizer.view != self:
            return true
        case gestureRecognizer.view == self.superview:
            guard let index = stringIndex(at: touchLocation) else { return true }
            for (_, ranges) in rangesForDetectors {
                for (nsRange, _) in ranges {
                  guard let range = Range(nsRange) else { return true }
                    if range.contains(index) { return false }
                }
            }
            return true
        case gestureRecognizer.view == self:
            guard let index = stringIndex(at: touchLocation) else { return false }
            for (_, ranges) in rangesForDetectors {
                for (nsRange, _) in ranges {
                    guard let range = Range(nsRange) else { return false }
                    if range.contains(index) { return true }
                }
            }
            return false
        default:
            return true
        }

    }

    // MARK: - Private Methods

    private func setTextStorage() {

        // Anytime we update the text storage we need to clear the previous ranges
        rangesForDetectors.removeAll()

        guard let attributedText = attributedText, attributedText.length > 0 else {
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }

        guard let checkingResults = parse(text: attributedText, for: enabledDetectors), checkingResults.isEmpty == false else {
            let textWithParagraphAttributes = addParagraphStyleAttribute(to: attributedText)
            textStorage.setAttributedString(textWithParagraphAttributes)
            setNeedsDisplay()
            return
        }

        setRangesForDetectors(in: checkingResults)

        let textWithDetectorAttributes = addDetectorAttributes(to: attributedText, for: checkingResults)
        let textWithParagraphAttributes = addParagraphStyleAttribute(to: textWithDetectorAttributes)

        textStorage.setAttributedString(textWithParagraphAttributes)

        setNeedsDisplay()

    }

    private func addParagraphStyleAttribute(to text: NSAttributedString) -> NSAttributedString {

        let mutableAttributedString = NSMutableAttributedString(attributedString: text)
        var textRange = NSRange(location: 0, length: 0)

      let paragraphStyle = text.attribute(NSAttributedStringKey.paragraphStyle, at: 0, effectiveRange: &textRange) as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = textAlignment

      mutableAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: textRange)

        return mutableAttributedString

    }

    private func addDetectorAttributes(to text: NSAttributedString, for checkingResults: [NSTextCheckingResult]) -> NSAttributedString {

        let mutableAttributedString = NSMutableAttributedString(attributedString: text)

        checkingResults.forEach { result in
            let attributes = detectorAttributes(for: result.resultType)
            mutableAttributedString.addAttributes(attributes, range: result.range)
        }

        return mutableAttributedString
    }

    private func updateAttributes(for detectorType: DetectorType) {

        guard let attributedText = attributedText, attributedText.length > 0 else { return }
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)

        guard let ranges = rangesForDetectors[detectorType] else { return }

        ranges.forEach { (range, _) in
            let attributes = detectorAttributes(for: detectorType)
            mutableAttributedString.addAttributes(attributes, range: range)
        }

        textStorage.setAttributedString(mutableAttributedString)

    }

    private func detectorAttributes(for detectorType: DetectorType) -> [NSAttributedStringKey: Any] {

        switch detectorType {
        case .address:
            return addressAttributes
        case .date:
            return dateAttributes
        case .phoneNumber:
            return phoneNumberAttributes
        case .url:
            return urlAttributes
        }

    }

    private func detectorAttributes(for checkingResultType: NSTextCheckingResult.CheckingType) -> [NSAttributedStringKey: Any] {
        switch checkingResultType {
        case .address:
            return addressAttributes
        case .date:
            return dateAttributes
        case .phoneNumber:
            return phoneNumberAttributes
        case .link:
            return urlAttributes
        default:
            fatalError("Received an unrecognized NSTextCheckingResult.CheckingType")
        }
    }

    // MARK: - Parsing Text

    private func parse(text: NSAttributedString, for detectorTypes: [DetectorType]) -> [NSTextCheckingResult]? {
        guard detectorTypes.isEmpty == false else { return nil }
        let checkingTypes = detectorTypes.reduce(0) { $0 | $1.textCheckingType.rawValue }
        let detector = try? NSDataDetector(types: checkingTypes)

        return detector?.matches(in: text.string, options: [], range: NSRange(location: 0, length: text.length))
    }

    private func setRangesForDetectors(in checkingResults: [NSTextCheckingResult]) {

        for result in checkingResults {

            switch result.resultType {
            case .address:
                var ranges = rangesForDetectors[.address] ?? []
                let tuple: (NSRange, MessageTextCheckingType) = (result.range, .addressComponents(result.addressComponents))
                ranges.append(tuple)
                rangesForDetectors.updateValue(ranges, forKey: .address)
            case .date:
                var ranges = rangesForDetectors[.date] ?? []
                let tuple: (NSRange, MessageTextCheckingType) = (result.range, .date(result.date))
                ranges.append(tuple)
                rangesForDetectors.updateValue(ranges, forKey: .date)
            case .phoneNumber:
                var ranges = rangesForDetectors[.phoneNumber] ?? []
                let tuple: (NSRange, MessageTextCheckingType) = (result.range, .phoneNumber(result.phoneNumber))
                ranges.append(tuple)
                rangesForDetectors.updateValue(ranges, forKey: .phoneNumber)
            case .link:
                var ranges = rangesForDetectors[.url] ?? []
                let tuple: (NSRange, MessageTextCheckingType) = (result.range, .link(result.url))
                ranges.append(tuple)
                rangesForDetectors.updateValue(ranges, forKey: .url)
            default:
                fatalError("Received an unrecognized NSTextCheckingResult.CheckingType")
            }

        }

    }

    // MARK: - Gesture Handling

    private func stringIndex(at location: CGPoint) -> Int? {
        guard textStorage.length > 0 else { return nil }

        var location = location
        let textOffset = CGPoint(x: textInsets.left, y: textInsets.right)

        location.x -= textOffset.x
        location.y -= textOffset.y

        let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)

        let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: glyphIndex, effectiveRange: nil)

        if lineRect.contains(location) {
            return layoutManager.characterIndexForGlyph(at: glyphIndex)
        } else {
            return nil
        }

    }

    private func setupGestureRecognizers() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(tapGesture)
        tapGesture.delegate = self

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(longPressGesture)
        tapGesture.delegate = self

        isUserInteractionEnabled = true
    }

  @objc func handleGesture(_ gesture: UIGestureRecognizer) {

        let touchLocation = gesture.location(ofTouch: 0, in: self)
        guard let index = stringIndex(at: touchLocation) else { return }

        for (detectorType, ranges) in rangesForDetectors {
            for (nsRange, value) in ranges {
                guard let range = Range(nsRange) else { return }
                if range.contains(index) {
                    handleGesture(for: detectorType, value: value)
                }
            }
        }
    }

    private func handleGesture(for detectorType: DetectorType, value: MessageTextCheckingType) {
        
        switch value {
        case let .addressComponents(addressComponents):
            var transformedAddressComponents = [String: String]()
            guard let addressComponents = addressComponents else { return }
            addressComponents.forEach { (key, value) in
                transformedAddressComponents[key.rawValue] = value
            }
            handleAddress(transformedAddressComponents)
        case let .phoneNumber(phoneNumber):
            guard let phoneNumber = phoneNumber else { return }
            handlePhoneNumber(phoneNumber)
        case let .date(date):
            guard let date = date else { return }
            handleDate(date)
        case let .link(url):
            guard let url = url else { return }
            handleURL(url)
        }
    }
    
    private func handleAddress(_ addressComponents: [String: String]) {
        delegate?.didSelectAddress(addressComponents)
    }
    
    private func handleDate(_ date: Date) {
        delegate?.didSelectDate(date)
    }
    
    private func handleURL(_ url: URL) {
        delegate?.didSelectURL(url)
    }
    
    private func handlePhoneNumber(_ phoneNumber: String) {
        delegate?.didSelectPhoneNumber(phoneNumber)
    }
    
}

fileprivate enum MessageTextCheckingType {
    case addressComponents([NSTextCheckingKey: String]?)
    case date(Date?)
    case phoneNumber(String?)
    case link(URL?)
}
