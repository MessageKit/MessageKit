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

// Created by Vignesh J on 30/04/21.

import MessageKit
import UIKit

class CustomTextLayoutSizeCalculator: CustomLayoutSizeCalculator {
  var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
  var cellMessageContainerRightSpacing: CGFloat = 16

  override func messageContainerSize(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGSize
  {
    let size = super.messageContainerSize(
      for: message,
      at: indexPath)
    let labelSize = messageLabelSize(
      for: message,
      at: indexPath)
    let selfWidth = labelSize.width +
      cellMessageContentHorizontalPadding +
      cellMessageContainerRightSpacing
    let width = max(selfWidth, size.width)
    let height = size.height + labelSize.height

    return CGSize(
      width: width,
      height: height)
  }

  func messageLabelSize(
    for message: MessageType,
    at _: IndexPath)
    -> CGSize
  {
    let attributedText: NSAttributedString

    let textMessageKind = message.kind
    switch textMessageKind {
    case .attributedText(let text):
      attributedText = text
    case .text(let text), .emoji(let text):
      attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
    default:
      fatalError("messageLabelSize received unhandled MessageDataType: \(message.kind)")
    }

    let maxWidth = messageContainerMaxWidth -
      cellMessageContentHorizontalPadding -
      cellMessageContainerRightSpacing

    return attributedText.size(consideringWidth: maxWidth)
  }

  func messageLabelFrame(
    for message: MessageType,
    at indexPath: IndexPath)
    -> CGRect
  {
    let origin = CGPoint(
      x: cellMessageContentHorizontalPadding / 2,
      y: cellMessageContentVerticalPadding / 2)
    let size = messageLabelSize(
      for: message,
      at: indexPath)

    return CGRect(
      origin: origin,
      size: size)
  }
}
