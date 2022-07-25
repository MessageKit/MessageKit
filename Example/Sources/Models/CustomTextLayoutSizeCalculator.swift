//
//  CustomTextMessageSizeCalculator.swift
//  ChatExample
//
//  Created by Vignesh J on 30/04/21.
//  Copyright © 2021 MessageKit. All rights reserved.
//

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
