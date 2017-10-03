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

open class AutocompleteManager: NSObject, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    open weak var dataSource: AutocompleteDataSource?
    
    open weak var delegate: AutocompleteDelegate?
    
    open weak var messageInputBar: MessageInputBar?
    
    /// The autocomplete table for @mention or #hastag
    open lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView()
        tableView.register(AutocompleteCell.self, forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 44
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    open var isCaseSensitive = false
    open var maxVisibleRows = 3
    open var autocompletePrefixes: [Character] = ["@","#"]
    
    open var currentAutocompleteText: [String]? {
        
        guard let prefix = currentPrefix, let filter = currentFilter else { return nil }
        if filter.isEmpty {
            return autocompleteMap[prefix]
        }
        if isCaseSensitive {
            return autocompleteMap[prefix]?.filter { $0.contains( filter ) }
        }
        return autocompleteMap[prefix]?.filter { $0.lowercased().contains(filter.lowercased()) }
    }
    
    private var autocompleteMap = [Character:[String]]()
    private var currentPrefix: Character?
    private var currentPrefixRange: Range<Int>?
    private var currentFilter: String? {
        didSet {
            tableView.reloadData()
            updateTableViewHeight()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentAutocompleteText?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            return UITableViewCell()
        }
        
        cell.prefix = currentPrefix
        cell.autocompleteText = currentAutocompleteText?[indexPath.row]
        cell.backgroundColor = messageInputBar?.backgroundView.backgroundColor ?? .inputBarGray
        cell.tintColor = messageInputBar?.tintColor
        dataSource?.autocomplete(self, cellConfigFor: cell, at: indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let replacementText = currentAutocompleteText?[indexPath.row] else { return }
        autocomplete(with: replacementText)
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Prevent a bounce up which leaves empty content in the background
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    // MARK: -  UITextViewDelegate
   
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // If a space is typed or text is pasted with a space unregister the current prefix
        guard !text.contains(" ") else {
            unregisterCurrentPrefix()
            return true
        }
        
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
            
        } else if let char = text.characters.first {
            // Check if the first character is a registered prefix
            if autocompletePrefixes.contains(char), let range = Range(range){
                registerCurrentPrefix(to: char, at: range)
            }
        }
        
        return true
    }
    
    // MARK: - Autocomplete
    
    private func registerCurrentPrefix(to prefix: Character, at range: Range<Int>) {
        currentPrefix = prefix
        currentPrefixRange = range
        autocompleteMap[prefix] = dataSource?.autocomplete(self, autocompleteTextFor: prefix, with: String()) ?? []
        currentFilter = String()
    }
    
    private func unregisterCurrentPrefix() {
        currentPrefix = nil
        currentPrefixRange = nil
        currentFilter = nil
        autocompleteMap.removeAll()
    }
    
    /// Updates the topStackView height constant in MessageInputBar to make room for the visible cells, but not more than the max visible allowed
    open func updateTableViewHeight() {
        
        let totalRows = currentAutocompleteText?.count ?? 0
        let visibleRows = maxVisibleRows < totalRows ? CGFloat(maxVisibleRows) : CGFloat(totalRows)
        messageInputBar?.setTopStackViewHeightConstant(to: visibleRows * tableView.rowHeight, animated: false)
    }
    
    /// Checks the last character in the UITextView, if it matches an autocomplete prefix it is registered as the current
    open func checkLastCharacter() {
        
        guard let characters = messageInputBar?.inputTextView.text.characters, let char = characters.last else {
            return
        }
        if autocompletePrefixes.contains(char), let range = Range(NSMakeRange(characters.count - 1, 0)) {
            registerCurrentPrefix(to: char, at: range)
        }
    }

    /// Completes a prefix by replacing the string after the prefix with the provided text
    ///
    /// - Parameters:
    ///   - prefix: The prefix
    ///   - autocompleteText: The text to insert
    ///   - enteredText: The text to replace
    /// - Returns: If the autocomplete was successful
    @discardableResult
    public func autocomplete(with text: String) -> Bool {
        
        guard let prefix = currentPrefix, let textView = messageInputBar?.inputTextView, let filterText = currentFilter else {
            return false
        }
        let leftIndex = textView.text.index(textView.text.startIndex, offsetBy: safeOffset(withText: textView.text))
        let rightIndex = textView.text.index(textView.text.startIndex, offsetBy: safeOffset(withText: textView.text) + filterText.characters.count)
        
        let range = leftIndex...rightIndex
        let textToInsert = String(prefix) + text.appending(" ")
        textView.text.replaceSubrange(range, with: textToInsert)
        
        // Move Cursor to the end of the inserted text
        textView.selectedRange = NSMakeRange(safeOffset(withText: textView.text) + textToInsert.characters.count, 0)
        
        // Unregister
        unregisterCurrentPrefix()
        return true
    }
    
    // MARK: - Helper Methods
    
    /// A safe way to generate an offset to the current prefix
    ///
    /// - Returns: An offset that is not more than the endIndex or less than the startIndex
    private func safeOffset(withText text: String) -> Int {
        
        guard let range = currentPrefixRange else { return 0 }
        if text.characters.count == 0 {
            return 0
        }
        if range.lowerBound > (text.characters.count - 1) {
            return text.characters.count - 1
        }
        if range.lowerBound < 0 {
            return 0
        }
        return range.lowerBound
    }
}
