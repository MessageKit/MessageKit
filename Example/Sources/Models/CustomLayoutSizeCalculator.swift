// MIT License
//
// Copyright (c) 2017-2026 MessageKit
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

// Created by Vignesh J on 01/05/21.

import MessageKit
import UIKit

class CustomLayoutSizeCalculator: CellSizeCalculator {
  // MARK: Lifecycle

  init(layout: MessagesCollectionViewFlowLayout? = nil) {
    super.init()

    self.layout = layout
  }

  // MARK: Internal

  var cellTopLabelVerticalPadding: CGFloat = 32
  var cellTopLabelHorizontalPadding: CGFloat = 32
  var cellMessageContainerHorizontalPadding: CGFloat = 48
  var cellMessageContainerExtraSpacing: CGFloat = 16
  var cellMessageContentVerticalPadding: CGFloat = 16
  var cellMessageContentHorizontalPadding: CGFloat = 16
  var cellDateLabelHorizontalPadding: CGFloat = 24
  var cellDateLabelBottomPadding: CGFloat = 8

  var messagesLayout: MessagesCollectionViewFlowLayout {
    layout as! MessagesCollectionViewFlowLayout
  }

  var messageContainerMaxWidth: CGFloat {
    messagesLayout.itemWidth -
      cellMessageContainerHorizontalPadding -
      cellMessageContainerExtraSpacing
  }

  var messagesDataSource: MessagesDataSource {
    messagesLayout.messagesDataSource
  }

  override func sizeForItem(at indexPath: IndexPath) -> CGSize {
    let dataSource = messagesDataSource
    let message = dataSource.messageForItem(
      at: indexPath,
      in: messagesLayout.messagesCollectionView)
    let itemHeight = cellContentHeight(
      for: message,
      at: indexPath)
    return CGSize(
      width: messagesLayout.itemWidth,
      height: itemHeight)
  }

  func cellContentHeight(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGFloat
  {
    cellTopLabelSize(
      for: message,
      at: indexPath).height +
      cellMessageBottomLabelSize(
        for: message,
        at: indexPath).height +
      messageContainerSize(
        for: message,
        at: indexPath).height
  }

  // MARK: - Top cell Label

  func cellTopLabelSize(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGSize
  {
    guard
      let attributedText = messagesDataSource.cellTopLabelAttributedText(
        for: message,
        at: indexPath) else
    {
      return .zero
    }

    let maxWidth = messagesLayout.itemWidth - cellTopLabelHorizontalPadding
    let size = attributedText.size(consideringWidth: maxWidth)
    let height = size.height + cellTopLabelVerticalPadding

    return CGSize(
      width: maxWidth,
      height: height)
  }

  func cellTopLabelFrame(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGRect
  {
    let size = cellTopLabelSize(
      for: message,
      at: indexPath)
    guard size != .zero else {
      return .zero
    }

    let origin = CGPoint(
      x: cellTopLabelHorizontalPadding / 2,
      y: 0)

    return CGRect(
      origin: origin,
      size: size)
  }

  func cellMessageBottomLabelSize(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGSize
  {
    guard
      let attributedText = messagesDataSource.messageBottomLabelAttributedText(
        for: message,
        at: indexPath) else
    {
      return .zero
    }
    let maxWidth = messageContainerMaxWidth - cellDateLabelHorizontalPadding

    return attributedText.size(consideringWidth: maxWidth)
  }

  func cellMessageBottomLabelFrame(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGRect
  {
    let messageContainerSize = messageContainerSize(
      for: message,
      at: indexPath)
    let labelSize = cellMessageBottomLabelSize(
      for: message,
      at: indexPath)
    let x = messageContainerSize.width - labelSize.width - (cellDateLabelHorizontalPadding / 2)
    let y = messageContainerSize.height - labelSize.height - cellDateLabelBottomPadding
    let origin = CGPoint(
      x: x,
      y: y)

    return CGRect(
      origin: origin,
      size: labelSize)
  }

  // MARK: - MessageContainer

  func messageContainerSize(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGSize
  {
    let labelSize = cellMessageBottomLabelSize(
      for: message,
      at: indexPath)
    let width = labelSize.width +
      cellMessageContentHorizontalPadding +
      cellDateLabelHorizontalPadding
    let height = labelSize.height +
      cellMessageContentVerticalPadding +
      cellDateLabelBottomPadding

    return CGSize(
      width: width,
      height: height)
  }

  func messageContainerFrame(
    for message: MessageType,
    at indexPath: IndexPath,
    fromCurrentSender: Bool)
    -> CGRect
  {
    let y = cellTopLabelSize(
      for: message,
      at: indexPath).height
    let size = messageContainerSize(
      for: message,
      at: indexPath)
    let origin: CGPoint
    if fromCurrentSender {
      let x = messagesLayout.itemWidth -
        size.width -
        (cellMessageContainerHorizontalPadding / 2)
      origin = CGPoint(x: x, y: y)
    } else {
      origin = CGPoint(
        x: cellMessageContainerHorizontalPadding / 2,
        y: y)
    }

    return CGRect(
      origin: origin,
      size: size)
  }
}
