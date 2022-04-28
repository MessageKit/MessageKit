//
//  AutocompleteManagerDataSource.swift
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
//  Created by Nathan Tannar on 10/1/17.
//

import UIKit

/// AutocompleteManagerDataSource is a protocol that passes data to the AutocompleteManager
public protocol AutocompleteManagerDataSource: AnyObject {
    
    /// The autocomplete options for the registered prefix.
    ///
    /// - Parameters:
    ///   - manager: The AutocompleteManager
    ///   - prefix: The registered prefix
    /// - Returns: An array of `AutocompleteCompletion` options for the given prefix
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteSourceFor prefix: String) -> [AutocompleteCompletion]
    
    /// The cell to populate the `AutocompleteTableView` with
    ///
    /// - Parameters:
    ///   - manager: The `AttachmentManager` that sources the UITableViewDataSource
    ///   - tableView: The `AttachmentManager`'s `AutocompleteTableView`
    ///   - indexPath: The `IndexPath` of the cell
    ///   - session: The current `Session` of the `AutocompleteManager`
    /// - Returns: A UITableViewCell to populate the `AutocompleteTableView`
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell
}

public extension AutocompleteManagerDataSource {
    
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("AutocompleteCell is not registered")
        }
        
        cell.textLabel?.attributedText = manager.attributedText(matching: session, fontSize: 13)
        if #available(iOS 13, *) {
            cell.backgroundColor = .systemBackground
        } else {
            cell.backgroundColor = .white
        }
        cell.separatorLine.isHidden = tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row
        return cell
        
    }
    
}
