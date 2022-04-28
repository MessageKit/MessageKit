//
//  NSMutableAttributedString+Extensions.swift
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
//  Created by Nathan Tannar on 8/25/17.
//

import UIKit

internal extension NSMutableAttributedString {
 
    @discardableResult
    func bold(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize, textColor: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key:AnyObject] = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor : textColor
        ]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult
    func medium(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize, textColor: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key:AnyObject] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium),
            NSAttributedString.Key.foregroundColor : textColor
        ]
        let mediumString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(mediumString)
        return self
    }
    
    @discardableResult
    func italic(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize, textColor: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key:AnyObject] = [
            NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor : textColor
        ]
        let italicString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(italicString)
        return self
    }
    
    @discardableResult
    func normal(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize, textColor: UIColor) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key:AnyObject] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor : textColor
        ]
        let normal =  NSMutableAttributedString(string: text, attributes: attrs)
        self.append(normal)
        return self
    }

    @discardableResult
    func bold(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize) -> NSMutableAttributedString {
        if #available(iOS 13, *) {
            return bold(text, fontSize: fontSize, textColor: .label)
        } else {
            return bold(text, fontSize: fontSize, textColor: .black)
        }
    }

    @discardableResult
    func medium(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize) -> NSMutableAttributedString {
        if #available(iOS 13, *) {
            return medium(text, fontSize: fontSize, textColor: .label)
        } else {
            return medium(text, fontSize: fontSize, textColor: .black)
        }
    }

    @discardableResult
    func italic(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize) -> NSMutableAttributedString {
        if #available(iOS 13, *) {
            return italic(text, fontSize: fontSize, textColor: .label)
        } else {
            return italic(text, fontSize: fontSize, textColor: .black)

        }
    }

    @discardableResult
    func normal(_ text: String, fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize) -> NSMutableAttributedString {
        if #available(iOS 13, *) {
            return normal(text, fontSize: fontSize, textColor: .label)
        } else {
            return normal(text, fontSize: fontSize, textColor: .black)
        }
    }
}

internal extension NSAttributedString {

    func replacingCharacters(in range: NSRange, with attributedString: NSAttributedString) -> NSMutableAttributedString {
        let ns = NSMutableAttributedString(attributedString: self)
        ns.replaceCharacters(in: range, with: attributedString)
        return ns
    }
    
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        lhs = ns
    }
    
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        return NSAttributedString(attributedString: ns)
    }
    
}
