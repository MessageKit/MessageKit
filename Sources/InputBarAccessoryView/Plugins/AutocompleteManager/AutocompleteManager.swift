//
//  AttachmentManager.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

public extension NSAttributedString.Key {
    
    /// A key used for referencing which substrings were autocompleted
    /// by InputBarAccessoryView.AutocompleteManager
    static let autocompleted = NSAttributedString.Key("com.system.autocompletekey")
    
    /// A key used for referencing the context of autocompleted substrings
    /// by InputBarAccessoryView.AutocompleteManager
    static let autocompletedContext = NSAttributedString.Key("com.system.autocompletekey.context")
}

open class AutocompleteManager: NSObject, InputPlugin, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties [Public]
    
    /// A protocol that passes data to the `AutocompleteManager`
    open weak var dataSource: AutocompleteManagerDataSource?
    
    /// A protocol that more precisely defines `AutocompleteManager` logic
    open weak var delegate: AutocompleteManagerDelegate?
    
    /// A reference to the `InputTextView` that the `AutocompleteManager` is using
    private(set) public weak var textView: UITextView?
    
    @available(*, deprecated, message: "`inputTextView` has been renamed to `textView` of type `UITextView`")
    public var inputTextView: InputTextView? { return textView as? InputTextView }
    
    /// An ongoing session reference that holds the prefix, range and text to complete with
    private(set) public var currentSession: AutocompleteSession?
    
    /// The `AutocompleteTableView` that renders available autocompletes for the `currentSession`
    open lazy var tableView: AutocompleteTableView = { [weak self] in
        let tableView = AutocompleteTableView()
        tableView.register(AutocompleteCell.self, forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
        tableView.separatorStyle = .none
        if #available(iOS 13, *) {
            tableView.backgroundColor = .systemBackground
        } else {
            tableView.backgroundColor = .white
        }
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    /// Adds an additional space after the autocompleted text when true.
    /// Default value is `TRUE`
    open var appendSpaceOnCompletion = true
    
    /// Keeps the prefix typed when text is autocompleted.
    /// Default value is `TRUE`
    open var keepPrefixOnCompletion = true
    
    /// Allows a single space character to be entered mid autocompletion.
    ///
    /// For example, your autocomplete is "Nathan Tannar", the .whitespace deliminater
    /// set would terminate the session after "Nathan". By setting `maxSpaceCountDuringCompletion`
    /// the session termination will disregard that number of spaces
    ///
    /// Default value is `0`
    open var maxSpaceCountDuringCompletion: Int = 0

    /// When enabled, autocomplete completions that contain whitespace will be deleted in parts.
    /// This meands backspacing on "@Nathan Tannar" will result in " Tannar" being removed first
    /// with a second backspace action required to delete "@Nathan"
    ///
    /// Default value is `TRUE`
    open var deleteCompletionByParts = true
    
    /// The default text attributes
    open var defaultTextAttributes: [NSAttributedString.Key: Any] = {
        var foregroundColor: UIColor
        if #available(iOS 13, *) {
            foregroundColor = .label
        } else {
            foregroundColor = .black
        }
        return [.font: UIFont.preferredFont(forTextStyle: .body), .foregroundColor: foregroundColor]
    }()
    
    /// The NSAttributedString.Key.paragraphStyle value applied to attributed strings
    public let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacingBefore = 2
        style.lineHeightMultiple = 1
        return style
    }()

    /// A block that filters the `AutocompleteCompletion`'s sourced
    /// from the `dataSource`, based on the `AutocompleteSession`.
    /// The default function requires the `AutocompleteCompletion.text`
    /// string contains the `AutocompleteSession.filter`
    /// string ignoring case
    open var filterBlock: (AutocompleteSession, AutocompleteCompletion) -> (Bool) = { session, completion in completion.text.lowercased().contains(session.filter.lowercased())
    }
    
    // MARK: - Properties [Private]
    
    /// The prefices that the manager will recognize
    public private(set) var autocompletePrefixes = Set<String>()
    
    /// The delimiters that the manager will terminate a session with
    /// The default value is: [.whitespaces, .newlines]
    public private(set) var autocompleteDelimiterSets: Set<CharacterSet> = [.whitespaces, .newlines]
    
    /// The text attributes applied to highlighted substrings for each prefix
    public private(set) var autocompleteTextAttributes = [String: [NSAttributedString.Key: Any]]()
    
    /// A reference to `defaultTextAttributes` that adds the NSAttributedAutocompleteKey
    private var typingTextAttributes: [NSAttributedString.Key: Any] {
        var attributes = defaultTextAttributes
        attributes[.autocompleted] = false
        attributes[.autocompletedContext] = nil
        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }
    
    /// The current autocomplete text options filtered by the text after the prefix
    private var currentAutocompleteOptions: [AutocompleteCompletion] {
        
        guard let session = currentSession, let completions = dataSource?.autocompleteManager(self, autocompleteSourceFor: session.prefix) else { return [] }
        guard !session.filter.isEmpty else { return completions }
        return completions.filter { completion in
            return filterBlock(session, completion)
        }
    }
    
    // MARK: - Initialization
    
    public init(for textView: UITextView) {
        super.init()
        self.textView = textView
        self.textView?.delegate = self
    }
    
    // MARK: - InputPlugin
    
    /// Reloads the InputPlugin's session
    open func reloadData() {

        var delimiterSet = autocompleteDelimiterSets.reduce(CharacterSet()) { result, set in
            return result.union(set)
        }
        let query = textView?.find(prefixes: autocompletePrefixes, with: delimiterSet)
        
        guard let result = query else {
            if let session = currentSession, session.spaceCounter <= maxSpaceCountDuringCompletion {
                delimiterSet = delimiterSet.subtracting(.whitespaces)
                guard let result = textView?.find(prefixes: [session.prefix], with: delimiterSet) else {
                    unregisterCurrentSession()
                    return
                }
                let wordWithoutPrefix = (result.word as NSString).substring(from: result.prefix.utf16.count)
                updateCurrentSession(to: wordWithoutPrefix)
            } else {
                unregisterCurrentSession()
            }
            return
        }
        let wordWithoutPrefix = (result.word as NSString).substring(from: result.prefix.utf16.count)
        guard let session = AutocompleteSession(prefix: result.prefix, range: result.range, filter: wordWithoutPrefix) else { return }
        guard let currentSession = currentSession else {
            registerCurrentSession(to: session)
            return
        }
        if currentSession == session {
            updateCurrentSession(to: wordWithoutPrefix)
        } else {
            registerCurrentSession(to: session)
        }
    }
    
    /// Invalidates the InputPlugin's session
    open func invalidate() {
        unregisterCurrentSession()
    }
    
    /// Passes an object into the InputPlugin's session to handle
    ///
    /// - Parameter object: A string to append
    @discardableResult
    open func handleInput(of object: AnyObject) -> Bool {
        guard let newText = object as? String, let textView = textView else { return false }
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let newAttributedString = NSAttributedString(string: newText, attributes: typingTextAttributes)
        attributedString.append(newAttributedString)
        textView.attributedText = attributedString
        reloadData()
        return true
    }
    
    // MARK: - API [Public]
    
    /// Registers a prefix and its the attributes to apply to its autocompleted strings
    ///
    /// - Parameters:
    ///   - prefix: The prefix such as: @, # or !
    ///   - attributedTextAttributes: The attributes to apply to the NSAttributedString
    open func register(prefix: String, with attributedTextAttributes: [NSAttributedString.Key:Any]? = nil) {
        autocompletePrefixes.insert(prefix)
        autocompleteTextAttributes[prefix] = attributedTextAttributes
        autocompleteTextAttributes[prefix]?[.paragraphStyle] = paragraphStyle
    }
    
    /// Unregisters a prefix and removes its associated cached attributes
    ///
    /// - Parameter prefix: The prefix such as: @, # or !
    open func unregister(prefix: String) {
        autocompletePrefixes.remove(prefix)
        autocompleteTextAttributes[prefix] = nil
    }
    
    /// Registers a CharacterSet as a delimiter
    ///
    /// - Parameter delimiterSet: The `CharacterSet` to recognize as a delimiter
    open func register(delimiterSet set: CharacterSet) {
        autocompleteDelimiterSets.insert(set)
    }
    
    /// Unregisters a CharacterSet
    ///
    /// - Parameter delimiterSet: The `CharacterSet` to recognize as a delimiter
    open func unregister(delimiterSet set: CharacterSet) {
        autocompleteDelimiterSets.remove(set)
    }
    
    /// Replaces the current prefix and filter text with the supplied text
    ///
    /// - Parameters:
    ///   - text: The replacement text
    open func autocomplete(with session: AutocompleteSession) {
        
        guard let textView = textView else { return }
        guard delegate?.autocompleteManager(self, shouldComplete: session.prefix, with: session.filter) != false else { return }
        
        // Create a range that overlaps the prefix
        let prefixLength = session.prefix.utf16.count
        let insertionRange = NSRange(
            location: session.range.location + (keepPrefixOnCompletion ? prefixLength : 0),
            length: session.filter.utf16.count + (!keepPrefixOnCompletion ? prefixLength : 0)
        )
        
        // Transform range
        guard let range = Range(insertionRange, in: textView.text) else { return }
        let nsrange = NSRange(range, in: textView.text)
        
        // Replace the attributedText with a modified version
        let autocomplete = session.completion?.text ?? ""
        insertAutocomplete(autocomplete, at: session, for: nsrange)
        
        // Move Cursor to the end of the inserted text
        let selectedLocation = insertionRange.location + autocomplete.utf16.count + (appendSpaceOnCompletion ? 1 : 0)
        textView.selectedRange = NSRange(
            location: selectedLocation,
            length: 0
        )
        
        // End the session
        unregisterCurrentSession()
    }
    
    /// Returns an attributed string with bolded characters matching the characters typed in the session
    ///
    /// - Parameter session: The `AutocompleteSession` to form an `NSMutableAttributedString` with
    /// - Returns: An `NSMutableAttributedString`
    open func attributedText(matching session: AutocompleteSession,
                             fontSize: CGFloat = 15,
                             keepPrefix: Bool = true) -> NSMutableAttributedString {
        
        guard let completion = session.completion else {
            return NSMutableAttributedString()
        }
        
        // Bolds the text that currently matches the filter
        let matchingRange = (completion.text as NSString).range(of: session.filter, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString().normal(completion.text, fontSize: fontSize)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: fontSize)], range: matchingRange)
        
        guard keepPrefix else { return attributedString }
        let stringWithPrefix = NSMutableAttributedString().normal(String(session.prefix), fontSize: fontSize)
        stringWithPrefix.append(attributedString)
        return stringWithPrefix
    }
    
    // MARK: - API [Private]
    
    /// Resets the `InputTextView`'s typingAttributes to `defaultTextAttributes`
    private func preserveTypingAttributes() {
        textView?.typingAttributes = typingTextAttributes
    }
    
    
    /// Inserts an autocomplete for a given selection
    ///
    /// - Parameters:
    ///   - autocomplete: The 'String' to autocomplete to
    ///   - sesstion: The 'AutocompleteSession'
    ///   - range: The 'NSRange' to insert over
    private func insertAutocomplete(_ autocomplete: String, at session: AutocompleteSession, for range: NSRange) {
        
        guard let textView = textView else { return }
        
        // Apply the autocomplete attributes
        var attrs = autocompleteTextAttributes[session.prefix] ?? defaultTextAttributes
        attrs[.autocompleted] = true
        attrs[.autocompletedContext] = session.completion?.context
        let newString = (keepPrefixOnCompletion ? session.prefix : "") + autocomplete
        let newAttributedString = NSMutableAttributedString(string: newString, attributes: attrs)
        
        // Append extra space if needed
        if appendSpaceOnCompletion {
          newAttributedString.append(NSAttributedString(string: " ", attributes: typingTextAttributes))
        }
        
        // Modify the NSRange to include the prefix length
        let rangeModifier = keepPrefixOnCompletion ? session.prefix.count : 0
        let highlightedRange = NSRange(location: range.location - rangeModifier, length: range.length + rangeModifier)
        
        // Replace the attributedText with a modified version including the autocompete
        let newAttributedText = textView.attributedText.replacingCharacters(in: highlightedRange, with: newAttributedString)
        
        // make background clear for dark mode support
        newAttributedText.addAttribute(NSAttributedString.Key.backgroundColor,
                                       value: UIColor.clear,
                                       range: NSMakeRange(0, newAttributedText.length))
        
        // Set to a blank attributed string to prevent keyboard autocorrect from cloberring the insert
        textView.attributedText = NSAttributedString()

        textView.attributedText = newAttributedText
    }
    
    /// Initializes a session with a new `AutocompleteSession` object
    ///
    /// - Parameters:
    ///   - session: The session to register
    private func registerCurrentSession(to session: AutocompleteSession) {
        
        guard delegate?.autocompleteManager(self, shouldRegister: session.prefix, at: session.range) != false else { return }
        currentSession = session
        layoutIfNeeded()
        delegate?.autocompleteManager(self, shouldBecomeVisible: true)
    }
    
    /// Updates the session to a new String to filter results with
    ///
    /// - Parameters:
    ///   - filterText: The String to filter `AutocompleteCompletion`s
    private func updateCurrentSession(to filterText: String) {
        
        currentSession?.filter = filterText
        layoutIfNeeded()
        delegate?.autocompleteManager(self, shouldBecomeVisible: true)
    }
    
    /// Invalidates the `currentSession` session if it existed
    private func unregisterCurrentSession() {
        
        guard let session = currentSession else { return }
        guard delegate?.autocompleteManager(self, shouldUnregister: session.prefix) != false else { return }
        currentSession = nil
        layoutIfNeeded()
        delegate?.autocompleteManager(self, shouldBecomeVisible: false)
    }
    
    /// Calls the required methods to relayout the `AutocompleteTableView` in it's superview
    private func layoutIfNeeded() {
        
        tableView.reloadData()
        
        // Resize the table to be fit properly in an `InputStackView`
        tableView.invalidateIntrinsicContentSize()
        
        // Layout the table's superview
        tableView.superview?.layoutIfNeeded()
    }
    
    // MARK: - UITextViewDelegate
    
    public func textViewDidChange(_ textView: UITextView) {
        reloadData()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Ensure that the text to be inserted is not using previous attributes
        preserveTypingAttributes()
        
        if let session = currentSession {
            let textToReplace = (textView.text as NSString).substring(with: range)
            let deleteSpaceCount = textToReplace.filter { $0 == .space }.count
            let insertSpaceCount = text.filter { $0 == .space }.count
            let spaceCountDiff = insertSpaceCount - deleteSpaceCount
            session.spaceCounter = spaceCountDiff
        }
        
        let totalRange = NSRange(location: 0, length: textView.attributedText.length)
        let selectedRange = textView.selectedRange
        
        // range.length > 0: Backspace/removing text
        // range.lowerBound < textView.selectedRange.lowerBound: Ignore trying to delete
        //      the substring if the user is already doing so
        // range == selectedRange: User selected a chunk to delete
        if range.length > 0, range.location < selectedRange.location {
            
            // Backspace/removing text
            let attributes = textView.attributedText.attributes(at: range.location, longestEffectiveRange: nil, in: range)
            let isAutocompleted = attributes[.autocompleted] as? Bool ?? false
            
            if isAutocompleted {
                textView.attributedText.enumerateAttribute(.autocompleted, in: totalRange, options: .reverse) { _, subrange, stop in
                    
                    let intersection = NSIntersectionRange(range, subrange)
                    guard intersection.length > 0 else { return }
                    defer { stop.pointee = true }

                    let nothing = NSAttributedString(string: "", attributes: typingTextAttributes)

                    let textToReplace = textView.attributedText.attributedSubstring(from: subrange).string
                    guard deleteCompletionByParts, let delimiterRange = textToReplace.rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards, range: Range(subrange, in: textToReplace)) else {
                        // Replace entire autocomplete
                        textView.attributedText = textView.attributedText.replacingCharacters(in: subrange, with: nothing)
                        textView.selectedRange = NSRange(location: subrange.location, length: 0)
                        return
                    }
                    // Delete up to delimiter
                    let delimiterLocation = delimiterRange.lowerBound.utf16Offset(in: textToReplace)
                    let length = subrange.length - delimiterLocation
                    let rangeFromDelimiter = NSRange(location: delimiterLocation + subrange.location, length: length)
                    textView.attributedText = textView.attributedText.replacingCharacters(in: rangeFromDelimiter, with: nothing)
                    textView.selectedRange = NSRange(location: subrange.location + delimiterLocation, length: 0)
                }
                unregisterCurrentSession()
                return false
            }
        } else if range.length >= 0, range.location < totalRange.length {
            
            // Inserting text before a tag when the tag is at the start of the string
            guard range.location != 0 else { return true }

            // Inserting text in the middle of an autocompleted string
            let attributes = textView.attributedText.attributes(at: range.location-1, longestEffectiveRange: nil, in: NSMakeRange(range.location-1, range.length))

            let isAutocompleted = attributes[.autocompleted] as? Bool ?? false
            if isAutocompleted {
                textView.attributedText.enumerateAttribute(.autocompleted, in: totalRange, options: .reverse) { _, subrange, stop in
                    
                    let compareRange = range.length == 0 ? NSRange(location: range.location, length: 1) : range
                    let intersection = NSIntersectionRange(compareRange, subrange)
                    guard intersection.length > 0 else { return }
                    
                    let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
                    mutable.setAttributes(typingTextAttributes, range: subrange)
                    let replacementText = NSAttributedString(string: text, attributes: typingTextAttributes)
                    textView.attributedText = mutable.replacingCharacters(in: range, with: replacementText)
                    textView.selectedRange = NSRange(location: range.location + text.count, length: 0)
                    stop.pointee = true
                }
                unregisterCurrentSession()
                return false
            }
        }
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAutocompleteOptions.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let session = currentSession else { fatalError("Attempted to render a cell for a nil `AutocompleteSession`") }
        session.completion = currentAutocompleteOptions[indexPath.row]
        guard let cell = dataSource?.autocompleteManager(self, tableView: tableView, cellForRowAt: indexPath, for: session) else {
            fatalError("Failed to return a cell from `dataSource: AutocompleteManagerDataSource`")
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let session = currentSession else { return }
        session.completion = currentAutocompleteOptions[indexPath.row]
        autocomplete(with: session)
    }
    
}
