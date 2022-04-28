//
//  AttachmentManagerDelegate.swift
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

import UIKit

/// AttachmentManagerDelegate is a protocol that can recieve notifications from the AttachmentManager
public protocol AttachmentManagerDelegate: AnyObject {
    
    /// Can be used to determine if the AttachmentManager should be inserted into an InputStackView
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - shouldBecomeVisible: If the AttachmentManager should be presented or dismissed
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool)
    
    
    /// Notifys when an attachment has been inserted into the AttachmentManager
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - attachment: The attachment that was inserted
    ///   - index: The index of the attachment in the AttachmentManager's attachments array
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int)
    
    /// Notifys when an attachment has been removed from the AttachmentManager
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - attachment: The attachment that was removed
    ///   - index: The index of the attachment in the AttachmentManager's attachments array
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int)
    
    /// Notifys when the AttachmentManager was reloaded
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - attachments: The AttachmentManager's attachments array
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment])
    
    /// Notifys when the AddAttachmentCell was selected
    ///
    /// - Parameters:
    ///   - manager: The AttachmentManager
    ///   - attachments: The index of the AddAttachmentCell
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int)
}

public extension AttachmentManagerDelegate {
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {}
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {}
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {}
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {}
}
