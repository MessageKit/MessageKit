//
//  AutocompleteSession.swift
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

import Foundation

/// A class containing data on the `AutocompleteManager`'s session
public class AutocompleteSession {
    
    public let prefix: String
    public let range: NSRange
    public var filter: String
    public var completion: AutocompleteCompletion?
    internal var spaceCounter: Int = 0
    
    public init?(prefix: String?, range: NSRange?, filter: String?) {
        guard let pfx = prefix, let rng = range, let flt = filter else { return nil }
        self.prefix = pfx
        self.range = rng
        self.filter = flt
    }
}

extension AutocompleteSession: Equatable {

    public static func == (lhs: AutocompleteSession, rhs: AutocompleteSession) -> Bool {
        return lhs.prefix == rhs.prefix && lhs.range == rhs.range
    }
}
