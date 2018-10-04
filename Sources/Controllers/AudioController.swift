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

internal class AudioController: NSObject {

    /// The `AudioController` shared instance
    internal static let shared = AudioController()

    internal weak var messageCollectionView: MessagesCollectionView?

    /// The `AVAudioPlayer` that is playing the sound
    fileprivate var audioPlayer: AVAudioPlayer?

    /// The `Timer` that update playing progress
    fileprivate var progressTimer: Timer?

    /// The `AudioMessageCell` that is currently playing sound
    fileprivate var playingCell: AudioMessageCell?

    /// The `MessageType` that is currently playing sound
    fileprivate var playingMessage: MessageType?

    // MARK: - Init Methods
    private override init() {
        super.init()
    }

    // MARK: - Methods
    internal func configureCell(_ cell: AudioMessageCell, message: MessageType) {
        if playingMessage?.messageId == message.messageId, let player = audioPlayer {
            // cell needs to be configure since the current audio player is playing sound for receive message
            // This situation can happen when playing cell is reconfigured
            playingCell = cell
            cell.progressView.progress = (player.duration == 0) ? 0 : Float(player.currentTime/player.duration)
            cell.durationLabel.text = AudioMessageCell.durationString(from: Float(player.currentTime))
            cell.playButton.isSelected = (player.isPlaying == true) ? true : false
        }
    }

    internal func playSound(for audioCell: AudioMessageCell) {
        guard let message = self.getAssignMessageToCell(audioCell) else {
            print("No message found when traing to play the sound. This is probably a bug")
            return
        }
        if playingMessage?.messageId == message.messageId { // resume curently pause audio
            self.resumeSound()
        } else {
            if playingCell != nil { // there is a sound on other cell that is already playing or in pause - prepare to stop playing sound and play the sound for receive message
                stopAudioInCurrentPlayingCell()
            }
            // play sound
            switch message.kind {
            case .audio(let item):
                playingCell = audioCell
                playingMessage = message
                audioPlayer = try? AVAudioPlayer.init(contentsOf: item.url)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
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

    internal func pauseSound(for audioCell: AudioMessageCell) {
        audioPlayer?.pause()
        audioCell.playButton.isSelected = false // show play button on audio cell since the sound is on pause
        progressTimer?.invalidate()
        // call stop audio delegate
        if let cell = playingCell {
            cell.delegate?.didPauseAudio(in: cell)
        }
    }

    internal func stopAudioInCurrentPlayingCell() {
        // call stop audio delegate
        if let cell = playingCell {
            cell.delegate?.didStopAudio(in: cell)
        }
        // stop audio
        audioPlayer?.stop()  // stop method did not call audioPlayerDidFinishPlaying(player:,flag:)
        audioPlayerDidFinishPlaying(audioPlayer ?? AVAudioPlayer(), successfully: true)
    }

    // MARK: - Fire Methods
    @objc private func didFireProgressTimer(_ timer: Timer) {
        guard let player = audioPlayer, let cell = playingCell, let currentMessage = self.getAssignMessageToCell(cell) else {
            return
        }
        // 1. get the current message that decorates the playing cell
        // 2. check if current message is the same with playing message, if so then update the cell content
        // Note: Those messages differ in the case of cell reuse
        if currentMessage.messageId == playingMessage?.messageId {
            // messages are the same update cell content
            cell.progressView.progress = (player.duration == 0) ? 0 : Float(player.currentTime/player.duration)
            cell.durationLabel.text = AudioMessageCell.durationString(from: Float(player.currentTime))
        }
    }

    // MARK: - Private Methods
    private func startProgressTimer() {
        // reset timer first
        progressTimer?.invalidate()
        progressTimer = nil
        // start timer
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AudioController.didFireProgressTimer(_:)), userInfo: nil, repeats: true)
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

    private func getAssignMessageToCell(_ cell: AudioMessageCell) -> MessageType? {
        var returnMessage: MessageType? = nil
        if let indexPath = self.messageCollectionView?.indexPath(for: cell), let collectionView = self.messageCollectionView {
            returnMessage = collectionView.messagesDataSource?.messageForItem(at: indexPath, in: collectionView)
        }
        return returnMessage
    }

}

// MARK: - AVAudioPlayerDelegate
extension AudioController: AVAudioPlayerDelegate {

    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // get audio item from message
        var audioItem: AudioItem? = nil
        switch playingMessage?.kind {
        case .audio(let item)?: audioItem = item
        default: break
        }
        // update cell UI
        playingCell?.progressView.progress = 0.0
        playingCell?.playButton.isSelected = false
        if let item = audioItem {
            playingCell?.durationLabel.text = AudioMessageCell.durationString(from: item.duration)
        }
        // reset properties since audio finished
        progressTimer?.invalidate()
        progressTimer = nil
        audioPlayer = nil
        playingMessage = nil
        playingCell = nil
    }

}
