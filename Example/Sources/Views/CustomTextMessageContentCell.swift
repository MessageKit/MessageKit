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

class CustomTextMessageContentCell: CustomMessageContentCell {
  /// The label used to display the message's text.
  var messageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: .body)

    return label
  }()

  override func prepareForReuse() {
    super.prepareForReuse()

    messageLabel.attributedText = nil
    messageLabel.text = nil
  }

  override func setupSubviews() {
    super.setupSubviews()

    messageContainerView.addSubview(messageLabel)
  }

  override func configure(
    with message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView,
    dataSource: MessagesDataSource,
    and sizeCalculator: CustomLayoutSizeCalculator)
  {
    super.configure(
      with: message,
      at: indexPath,
      in: messagesCollectionView,
      dataSource: dataSource,
      and: sizeCalculator)

    guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
      return
    }

    let calculator = sizeCalculator as? CustomTextLayoutSizeCalculator
    messageLabel.frame = calculator?.messageLabelFrame(
      for: message,
      at: indexPath) ?? .zero

    let textMessageKind = message.kind
    switch textMessageKind {
    case .text(let text), .emoji(let text):
      let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
      messageLabel.text = text
      messageLabel.textColor = textColor
    case .attributedText(let text):
      messageLabel.attributedText = text
    default:
      break
    }
  }
}
