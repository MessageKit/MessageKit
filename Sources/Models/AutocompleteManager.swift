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

public struct AutocompleteCompletion {
    
    // The string used for sorting and to autocomplete a prefix
    var text: String
    
    // An optional string to display instead of `text`, for example emojis
    var displayText: String?
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ text: String, displayText: String) {
        self.text = text
        self.displayText = displayText
    }
}

/// A structure containing data on the `AutocompleteManager`'s session
public struct AutocompleteSession {
    
    let prefix: Character
    var range: NSRange
    var filter: String
    var completion: AutocompleteCompletion?
    
    public init?(prefix: Character?, range: NSRange?, filter: String?) {
        guard let pfx = prefix, let rng = range, let flt = filter else { return nil }
        self.prefix = pfx
        self.range = rng
        self.filter = flt
    }
}

open class AutocompleteManager: NSObject, InputManager {
    
    // MARK: - Properties [Public]
    
    /// A protocol that passes data to the `AutocompleteManager`
    open weak var dataSource: AutocompleteManagerDataSource?
    
    /// A protocol that more precisely defines `AutocompleteManager` logic
    open weak var delegate: AutocompleteManagerDelegate?
    
    /// A reference to the `InputTextView` that the `AutocompleteManager` is using
    private(set) public weak var inputTextView: InputTextView?
    
    /// An ongoing session reference that holds the prefix, range and text to complete with
    private(set) public var currentSession: AutocompleteSession? {
        didSet {
            layoutIfNeeded()
        }
    }
    
    /// The `AutocompleteTableView` that renders available autocompletes for the `currentSession`
    open lazy var tableView: AutocompleteTableView = { [weak self] in
        let tableView = AutocompleteTableView()
        tableView.register(AutocompleteCell.self, forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    /// If the autocomplete matches should be made by casting the strings to lowercase.
    /// Default value is `FALSE`
    open var isCaseSensitive = false
    
    /// Adds an additional space after the autocompleted text when true.
    /// Default value is `TRUE`
    open var appendSpaceOnCompletion = true
    
    /// Keeps the prefix typed when text is autocompleted.
    /// Default value is `TRUE`
    open var keepPrefixOnCompletion = true
    
    /// The prefices that the manager will recognize
    /// Default value is `["@"]`
    open var autocompletePrefixes: [Character] = ["@"]
    
    /// The delimiters that cause a current autocomplete session to become invalidated when typed.
    /// Default value is `[" ", "\n"]`
    open var autocompleteDelimiters: [Character] = [" ", "\n"]
    
    /// The default text attributes
    open var defaultTextAttributes: [NSAttributedStringKey: Any] =
        [.font: UIFont.preferredFont(forTextStyle: .body), .foregroundColor: UIColor.black]
    
    /// The text attributes applied to highlighted substrings for each prefix
    /// Default value applys blue tint highlighting to the `@` prefix
    open var autocompleteTextAttributes: [Character: [NSAttributedStringKey: Any]] =
        ["@": [.font: UIFont.preferredFont(forTextStyle: .body),
               .foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),
               .backgroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)]]
    
    // MARK: - Properties [Private]
    
    /// A key used for referencing which substrings were autocompletes
    private let NSAttributedAutocompleteKey = NSAttributedStringKey.init("com.messagekit.autocompletekey")
    
    /// A reference to `defaultTextAttributes` that adds the NSAttributedAutocompleteKey
    private var typingTextAttributes: [NSAttributedStringKey: Any] {
        var attributes = defaultTextAttributes
        attributes[NSAttributedAutocompleteKey] = false
        return attributes
    }
    
    /// The current autocomplete text options filtered by the text after the prefix
    private var currentAutocompleteOptions: [AutocompleteCompletion] {
        
        guard let session = currentSession, let completions = dataSource?.autocompleteManager(self, autocompleteSourceFor: session.prefix) else { return [] }
        guard !session.filter.isEmpty else { return completions }
        guard isCaseSensitive else { return completions.filter { $0.text.lowercased().contains(session.filter.lowercased()) } }
        return completions.filter { $0.text.contains(session.filter) }
    }
    
    // MARK: - Initialization
    
    public init(for textView: InputTextView) {
        super.init()
        self.inputTextView = textView
        self.inputTextView?.delegate = self
    }
    
    // MARK: - InputManager
    
    /// Reloads the InputManager's session
    open func reloadData() {
        
        /// Checks the last character in the UITextView, if it matches an autocomplete prefix it is registered as the current
        guard let text = inputTextView?.text else { return unregisterCurrentPrefix() }
        let suffix = String(text.suffix(1))
        guard !suffix.isEmpty else { return unregisterCurrentPrefix() }
        let char = Character(suffix)
        if autocompletePrefixes.contains(char) {
            let range = NSRange(location: text.count - 1, length: 0)
            registerCurrentPrefix(to: char, at: range)
        }
    }
    
    /// Invalidates the InputManager's session
    open func invalidate() {
        unregisterCurrentPrefix()
    }
    
    /// Passes an object into the InputManager's session to handle
    ///
    /// - Parameter object: A string to append
    open func handleInput(of object: AnyObject) {
        guard let newText = object as? String, let textView = inputTextView else { return }
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let newAttributedString = NSAttributedString(string: newText, attributes: typingTextAttributes)
        attributedString.append(newAttributedString)
        textView.attributedText = attributedString
        reloadData()
    }
    
    // MARK: - API [Public]
    
    /// Replaces the current prefix and filter text with the supplied text
    ///
    /// - Parameters:
    ///   - text: The replacement text
    open func autocomplete(with session: AutocompleteSession) {
        
        guard let textView = inputTextView else { return }
        guard delegate?.autocompleteManager(self, shouldComplete: session.prefix, with: session.filter) != false else { return }
        
        let textToInsert = (keepPrefixOnCompletion ? String(session.prefix) : "") + (session.completion?.text ?? "")
        
        // Apply the autocomplete attributes
        var attrs = autocompleteTextAttributes[session.prefix] ?? defaultTextAttributes
        attrs[NSAttributedAutocompleteKey] = true
        let newAttributedString = NSAttributedString(string: textToInsert, attributes: attrs)
        
        // Create a range that overlaps the prefix
        let range = NSRange(location: session.range.location, length: 1)
        
        // Replace the attributedText with a modified version
        let newAttributedText = textView.attributedText.replacingCharacters(in: range, with: newAttributedString)
        if appendSpaceOnCompletion {
            newAttributedText.append(NSAttributedString(string: " ", attributes: typingTextAttributes))
        }
        textView.attributedText = newAttributedText
        
        // Move Cursor to the end of the inserted text
        let newLocation = textToInsert.count + (appendSpaceOnCompletion ? 1 : 0)
        textView.selectedRange = NSRange(location: range.location + newLocation, length: 0)
        
        // End the session
        unregisterCurrentPrefix()
    }
    
    // MARK: - API [Private]
    
    /// Resets the `InputTextView`'s typingAttributes to `defaultTextAttributes`
    private func preserveTypingAttributes() {
        
        var typingAttributes = [String: Any]()
        typingTextAttributes.forEach { typingAttributes[$0.key.rawValue] = $0.value }
        inputTextView?.typingAttributes = typingAttributes
    }
    
    /// Initializes a session with a new `Selection` object for the given prefix and range
    ///
    /// - Parameters:
    ///   - prefix: The Character to register as the prefix of the Selection
    ///   - range: The NSRange to register for the Selection
    private func registerCurrentPrefix(to prefix: Character, at range: NSRange) {
        
        guard delegate?.autocompleteManager(self, shouldRegister: prefix, at: range) != false else { return }
        currentSession = AutocompleteSession(prefix: prefix, range: range, filter: "")
        delegate?.autocompleteManager(self, shouldBecomeVisible: true)
    }
    
    /// Invalidates the `currentSession` session if it existed
    private func unregisterCurrentPrefix() {
        
        guard let session = currentSession else { return }
        guard delegate?.autocompleteManager(self, shouldUnregister: session.prefix) != false else { return }
        currentSession = nil
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
    
    // MARK: - Helper Methods
    
    /// A safe way to generate an offset to the current prefix
    ///
    /// - Returns: An offset that is not more than the endIndex or less than the startIndex
    private func safeOffset(withText text: String) -> Int {
        
        guard let range = currentSession?.range else { return 0 }
        if text.count == 0 || range.lowerBound < 0 { return 0 }
        if range.lowerBound > (text.count - 1) { return text.count - 1 }
        return range.lowerBound
    }
    
}

extension AutocompleteManager: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate
    
    final public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Ensure that the text to be inserted is not using previous attributes
        preserveTypingAttributes()
        
        // range.length > 0: Backspace/removing text
        // range.lowerBound < textView.selectedRange.lowerBound: Ignore trying to delete
        //      the substring if the user is already doing so
        if range.length > 0, range.lowerBound < textView.selectedRange.lowerBound {
            
            // Backspace/removing text
            let attribute = textView.attributedText
                .attributes(at: range.lowerBound, longestEffectiveRange: nil, in: range)
                .filter { return $0.key == NSAttributedAutocompleteKey }
            
            if (attribute[NSAttributedAutocompleteKey] as? Bool ?? false) == true {
                
                // Remove the autocompleted substring
                let lowerRange = NSRange(location: 0, length: range.location + 1)
                textView.attributedText.enumerateAttribute(NSAttributedAutocompleteKey, in: lowerRange, options: .reverse, using: { (_, range, stop) in
                    
                    // Only delete the first found range
                    defer { stop.pointee = true }
                    
                    let emptyString = NSAttributedString(string: "", attributes: typingTextAttributes)
                    textView.attributedText = textView.attributedText.replacingCharacters(in: range, with: emptyString)
                })
                
                return false
            }
        }
        
        if let currentRange = currentSession?.range {
            // User deleted the registered prefix
            if currentRange.lowerBound >= range.lowerBound {
                unregisterCurrentPrefix()
                return true
            }
        }
        
        if let prefix = currentSession?.prefix {
            // A prefix is already regsitered so update the filter text
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let index = newText.index(newText.startIndex, offsetBy: safeOffset(withText: newText))
            currentSession?.filter = newText[index...].components(separatedBy: " ").first?.replacingOccurrences(of: String(prefix), with: "") ?? ""
        }
        
        let prefix = String(text.prefix(1))
        guard !prefix.isEmpty else { return true }
        let char = Character(prefix)
        
        // If a delimiter is typed unregister the current prefix
        if autocompleteDelimiters.contains(char) {
            unregisterCurrentPrefix()
            
        } else if autocompletePrefixes.contains(char) {
            
            // Autocomplete sessions begin with a prefix that is preceeded by a delimiter (or nil)
            let previousText = (textView.text as NSString).substring(to: range.lowerBound)
            if let previousChar = previousText.last, autocompleteDelimiters.contains(previousChar) {
                registerCurrentPrefix(to: char, at: range)
            } else if previousText.last == nil {
                registerCurrentPrefix(to: char, at: range)
            }
        }
        
        return true
    }

}

extension AutocompleteManager: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    final public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAutocompleteOptions.count
    }
    
    final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard var session = currentSession else { return UITableViewCell() }
        session.completion = currentAutocompleteOptions[indexPath.row]
        let cell = dataSource?.autocompleteManager(self, tableView: tableView, cellForRowAt: indexPath, for: session) ?? UITableViewCell()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    final public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard var session = currentSession else { return }
        session.completion = currentAutocompleteOptions[indexPath.row]
        autocomplete(with: session)
    }
    
}
