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

import Foundation

// MARK: - Deprecated Protocols

@available(*, deprecated: 0.11.0, message: "LocationMessageDisplayDelegate has been deprecated in favor of MessagesDisplayDelegate")
typealias LocationMessageDisplayDelegate = MessagesDisplayDelegate

@available(*, deprecated: 0.11.0, message: "TextMessageDisplayDelegate has been deprecated in favor of MessagesDisplayDelegate")
typealias TextMessageDisplayDelegate = MessagesDisplayDelegate

@available(*, deprecated: 0.11.0, message: "LocationMessageLayoutDelegate has been deprecated in favor of MessagesDisplayDelegate")
typealias LocationMessageLayoutDelegate = MessagesLayoutDelegate

@available(*, deprecated: 0.11.0, message: "MediaMessageLayoutDelegate has been deprecated in favor of MessagesDisplayDelegate")
typealias MediaMessageLayoutDelegate = MessagesLayoutDelegate

// MARK: - AvatarAlignment

@available(*, deprecated: 0.11.0, message: "Removed in MessageKit 0.11.0. Please use AvatarPosition instead.")
public enum AvatarAlignment {}

// MARK: - MessagesLayoutDelegate

extension MessagesLayoutDelegate {
    
    /// Specifies the vertical alignment for the `AvatarView` in a `MessageCollectionViewCell`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `AvatarAlignment.cellBottom`.
    @available(*, deprecated: 0.11.0, message: "Removed in MessageKit 0.11.0. Please use avatarPosition(for:at:in:) instead.")
    public func avatarAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarAlignment {
        fatalError("Please use avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition instead.")
    }
    
}

// MARK: - MessagesCollectionViewFlowLayout

extension MessagesCollectionViewFlowLayout {
    
    /// A Boolean value that determines if the `AvatarView` is always on the leading
    /// side of a MessageCollectionViewCell.
    ///
    /// Setting this property to `true` causes `avatarAlwaysTrailing` to be set to `false`.
    ///
    /// The default value of this property is `false`.
    @available(*, deprecated: 0.11.0, message: "Removed in MessageKit 0.11.0. Please use the avatarPosition(for:at:in) delegate method.")
    public var avatarAlwaysLeading: Bool {
        fatalError("Fatal Error: avatarAlwaysLeading is no longer supported")
    }
    
    /// A Boolean value that determines if the `AvatarView` is always on the trailing
    /// side of a `MessageCollectionViewCell`.
    ///
    /// Setting this property to `true` causes `avatarAlwaysLeading` to be set to `false`.
    ///
    /// The default value of this property is `false`.
    @available(*, deprecated: 0.11.0, message: "Removed in MessageKit 0.11.0. Please use the avatarPosition(for:at:in) delegate method instead.")
    public var avatarAlwaysTrailing: Bool {
        fatalError("Fatal Error: avatarAlwaysTrailing is no longer supported")
    }
    
}

// MARK: - MessagesDataSource

extension MessagesDataSource {
    /// The `Avatar` information to be used by the `AvatarView`.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that will be displayed by this cell.
    ///   - indexPath: The `IndexPath` of the cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell will be displayed.
    ///
    /// The default value returned by this method is `Avatar()`.
    @available(*, deprecated: 0.12.1, message: "Removed in MessageKit 0.12.1.")
    func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
        fatalError("Fatal Error: avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) is no longer supported")
    }
}

// MARK: - MessagesViewController

extension MessagesViewController {
    /// A Boolean value that determines whether the `MessagesCollectionView` scrolls to the
    /// bottom on the view's first layout.
    ///
    /// The default value of this property is `false`.
    @available(*, deprecated: 0.11.1, message: "Removed in MessageKit 0.11.1.")
    open var scrollsToBottomOnFirstLayout: Bool {
        fatalError("Fatal Error: scrollsToBottomOnFirstLayout is no longer supported")
    }
}
