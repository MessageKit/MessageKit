//
//  CustomLayoutExampleViewController.swift
//  ChatExample
//
//  Created by Vignesh J on 30/04/21.
//  Copyright © 2021 MessageKit. All rights reserved.
//

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
