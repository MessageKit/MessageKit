/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

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
import AVFoundation

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class AudioMessageCell: MessageContentCell {

    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?

    /// The play button view to display on audio messages.
    open lazy var playButton: UIButton = {
        let playButton = UIButton.init(type: .custom)
        let playImage = AudioMessageCell.getImageWithName("play")
        let pauseImage = AudioMessageCell.getImageWithName("pause")
        playButton.setImage(playImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.setImage(pauseImage?.withRenderingMode(.alwaysTemplate), for: .selected)

        return playButton
    }()

    /// The time duration lable to display on audio messages.
    open lazy var durationLabel: UILabel = {
        let durationLabel = UILabel.init(frame: CGRect.zero)
        durationLabel.textAlignment = .right
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.text = "0:00"

        return durationLabel
    }()

    open lazy var progressView: UIProgressView = {
        let progressView = UIProgressView.init(progressViewStyle: .default)
        progressView.progress = 0.0

        return progressView
    }()











    /// Toggle play button from play state to pause state and inverse
    open func play() {
        self.playButton.isSelected = true
    }

    open func stop(with messageKind: MessageKind) {
        playButton.isSelected = false
        progressView.progress = 0.0
        // set total audio file duration
        switch messageKind {
        case .audio(let item):
            let audioAsset = AVURLAsset.init(url: item.url)
            let duration = CMTimeGetSeconds(audioAsset.duration)
            durationLabel.text = AudioMessageCell.durationString(from: duration)
        default: break
        }
    }

    open func pasue() {
        self.playButton.isSelected = false
    }

    open func isPlaying() -> Bool {
        return playButton.isSelected
    }

    open func updateProgress(percent: Float, duration: TimeInterval) {
        progressView.progress = percent
        durationLabel.text = AudioMessageCell.durationString(from: Float64(duration))
    }






    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        playButton.constraint(equalTo: CGSize(width: 25, height: 25))
        playButton.addConstraints(left: messageContainerView.leftAnchor, centerY: messageContainerView.centerYAnchor, leftConstant: 5)
        durationLabel.addConstraints(right: messageContainerView.rightAnchor, centerY: messageContainerView.centerYAnchor, rightConstant: 15)
        progressView.addConstraints(left: playButton.rightAnchor, right: durationLabel.leftAnchor, centerY: messageContainerView.centerYAnchor, leftConstant: 5, rightConstant: 5)
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(playButton)
        messageContainerView.addSubview(durationLabel)
        messageContainerView.addSubview(progressView)
        setupConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        progressView.progress = 0
        playButton.isSelected = false
    }

    /// Handle tap gesture on contentView and its subviews.
    override open func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        // compute play button touch area, currently play button size is (25, 25) which is hardly touchable
        // add 10 px around current button frame and test the touch against this new frame
        let playButtonTouchArea = CGRect.init(playButton.frame.origin.x - 10.0, playButton.frame.origin.y - 10, playButton.frame.size.width + 20, playButton.frame.size.height + 20)
        let translateTouchLocation = convert(touchLocation, to: messageContainerView)
        if playButtonTouchArea.contains(translateTouchLocation) {
            delegate?.didTapPlayButton(in: self)
        } else {
            // touch is not inside play button touch area, call super to hangle gesture
            super.handleTapGesture(gesture)
        }
    }

    // MARK: - Configure Cell

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        configureCellApperance(with: message, indexPath: indexPath, messagesCollectionView: messagesCollectionView)
        // default configuration of
        switch message.kind {
        case .audio(let mediaItem):
            // default configuration
            let audioAsset = AVURLAsset.init(url: mediaItem.url)
            let duration = CMTimeGetSeconds(audioAsset.duration)
            durationLabel.text = AudioMessageCell.durationString(from: duration)
            progressView.progress = 0.0
        default:
            break
        }
        // call delegate for more configurations, especialy when an audio file is already playing
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        displayDelegate.configureAudioCell(self, for: message, at: indexPath, in: messagesCollectionView)

    }

    private func configureCellApperance(with message: MessageType, indexPath: IndexPath, messagesCollectionView: MessagesCollectionView) {
        // modify elements constrains based on message direction (incoming or outgoing)
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let playButtonLeftConstrain = messageContainerView.constraints.filter({ $0.identifier == "left" }).first
        let durationLabelRightConstrain = messageContainerView.constraints.filter({ $0.identifier == "right" }).first
        if dataSource.isFromCurrentSender(message: message) == false { // outgoing message
            playButtonLeftConstrain?.constant = 12
            durationLabelRightConstrain?.constant = -8
        } else { // incoming message
            playButtonLeftConstrain?.constant = 5
            durationLabelRightConstrain?.constant = -15
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        let tintColor = displayDelegate.audioTintColor(for: message, at: indexPath, in: messagesCollectionView)
        playButton.imageView?.tintColor = tintColor
        durationLabel.textColor = tintColor
        progressView.tintColor = tintColor
    }

    // MARK: - Helpers

    private class func getImageWithName(_ imageName: String) -> UIImage? {
        let assetBundle = Bundle.messageKitAssetBundle()
        let imagePath = assetBundle.path(forResource: imageName, ofType: "png", inDirectory: "Images")
        let image = UIImage(contentsOfFile: imagePath ?? "")

        return image
    }

    private class func durationString(from duration: Float64) -> String {
        var retunValue = "0:00"
        // print the time as 0:ss if duration is up to 59 seconds
        // print the time as m:ss if duration is up to 59:59 seconds
        // print the time as h:mm:ss for anything longer
        if duration < 60 {
            retunValue = String(format: "0:%.02d", Int(duration.rounded(.up)))
        } else if duration < 3600 {
            retunValue = String(format: "%.02d:%.02d", Int(duration/60), Int(duration) % 60)
        } else {
            let hours = Int(duration/3600)
            let remainingMinutsInSeconds = Int(duration) - hours*3600
            retunValue = String(format: "%.02d:%.02d:%.02d", hours, Int(remainingMinutsInSeconds/60), Int(remainingMinutsInSeconds) % 60)
        }
        return retunValue
    }

}
