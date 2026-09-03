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

import Kingfisher
import MapKit
import MessageKit
import UIKit

class CustomLayoutExampleViewController: BasicExampleViewController {
  // MARK: Internal

  override func configureMessageCollectionView() {
    super.configureMessageCollectionView()
    messagesCollectionView.register(CustomTextMessageContentCell.self)
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }

  // MARK: - MessagesLayoutDelegate

  override func textCellSizeCalculator(
    for _: MessageType,
    at _: IndexPath,
    in _: MessagesCollectionView)
    -> CellSizeCalculator?
  {
    textMessageSizeCalculator
  }

  // MARK: - MessagesDataSource

  override func textCell(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView)
    -> UICollectionViewCell?
  {
    let cell = messagesCollectionView.dequeueReusableCell(
      CustomTextMessageContentCell.self,
      for: indexPath)
    cell.configure(
      with: message,
      at: indexPath,
      in: messagesCollectionView,
      dataSource: self,
      and: textMessageSizeCalculator)

    return cell
  }

  // MARK: Private

  private lazy var textMessageSizeCalculator = CustomTextLayoutSizeCalculator(
    layout: self.messagesCollectionView
      .messagesCollectionViewFlowLayout)
}
