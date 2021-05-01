//
//  CustomLayoutExampleViewController.swift
//  ChatExample
//
//  Created by Vignesh J on 30/04/21.
//  Copyright © 2021 MessageKit. All rights reserved.
//

import UIKit
import MapKit
import MessageKit
import Kingfisher

class CustomLayoutExampleViewController: BasicExampleViewController {
    
    private lazy var textMessageSizeCalculator: CustomTextLayoutSizeCalculator = CustomTextLayoutSizeCalculator(layout: self.messagesCollectionView.messagesCollectionViewFlowLayout)
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        self.messagesCollectionView.register(CustomTextMessageContentCell.self)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    // MARK: - MessagesLayoutDelegate
    
    override func textCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return self.textMessageSizeCalculator
    }
    
    // MARK: - MessagesDataSource
    
    override func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        let cell = messagesCollectionView.dequeueReusableCell(CustomTextMessageContentCell.self,
                                                              for: indexPath)
        cell.configure(with: message,
                       at: indexPath,
                       in: messagesCollectionView,
                       dataSource: self,
                       and: self.textMessageSizeCalculator)
        
        return cell
    }
}
