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

/// The `BasicAudioController` update UI for current audio cell that is playing a sound
/// and also creates and manage an `AVAudioPlayer` states, play, pause and stop.
open class BasicAudioController: NSObject, AudioControllerDelegate {

    /// The `AVAudioPlayer` that is playing the sound
    open var audioPlayer: AVAudioPlayer?

    /// The `AudioMessageCell` that is currently playing sound
    open var playingCell: AudioMessageCell?

    /// The `MessageType` that is currently playing sound
    open var playingMessage: MessageType?

    // The `MessagesCollectionView` where the playing cell exist
    public let messageCollectionView: MessagesCollectionView

    /// The `Timer` that update playing progress
    internal var progressTimer: Timer?

    // MARK: - Init Methods

    public init(messageCollectionView: MessagesCollectionView) {
        self.messageCollectionView = messageCollectionView
        super.init()
    }

    // MARK: - Methods

    /// Used to configure the audio cell UI:
    ///     1. play button selected state;
    ///     2. progresssView progress;
    ///     3. durationLabel text;
    ///
    /// - Parameters:
    ///   - cell: The `AudioMessageCell` that needs to be configure.
    ///   - message: The `MessageType` that configures the cell.
    ///
    /// - Note:
    ///   This protocol method is called by MessageKit every time an audio cell needs to be configure
    open func configureCell(_ cell: AudioMessageCell, message: MessageType) {
        if playingMessage?.messageId == message.messageId, let player = audioPlayer {
            // cell needs to be configure since the current audio player is playing sound for receive message
            // This situation can happen when playing cell is reconfigured
            playingCell = cell
            cell.progressView.progress = (player.duration == 0) ? 0 : Float(player.currentTime/player.duration)
            cell.playButton.isSelected = (player.isPlaying == true) ? true : false
            guard let displayDelegate = messageCollectionView.messagesDisplayDelegate else {
                fatalError(MessageKitError.nilMessagesDisplayDelegate)
            }
            cell.durationLabel.text = displayDelegate.formatDuration(Float(player.duration), for: cell, in: messageCollectionView)
        }
    }

    /// Used to start or resume the audio sound
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that contain the audio item to be played.
    ///   - audioCell: The `AudioMessageCell` that needs to be updated while audio is playing.
    open func playSound(for message: MessageType, in audioCell: AudioMessageCell) {
        if playingMessage?.messageId == message.messageId { // resume curently pause audio
            self.resumeSound()
        } else {
            if playingCell != nil { // there is a sound on other cell that is already playing or in pause - prepare to stop playing sound and play the sound for receive message
                stopAnyOngoingPLaying()
            }
            // play sound
            switch message.kind {
            case .audio(let item):
                playingCell = audioCell
                playingMessage = message
                audioPlayer = self.createAudioPlayer(url: item.url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.delegate = self
                audioPlayer?.play()
                audioCell.playButton.isSelected = true  // show pause button on audio cell since the sound is currently playing
                startProgressTimer()
                // call start audio delegate
                audioCell.delegate?.didStartAudio(in: audioCell)
            default:
                print("Error - can not play sound for a message that is not of kind .audio")
            }
        }
    }

    /// Used to pause the audio sound
    ///
    /// - Parameters:
    ///   - message: The `MessageType` that contain the audio item to be pause.
    ///   - audioCell: The `AudioMessageCell` that needs to be updated by the pause action.
    open func pauseSound(for message: MessageType, in audioCell: AudioMessageCell) {
        audioPlayer?.pause()
        audioCell.playButton.isSelected = false // show play button on audio cell since the sound is on pause
        progressTimer?.invalidate()
        // call stop audio delegate
        if let cell = playingCell {
            cell.delegate?.didPauseAudio(in: cell)
        }
    }

    /// Stops any ongoing audio playing if exists
    open func stopAnyOngoingPLaying() {
        guard let player = audioPlayer else { return } // If the audio player is nil then we don't need to go through the stopping logic
        player.stop()
        // update cell UI
        if let cell = playingCell {
            cell.progressView.progress = 0.0
            cell.playButton.isSelected = false
            guard let displayDelegate = messageCollectionView.messagesDisplayDelegate else {
                fatalError(MessageKitError.nilMessagesDisplayDelegate)
            }
            cell.durationLabel.text = displayDelegate.formatDuration(Float(player.duration), for: cell, in: messageCollectionView)
            cell.delegate?.didStopAudio(in: cell)
        }
        // reset properties since audio finished
        progressTimer?.invalidate()
        progressTimer = nil
        audioPlayer = nil
        playingMessage = nil
        playingCell = nil
    }

    // MARK: - Fire Methods
    @objc private func didFireProgressTimer(_ timer: Timer) {
        guard let player = audioPlayer, let cell = playingCell else {
            return
        }
        // check if can update playing cell
        if let playingCellIndexPath = messageCollectionView.indexPath(for: cell) {
            // 1. get the current message that decorates the playing cell
            // 2. check if current message is the same with playing message, if so then update the cell content
            // Note: Those messages differ in the case of cell reuse
            let currentMessage = messageCollectionView.messagesDataSource?.messageForItem(at: playingCellIndexPath, in: messageCollectionView)
            if currentMessage != nil && currentMessage?.messageId == playingMessage?.messageId {
                // messages are the same update cell content
                cell.progressView.progress = (player.duration == 0) ? 0 : Float(player.currentTime/player.duration)
                guard let displayDelegate = messageCollectionView.messagesDisplayDelegate else {
                    fatalError(MessageKitError.nilMessagesDisplayDelegate)
                }
                cell.durationLabel.text = displayDelegate.formatDuration(Float(player.duration), for: cell, in: messageCollectionView)
            }
        }
    }

    // MARK: - Private Methods
    private func startProgressTimer() {
        // reset timer first
        progressTimer?.invalidate()
        progressTimer = nil
        // start timer
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(BasicAudioController.didFireProgressTimer(_:)), userInfo: nil, repeats: true)
    }

    private func resumeSound() {
        audioPlayer?.play()
        playingCell?.playButton.isSelected = true // show pause button on audio cell since the sound is currently playing
        startProgressTimer()
        // call start audio delegate
        if let cell = playingCell {
            cell.delegate?.didStartAudio(in: cell)
        }
    }

    private func createAudioPlayer(url: URL) -> AVAudioPlayer? {
        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("Failed to create AVAudioPLayer for url: \(url),\n with error: \(error.localizedDescription)")
        }
        return audioPlayer
    }

}

// MARK: - AVAudioPlayerDelegate
extension BasicAudioController: AVAudioPlayerDelegate {

    open func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopAnyOngoingPLaying()
    }

}
