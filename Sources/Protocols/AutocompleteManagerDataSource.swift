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
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteTextFor prefix: Character) -> [String]
    
    
    /// The text to autocomplete a prefix with if you need to specify a difference between the autocomplete text a user can select
    /// with what is inserted.
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - arguments: The registered prefix, current filter text after the prefix and the autocomplete text that the user has selected
    /// - Returns: The string that the registered prefix will be autocomplete with. Default is `String(arguments.prefix) + arguments.autocompleteText`
    func autocompleteManager(_ manager: AutocompleteManager, replacementTextFor arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> String
    
    
    /// The cell to populate the AutocompleteTableView with
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - tableView: The AttachmentManager's AutocompleteTableView
    ///   - indexPath: The indexPath of the cell
    ///   - arguments: The registered prefix, current filter text after the prefix and the autocomplete text that the user has selected
    /// - Returns: A UITableViewCell to populate the AutocompleteTableView. Default is `manager.defaultCell(in: tableView, at: indexPath, for: arguments)`
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> UITableViewCell
}

public extension AutocompleteManagerDataSource {
    
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> UITableViewCell {
        return manager.defaultCell(in: tableView, at: indexPath, for: arguments)
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, replacementTextFor arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> String {
        return String(arguments.prefix) + arguments.autocompleteText
    }
}


