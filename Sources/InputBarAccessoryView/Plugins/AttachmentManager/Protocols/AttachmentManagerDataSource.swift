//
//  AttachmentManagerDataSource.swift
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
//  Created by Nathan Tannar on 10/6/17.
//

import Foundation
import UIKit

/// AttachmentManagerDataSource is a protocol to passes data to the AttachmentManager
public protocol AttachmentManagerDataSource: AnyObject {
    
    /// The AttachmentCell for the attachment that is to be inserted into the AttachmentView
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - attachment: The object
    ///   - index: The index in the AttachmentView
    /// - Returns: An AttachmentCell
    func attachmentManager(_ manager: AttachmentManager, cellFor attachment: AttachmentManager.Attachment, at index: Int) -> AttachmentCell
    
    /// The CGSize of the AttachmentCell for the attachment that is to be inserted into the AttachmentView
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - attachment: The object
    ///   - index: The index in the AttachmentView
    /// - Returns: The size of the given attachment
    func attachmentManager(_ manager: AttachmentManager, sizeFor attachment: AttachmentManager.Attachment, at index: Int) -> CGSize?
}

public extension AttachmentManagerDataSource{
    
    // Default implementation, if data source method is not given, use autocalculated default.
    func attachmentManager(_ manager: AttachmentManager, sizeFor attachment: AttachmentManager.Attachment, at index: Int) -> CGSize? {
        return nil
    }
}
