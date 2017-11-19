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
    
    private var isConfiguring: Bool = false

    // MARK: - Public Properties

    open weak var delegate: MessageLabelDelegate?

    open var enabledDetectors: [DetectorType] = [.phoneNumber, .address, .date, .url]

    open override var attributedText: NSAttributedString? {
        didSet {
            setTextStorage(shouldParse: true)
        }
    }

    open override var text: String? {
        didSet {
            setTextStorage(shouldParse: true)
        }
    }

    open override var font: UIFont! {
        didSet {
            setTextStorage(shouldParse: false)
        }
    }

    open override var textColor: UIColor! {
        didSet {
            setTextStorage(shouldParse: false)
        }
    }

    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    open override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    open override var textAlignment: NSTextAlignment {
        didSet {
            setTextStorage(shouldParse: false)
        }
    }

    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    open var addressAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .address)
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    open var dateAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .date)
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    open var phoneNumberAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .phoneNumber)
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    open var urlAttributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            updateAttributes(for: .url)
            if !isConfiguring { setNeedsDisplay() }
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
    
    public func configure(block: () -> Void) {
        isConfiguring = true
        block()
        isConfiguring = false
        setNeedsDisplay()
    }

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

    private func setTextStorage(shouldParse: Bool) {

        guard let attributedText = attributedText, attributedText.length > 0 else {
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }
        
        let style = paragraphStyle(for: attributedText)
        let range = NSRange(location: 0, length: attributedText.length)
        
        let mutableText = NSMutableAttributedString(attributedString: attributedText)
        mutableText.addAttribute(.paragraphStyle, value: style, range: range)
        
        if shouldParse {
            rangesForDetectors.removeAll()
            let results = parse(text: mutableText)
            setRangesForDetectors(in: results)
        }
        
        for (detector, rangeTuples) in rangesForDetectors {
            if enabledDetectors.contains(detector) {
                let attributes = detectorAttributes(for: detector)
                rangeTuples.forEach { (range, _) in
                    mutableText.addAttributes(attributes, range: range)
                }
            }
        }

        let modifiedText = NSAttributedString(attributedString: mutableText)
        textStorage.setAttributedString(modifiedText)

        if !isConfiguring { setNeedsDisplay() }

    }
    
    private func paragraphStyle(for text: NSAttributedString) -> NSParagraphStyle {
        guard text.length > 0 else { return NSParagraphStyle() }
        
        var range = NSRange(location: 0, length: text.length)
        let existingStyle = text.attribute(.paragraphStyle, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle
        let style = existingStyle ?? NSMutableParagraphStyle()
        
        style.lineBreakMode = lineBreakMode
        style.alignment = textAlignment
        
        return style
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

    private func parse(text: NSAttributedString) -> [NSTextCheckingResult] {
        guard enabledDetectors.isEmpty == false else { return [] }
        let checkingTypes = enabledDetectors.reduce(0) { $0 | $1.textCheckingType.rawValue }
        let detector = try? NSDataDetector(types: checkingTypes)
        let range = NSRange(location: 0, length: text.length)
        return detector?.matches(in: text.string, options: [], range: range) ?? []
    }

    private func setRangesForDetectors(in checkingResults: [NSTextCheckingResult]) {

        guard checkingResults.isEmpty == false else { return }
        
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

        let index = layoutManager.glyphIndex(for: location, in: textContainer)

        let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: nil)
        
        var characterIndex: Int?
        
        if lineRect.contains(location) {
            characterIndex = layoutManager.characterIndexForGlyph(at: index)
        }
        
        return characterIndex

    }

    private func setupGestureRecognizers() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(tapGesture)
        tapGesture.delegate = self

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(longPressGesture)
        longPressGesture.delegate = self

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
