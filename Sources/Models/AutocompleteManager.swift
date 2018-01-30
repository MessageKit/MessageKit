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

open class AutocompleteManager: NSObject, InputManager, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    open weak var dataSource: AutocompleteManagerDataSource?
    
    open weak var delegate: AutocompleteManagerDelegate?
    
    private(set) public weak var inputTextView: InputTextView?
    
    /// The autocomplete table for @mention or #hastag
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
    
    /// If the autocomplete matches should be made by casting the strings to lowercase
    open var isCaseSensitive = false
    
    /// The max visible rows visible in the autocomplete table before the user has to scroll throught them
    open var maxVisibleRows = 3
    
    /// The prefices that the manager will recognize
    open var autocompletePrefixes: [Character] = ["@", "#"]
    
    /// The default text attributes
    open var defaultTextAttributes: [NSAttributedStringKey:Any] = [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
                                                                   NSAttributedStringKey.foregroundColor : UIColor.black]
    
    /// The text attributes applied to highlighted substrings for each prefix
    open var highlightedTextAttributes: [Character:[NSAttributedStringKey:Any]] =
        ["@":[NSAttributedStringKey.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),
              NSAttributedStringKey.backgroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)]]
    
    private var highlightedSubstrings = [Character:[String]]()
    private var autocompleteText = [String]()
    private var currentPrefix: Character?
    private var currentPrefixRange: Range<Int>?
    private var currentFilter: String? {
        didSet {
            tableView.reloadData()
            tableView.invalidateIntrinsicContentSize()
            tableView.superview?.layoutIfNeeded()
        }
    }
    
    // MARK: - Initialization
    
    public init(for textView: InputTextView) {
        super.init()
        self.inputTextView = textView
        self.inputTextView?.delegate = self
    }
    
    // MARK: - InputManager
    
    open func reload() {
        checkLastCharacter()
        highlightSubstrings()
    }
    
    open func invalidate() {
        unregisterCurrentPrefix()
    }
    
    open func handleInput(of object: AnyObject) {
        guard let newText = object as? String, let textView = inputTextView else { return }
        let newAttributedString = NSMutableAttributedString(attributedString: textView.attributedText).normal(newText)
        textView.attributedText = newAttributedString
        reload()
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAutocompleteText().count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let prefix = currentPrefix, let filterText = currentFilter else { return UITableViewCell() }
        let autocompleteText = currentAutocompleteText()[indexPath.row]
        let cell = dataSource?.autocompleteManager(self, tableView: tableView, cellForRowAt: indexPath, for: (prefix, filterText, autocompleteText)) ?? UITableViewCell()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let prefix = currentPrefix, let filterText = currentFilter else { return }
        let replacementText = currentAutocompleteText()[indexPath.row]
        if let dataSource = dataSource {
            let customReplacementText = dataSource.autocompleteManager(self, replacementTextFor: (prefix, filterText, replacementText))
            autocomplete(with: customReplacementText)
        }
        autocomplete(with: String(prefix) + replacementText)
    }

    // MARK: - UITextViewDelegate
   
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Ensure that the text to be inserted is not using previous attributes
        resetTypingAttributes()
        
        // User deleted the registered prefix
        if let currentRange = currentPrefixRange {
            if currentRange.lowerBound >= range.lowerBound {
                unregisterCurrentPrefix()
                return true
            }
        }
        
        if let prefix = currentPrefix {
            // A prefix is already regsitered so update the filter text
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let index = newText.index(newText.startIndex, offsetBy: safeOffset(withText: newText))
            currentFilter = newText[index...]
                .components(separatedBy: " ")
                .first?
                .replacingOccurrences(of: String(prefix), with: "")
        }
        
        let prefix = String(text.prefix(1))
        guard !prefix.isEmpty else { return true }
        let char = Character(prefix)
        // If a space is typed or text is pasted with a space/newline unregister the current prefix
        if char == " " || char == Character("\n") {
            unregisterCurrentPrefix()
           
        } else if autocompletePrefixes.contains(char), let range = Range(range) {
            let previousText = (textView.text as NSString).substring(to: range.lowerBound)
            if previousText.last == " " || previousText.last == Character("\n")  || previousText.last == nil {
                // Check if the first character is a registered prefix
                registerCurrentPrefix(to: char, at: range)
            }
        }
        
        return true
    }
    
    // MARK: - Text Highlighting
    
    /// Resets the InputTextViews typingAttributes to defaultTextAttributes
    open func resetTypingAttributes() {
        
        var typingAttributes = [String:Any]()
        defaultTextAttributes.forEach { typingAttributes[$0.key.rawValue] = $0.value }
        inputTextView?.typingAttributes = typingAttributes
    }
    
    /// Applies highlighting to substrings that begin with a registered prefix
    open func highlightSubstrings() {

        guard let textView = inputTextView else { return }
        let attributedString = NSMutableAttributedString(string: textView.text, attributes: defaultTextAttributes)
        
        // Get the substrings with a prefix
        let substrings = textView.text
            .components(separatedBy: " ")
            .filter {
                guard let prefix = $0.first, $0.count > 1 else { return false }
                guard self.highlightedTextAttributes[prefix] != nil else { return false } // if there are no custom attributes
                return self.autocompletePrefixes.contains(prefix)
        }
        
        // Calculate the NSRange of each substring
        substrings.forEach { substring in
            var ranges = [NSRange]()
            var searchStartIndex = textView.text.startIndex
            while searchStartIndex < textView.text.endIndex, let range = textView.text.range(of: substring, range: searchStartIndex..<textView.text.endIndex), !range.isEmpty {
                
                let utf16 = textView.text.utf16
                if let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) {
                    let nsrange = NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                                          length: utf16.distance(from: from, to: to))
                    ranges.append(nsrange)
                }
                searchStartIndex = range.upperBound
            }
            // Apply the attributes
            if let prefix = substring.first, let textAttributes = self.highlightedTextAttributes[prefix] {
                ranges.forEach { attributedString.addAttributes(textAttributes, range: $0) }
            }
        }
        
        // Set the new attributed string
        textView.attributedText = attributedString
    }
    
    // MARK: - Autocomplete
    
    private func registerCurrentPrefix(to prefix: Character, at range: Range<Int>) {
        
        guard delegate?.autocompleteManager(self, shouldRegister: prefix, at: range) != false else { return }
        currentPrefix = prefix
        currentPrefixRange = range
        autocompleteText = dataSource?.autocompleteManager(self, autocompleteTextFor: prefix) ?? []
        currentFilter = String()
        delegate?.autocompleteManager(self, shouldBecomeVisible: true)
    }
    
    private func unregisterCurrentPrefix() {
        
        guard let prefix = currentPrefix else { return }
        guard delegate?.autocompleteManager(self, shouldUnregister: prefix) != false else { return }
        currentPrefixRange = nil
        autocompleteText.removeAll()
        currentPrefix = nil
        currentFilter = nil
        delegate?.autocompleteManager(self, shouldBecomeVisible: false)
    }
    
    /// Checks the last character in the UITextView, if it matches an autocomplete prefix it is registered as the current
    private func checkLastCharacter() {
        
        guard let text = inputTextView?.text else {
            unregisterCurrentPrefix()
            return
        }
        let suffix = String(text.suffix(1))
        guard !suffix.isEmpty else { return unregisterCurrentPrefix() }
        let char = Character(suffix)
        if autocompletePrefixes.contains(char), let range = Range(NSMakeRange(text.count - 1, 0)) {
            registerCurrentPrefix(to: char, at: range)
        }
    }
    
    /// The current autocomplete text options filtered by the text after the prefix
    open func currentAutocompleteText() -> [String] {
        
        guard let filter = currentFilter else { return [] }
        guard !filter.isEmpty else { return autocompleteText }
        guard isCaseSensitive else { return autocompleteText.filter { $0.lowercased().contains(filter.lowercased()) } }
        return autocompleteText.filter { $0.contains( filter ) }
    }

    /// Replaces the current prefix and filter text with the supplied text
    ///
    /// - Parameters:
    ///   - text: The replacement text
    public func autocomplete(with text: String) {
        
        guard let prefix = currentPrefix, let textView = inputTextView, let filterText = currentFilter else { return }
        guard delegate?.autocompleteManager(self, shouldComplete: prefix, with: text) != false else { return }
        
        let textToInsert = text + " "
        
        // Calculate the range to replace
        let leftIndex = textView.text.index(textView.text.startIndex, offsetBy: safeOffset(withText: textView.text))
        let rightIndex = textView.text.index(leftIndex, offsetBy: filterText.count)
        let range = leftIndex...rightIndex
        
        // Insert the text
        textView.text.replaceSubrange(range, with: textToInsert)
        
        // Apply the highlight attributes
        highlightSubstrings()
        
        // Move Cursor to the end of the inserted text
        textView.selectedRange = NSMakeRange(safeOffset(withText: textView.text) + textToInsert.count, 0)
        
        // Unregister
        unregisterCurrentPrefix()
    }
    
    // MARK: - Helper Methods
    
    /// A safe way to generate an offset to the current prefix
    ///
    /// - Returns: An offset that is not more than the endIndex or less than the startIndex
    private func safeOffset(withText text: String) -> Int {
        
        guard let range = currentPrefixRange else { return 0 }
        if text.count == 0 {
            return 0
        }
        if range.lowerBound > (text.count - 1) {
            return text.count - 1
        }
        if range.lowerBound < 0 {
            return 0
        }
        return range.lowerBound
    }
    
    // MARK: - Default Autocomplete Cell
    
    open func defaultCell(in tableView: UITableView, at indexPath: IndexPath, for arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("AutocompleteCell is not registered")
        }
        
        let matchingRange = (arguments.autocompleteText as NSString).range(of: arguments.filterText, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString().normal(arguments.autocompleteText)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)], range: matchingRange)
        let stringWithPrefix = NSMutableAttributedString().normal(String(arguments.prefix))
        stringWithPrefix.append(attributedString)
        cell.textLabel?.attributedText = stringWithPrefix
        
        cell.backgroundColor = .white
        cell.tintColor = inputTextView?.tintColor ?? UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        cell.separatorLine.isHidden = indexPath.row == currentAutocompleteText().count - 1
        
        return cell
    }
}
