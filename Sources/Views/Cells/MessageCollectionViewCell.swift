/*
 MIT License
 
 Copyright (c) 2017 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

open class MessageCollectionViewCell<ContentView: UIView>: UICollectionViewCell, CollectionViewReusable {
    open class func reuseIdentifier() -> String { return "messagekit.cell.base-cell" }

    // MARK: - Properties

    open var messageContainerView: MessageContainerView = {
        let messageContainerView = MessageContainerView()
        messageContainerView.clipsToBounds = true
        messageContainerView.layer.masksToBounds = true
        return messageContainerView
    }()

    open var avatarView: AvatarView = AvatarView()

    open var cellTopLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    open var messageContentView: ContentView = {
        let contentView = ContentView()
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true
        return contentView
    }()

    open var cellBottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    open weak var delegate: MessageCellDelegate?

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizers()
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    internal func setupSubviews() {
        contentView.addSubview(cellTopLabel)
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageContentView)
        contentView.addSubview(avatarView)
        contentView.addSubview(cellBottomLabel)
    }

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }

        avatarView.frame = attributes.avatarFrame

        messageContainerView.frame = attributes.messageContainerFrame
        messageContentView.frame = messageContainerView.bounds
        cellTopLabel.frame = attributes.topLabelFrame
        cellBottomLabel.frame = attributes.bottomLabelFrame

    }

    open override func prepareForReuse() {
        cellTopLabel.text = nil
        cellTopLabel.attributedText = nil
        cellBottomLabel.text = nil
        cellBottomLabel.attributedText = nil
    }

    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {

        // Check if delegate has already been set to reduce number of assignments
        if delegate == nil, let cellDelegate = messagesCollectionView.messageCellDelegate {
            delegate = cellDelegate
        }

        if let displayDelegate = messagesCollectionView.messagesDisplayDelegate {

            let messageColor = displayDelegate.backgroundColor(for: message, at: indexPath, in: messagesCollectionView)
            let messageStyle = displayDelegate.messageStyle(for: message, at: indexPath, in: messagesCollectionView)

            messageContainerView.backgroundColor = messageColor
            messageContainerView.style = messageStyle
        }

        // Make sure we set all data source properties after configuring display delegate properties
        // The MessageLabel class probably has a stateful issue
        if let dataSource = messagesCollectionView.messagesDataSource {

            let avatar = dataSource.avatar(for: message, at: indexPath, in: messagesCollectionView)
            let topLabelText = dataSource.cellTopLabelAttributedText(for: message, at: indexPath)
            let bottomLabelText = dataSource.cellBottomLabelAttributedText(for: message, at: indexPath)

            avatarView.set(avatar: avatar)
            cellTopLabel.attributedText = topLabelText
            cellBottomLabel.attributedText = bottomLabelText
        }

    }

    func setupGestureRecognizers() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        contentView.addGestureRecognizer(tapGesture)
        
    }
    
    /// Handle tap gesture on contentView and its subviews like messageContainerView, cellTopLabel, cellBottomLabel, avatarView ....
    @objc func handleTapGesture(_ gesture: UIGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        
        let touchLocation = gesture.location(in: self)
        if messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContentView)) {
            delegate?.didTapMessage(in: self)
        }
        else if cellTopLabel.frame.contains(touchLocation) {
            delegate?.didTapTopLabel(in: self)
        }
        else if cellBottomLabel.frame.contains(touchLocation) {
            delegate?.didTapBottomLabel(in: self)
        }
        else if avatarView.frame.contains(touchLocation) {
            delegate?.didTapAvatar(in: self)
        }
    
    }
    
    /// Handle `ContentView`'s tap gesture, return false when `ContentView` don't needs to handle gesture
    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return false
    }

}
