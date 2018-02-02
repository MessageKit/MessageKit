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

/// AutocompleteManagerDataSource is a protocol that passes data to the AutocompleteManager
public protocol AutocompleteManagerDataSource: class {
    
    /// The autocomplete options for the registered prefix. Called once a prefix is registered.
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - prefix: The registered prefix
    /// - Returns: An array of autocomplete options for the given prefix
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteTextFor prefix: Character) -> [CompletionSource]
    
    /// The cell to populate the AutocompleteTableView with
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - tableView: The AttachmentManager's AutocompleteTableView
    ///   - indexPath: The indexPath of the cell
    ///   - arguments: The registered prefix, current filter text after the prefix and the autocomplete text that the user has selected
    /// - Returns: A UITableViewCell to populate the AutocompleteTableView. Default is `manager.defaultCell(in: tableView, at: indexPath, for: arguments)`
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for selection: AutocompleteManager.Selection) -> UITableViewCell
}

public extension AutocompleteManagerDataSource {
    
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for selection: AutocompleteManager.Selection) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("AutocompleteCell is not registered")
        }
        
        let completionText = (selection.completion?.displayText ?? selection.completion?.text) ?? "nil"
        
        // Bolds the text that currently matches the filter
        let matchingRange = (completionText as NSString).range(of: selection.filter, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString().normal(completionText)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)], range: matchingRange)
        let stringWithPrefix = NSMutableAttributedString().normal(String(selection.prefix))
        stringWithPrefix.append(attributedString)
        cell.textLabel?.attributedText = stringWithPrefix
        cell.backgroundColor = .white
        cell.separatorLine.isHidden = tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row
        return cell
        
    }

}


