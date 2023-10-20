// MIT License
//
// Copyright (c) 2017-2019 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import UIKit

extension MessagesLayoutDelegate {
  public func avatarSize(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGSize {
    fatalError("avatarSize(for:at:in) has been removed in MessageKit 1.0.")
  }

  public func avatarPosition(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> AvatarPosition {
    fatalError("avatarPosition(for:at:in) has been removed in MessageKit 1.0.")
  }

  public func messageLabelInset(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIEdgeInsets {
    fatalError("messageLabelInset(for:at:in) has been removed in MessageKit 1.0")
  }

  public func messagePadding(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIEdgeInsets {
    fatalError("messagePadding(for:at:in) has been removed in MessageKit 1.0.")
  }

  public func cellTopLabelAlignment(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> LabelAlignment {
    fatalError("cellTopLabelAlignment(for:at:in) has been removed in MessageKit 1.0.")
  }

  public func cellBottomLabelAlignment(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> LabelAlignment {
    fatalError("cellBottomLabelAlignment(for:at:in) has been removed in MessageKit 1.0.")
  }

  public func widthForMedia(message _: MessageType, at _: IndexPath, with _: CGFloat, in _: MessagesCollectionView) -> CGFloat {
    fatalError("widthForMedia(message:at:with:in) has been removed in MessageKit 1.0.")
  }

  public func heightForMedia(
    message _: MessageType,
    at _: IndexPath,
    with _: CGFloat,
    in _: MessagesCollectionView)
    -> CGFloat
  {
    fatalError("heightForMedia(message:at:with:in) has been removed in MessageKit 1.0.")
  }

  public func widthForLocation(
    message _: MessageType,
    at _: IndexPath,
    with _: CGFloat,
    in _: MessagesCollectionView)
    -> CGFloat
  {
    fatalError("widthForLocation(message:at:with:in) has been removed in MessageKit 1.0.")
  }

  public func heightForLocation(
    message _: MessageType,
    at _: IndexPath,
    with _: CGFloat,
    in _: MessagesCollectionView)
    -> CGFloat
  {
    fatalError("heightForLocation(message:at:with:in) has been removed in MessageKit 1.0.")
  }

  public func shouldCacheLayoutAttributes(for _: MessageType) -> Bool {
    fatalError("shouldCacheLayoutAttributes(for:) has been removed in MessageKit 1.0.")
  }
}
