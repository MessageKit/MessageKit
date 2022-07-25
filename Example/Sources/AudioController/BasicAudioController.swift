// MIT License
//
// Copyright (c) 2017-2019 MessageKit
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

import AVFoundation
import MessageKit
import UIKit

// MARK: - PlayerState

/// The `PlayerState` indicates the current audio controller state
public enum PlayerState {
  /// The audio controller is currently playing a sound
  case playing

  /// The audio controller is currently in pause state
  case pause

  /// The audio controller is not playing any sound and audioPlayer is nil
  case stopped
}

// MARK: - BasicAudioController

/// The `BasicAudioController` update UI for current audio cell that is playing a sound
/// and also creates and manage an `AVAudioPlayer` states, play, pause and stop.
open class BasicAudioController: NSObject, AVAudioPlayerDelegate {
  // MARK: Lifecycle

  // MARK: - Init Methods

  public init(messageCollectionView: MessagesCollectionView) {
    self.messageCollectionView = messageCollectionView
    super.init()
  }

  // MARK: Open

  /// The `AVAudioPlayer` that is playing the sound
  open var audioPlayer: AVAudioPlayer?

  /// The `AudioMessageCell` that is currently playing sound
  open weak var playingCell: AudioMessageCell?

  /// The `MessageType` that is currently playing sound
  open var playingMessage: MessageType?

  /// Specify if current audio controller state: playing, in pause or none
  open private(set) var state: PlayerState = .stopped

  // MARK: - Methods

  /// Used to configure the audio cell UI:
  ///     1. play button selected state;
  ///     2. progressView progress;
  ///     3. durationLabel text;
  ///
  /// - Parameters:
  ///   - cell: The `AudioMessageCell` that needs to be configure.
  ///   - message: The `MessageType` that configures the cell.
  ///
  /// - Note:
  ///   This protocol method is called by MessageKit every time an audio cell needs to be configure
  open func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
    if playingMessage?.messageId == message.messageId, let collectionView = messageCollectionView, let player = audioPlayer {
      playingCell = cell
      cell.progressView.progress = (player.duration == 0) ? 0 : Float(player.currentTime / player.duration)
      cell.playButton.isSelected = (player.isPlaying == true) ? true : false
      guard let displayDelegate = collectionView.messagesDisplayDelegate else {
        fatalError("MessagesDisplayDelegate has not been set.")
      }
      cell.durationLabel.text = displayDelegate.audioProgressTextFormat(
        Float(player.currentTime),
        for: cell,
        in: collectionView)
    }
  }

  /// Used to start play audio sound
  ///
  /// - Parameters:
  ///   - message: The `MessageType` that contain the audio item to be played.
  ///   - audioCell: The `AudioMessageCell` that needs to be updated while audio is playing.
  open func playSound(for message: MessageType, in audioCell: AudioMessageCell) {
    switch message.kind {
    case .audio(let item):
      playingCell = audioCell
      playingMessage = message
      guard let player = try? AVAudioPlayer(contentsOf: item.url) else {
        print("Failed to create audio player for URL: \(item.url)")
        return
      }
      audioPlayer = player
      audioPlayer?.prepareToPlay()
      audioPlayer?.delegate = self
      audioPlayer?.play()
      state = .playing
      audioCell.playButton.isSelected = true // show pause button on audio cell
      startProgressTimer()
      audioCell.delegate?.didStartAudio(in: audioCell)
    default:
      print("BasicAudioPlayer failed play sound because given message kind is not Audio")
    }
  }

  /// Used to pause the audio sound
  ///
  /// - Parameters:
  ///   - message: The `MessageType` that contain the audio item to be pause.
  ///   - audioCell: The `AudioMessageCell` that needs to be updated by the pause action.
  open func pauseSound(for _: MessageType, in audioCell: AudioMessageCell) {
    audioPlayer?.pause()
    state = .pause
    audioCell.playButton.isSelected = false // show play button on audio cell
    progressTimer?.invalidate()
    if let cell = playingCell {
      cell.delegate?.didPauseAudio(in: cell)
    }
  }

  /// Stops any ongoing audio playing if exists
  open func stopAnyOngoingPlaying() {
    guard
      let player = audioPlayer,
      let collectionView = messageCollectionView
    else { return } // If the audio player is nil then we don't need to go through the stopping logic
    player.stop()
    state = .stopped
    if let cell = playingCell {
      cell.progressView.progress = 0.0
      cell.playButton.isSelected = false
      guard let displayDelegate = collectionView.messagesDisplayDelegate else {
        fatalError("MessagesDisplayDelegate has not been set.")
      }
      cell.durationLabel.text = displayDelegate.audioProgressTextFormat(
        Float(player.duration),
        for: cell,
        in: collectionView)
      cell.delegate?.didStopAudio(in: cell)
    }
    progressTimer?.invalidate()
    progressTimer = nil
    audioPlayer = nil
    playingMessage = nil
    playingCell = nil
  }

  /// Resume a currently pause audio sound
  open func resumeSound() {
    guard let player = audioPlayer, let cell = playingCell else {
      stopAnyOngoingPlaying()
      return
    }
    player.prepareToPlay()
    player.play()
    state = .playing
    startProgressTimer()
    cell.playButton.isSelected = true // show pause button on audio cell
    cell.delegate?.didStartAudio(in: cell)
  }

  // MARK: - AVAudioPlayerDelegate
  open func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
    stopAnyOngoingPlaying()
  }

  open func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) {
    stopAnyOngoingPlaying()
  }

  // MARK: Public

  // The `MessagesCollectionView` where the playing cell exist
  public weak var messageCollectionView: MessagesCollectionView?

  // MARK: Internal

  /// The `Timer` that update playing progress
  internal var progressTimer: Timer?

  // MARK: Private

  // MARK: - Fire Methods
  @objc
  private func didFireProgressTimer(_: Timer) {
    guard let player = audioPlayer, let collectionView = messageCollectionView, let cell = playingCell else {
      return
    }
    // check if can update playing cell
    if let playingCellIndexPath = collectionView.indexPath(for: cell) {
      // 1. get the current message that decorates the playing cell
      // 2. check if current message is the same with playing message, if so then update the cell content
      // Note: Those messages differ in the case of cell reuse
      let currentMessage = collectionView.messagesDataSource?.messageForItem(at: playingCellIndexPath, in: collectionView)
      if currentMessage != nil, currentMessage?.messageId == playingMessage?.messageId {
        // messages are the same update cell content
        cell.progressView.progress = (player.duration == 0) ? 0 : Float(player.currentTime / player.duration)
        guard let displayDelegate = collectionView.messagesDisplayDelegate else {
          fatalError("MessagesDisplayDelegate has not been set.")
        }
        cell.durationLabel.text = displayDelegate.audioProgressTextFormat(
          Float(player.currentTime),
          for: cell,
          in: collectionView)
      } else {
        // if the current message is not the same with playing message stop playing sound
        stopAnyOngoingPlaying()
      }
    }
  }

  // MARK: - Private Methods
  private func startProgressTimer() {
    progressTimer?.invalidate()
    progressTimer = nil
    progressTimer = Timer.scheduledTimer(
      timeInterval: 0.1,
      target: self,
      selector: #selector(BasicAudioController.didFireProgressTimer(_:)),
      userInfo: nil,
      repeats: true)
  }
}
