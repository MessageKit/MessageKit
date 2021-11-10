//
//  CustomMessageContentCell.swift
//  ChatExample
//
//  Created by Vignesh J on 01/05/21.
//  Copyright © 2021 MessageKit. All rights reserved.
//

import UIKit
import MessageKit

class CustomMessageContentCell: MessageCollectionViewCell {
    
    /// The `MessageCellDelegate` for the cell.
    weak var delegate: MessageCellDelegate?
    
    /// The container used for styling and holding the message's content view.
    var messageContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()

    /// The top label of the cell.
    var cellTopLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var cellDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellTopLabel.text = nil
        self.cellTopLabel.attributedText = nil
        self.cellDateLabel.text = nil
        self.cellDateLabel.attributedText = nil
    }
    
    /// Handle tap gesture on contentView and its subviews.
    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)

        switch true {
        case self.messageContainerView.frame.contains(touchLocation) && !self.cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            self.delegate?.didTapMessage(in: self)
        case self.cellTopLabel.frame.contains(touchLocation):
            self.delegate?.didTapCellTopLabel(in: self)
        case self.cellDateLabel.frame.contains(touchLocation):
            self.delegate?.didTapMessageBottomLabel(in: self)
        default:
            self.delegate?.didTapBackground(in: self)
        }
    }

    /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self)
        guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
        return self.messageContainerView.frame.contains(touchPoint)
    }
    
    func setupSubviews() {
        self.messageContainerView.layer.cornerRadius = 5
        
        self.contentView.addSubview(self.cellTopLabel)
        self.contentView.addSubview(self.messageContainerView)
        self.messageContainerView.addSubview(self.cellDateLabel)
    }
    
    func configure(with message: MessageType,
                   at indexPath: IndexPath,
                   in messagesCollectionView: MessagesCollectionView,
                   dataSource: MessagesDataSource,
                   and sizeCalculator: CustomLayoutSizeCalculator) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        self.cellTopLabel.frame = sizeCalculator.cellTopLabelFrame(for: message,
                                                                   at: indexPath)
        self.cellDateLabel.frame = sizeCalculator.cellMessageBottomLabelFrame(for: message,
                                                                     at: indexPath)
        self.messageContainerView.frame = sizeCalculator.messageContainerFrame(for: message,
                                                                               at: indexPath,
                                                                               fromCurrentSender: dataSource.isFromCurrentSender(message: message))
        self.cellTopLabel.attributedText = dataSource.cellTopLabelAttributedText(for: message,
                                                                                 at: indexPath)
        self.cellDateLabel.attributedText = dataSource.messageBottomLabelAttributedText(for: message,
                                                                                        at: indexPath)
        self.messageContainerView.backgroundColor = displayDelegate.backgroundColor(for: message,
                                                                                    at: indexPath,
                                                                                    in: messagesCollectionView)
        
    }

    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        false
    }
}
