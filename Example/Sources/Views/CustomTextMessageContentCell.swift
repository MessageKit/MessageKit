//
//  CustomTextMessageContentCell.swift
//  ChatExample
//
//  Created by Vignesh J on 01/05/21.
//  Copyright © 2021 MessageKit. All rights reserved.
//

import UIKit
import MessageKit

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
        
        self.messageLabel.attributedText = nil
        self.messageLabel.text = nil
    }

    override func setupSubviews() {
        super.setupSubviews()
        
        self.messageContainerView.addSubview(self.messageLabel)
    }
    
    override func configure(with message: MessageType,
                            at indexPath: IndexPath,
                            in messagesCollectionView: MessagesCollectionView,
                            dataSource: MessagesDataSource,
                            and sizeCalculator: CustomLayoutSizeCalculator) {
        super.configure(with: message,
                        at: indexPath,
                        in: messagesCollectionView,
                        dataSource: dataSource,
                        and: sizeCalculator)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }

        let calculator = sizeCalculator as? CustomTextLayoutSizeCalculator
        self.messageLabel.frame = calculator?.messageLabelFrame(for: message,
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
