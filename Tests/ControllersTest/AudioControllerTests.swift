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

import XCTest
import AVFoundation
@testable import MessageKit

class AdioControllerTests: XCTestCase  {

    var audioController: BasicAudioController!
    var messageCollectionView: MessagesCollectionView!
    // swiftlint:disable weak_delegate
    private var displayDelegate = MockDisplayDelegate()
    // swiftlint:enable weak_delegate

    // MARK: - Overridden Methods

    override func setUp() {
        super.setUp()

        messageCollectionView = MessagesCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        messageCollectionView.messagesDisplayDelegate = displayDelegate
        audioController = BasicAudioController(messageCollectionView: messageCollectionView)
    }

    override func tearDown() {
        messageCollectionView = nil
        audioController = nil

        super.tearDown()
    }


    // MARK: - Test

    func testPlaySound() {
        let audioMessage = getAudioMessage()
        let audioCell = AudioMessageCell(frame: CGRect.zero)
        audioController.playSound(for: audioMessage, in: audioCell)
        XCTAssertNotNil(audioController.audioPlayer)
        XCTAssertNotNil(audioController.playingCell)
        XCTAssertNotNil(audioController.playingMessage)
        XCTAssertTrue(audioController.audioPlayer!.isPlaying, "Audio player should be playing")
        XCTAssertTrue(audioCell.playButton.isSelected, "Audio cell play button should be in selected state")
    }

    func testStopSound() {
        let audioMessage = getAudioMessage()
        let audioCell = AudioMessageCell(frame: CGRect.zero)
        audioController.playSound(for: audioMessage, in: audioCell)
        audioController.stopAnyOngoingPlaying()
        XCTAssertNil(audioController.audioPlayer)
        XCTAssertNil(audioController.playingCell)
        XCTAssertNil(audioController.playingMessage)
        XCTAssertEqual(audioCell.durationLabel.text, "0:04")
        XCTAssertFalse(audioController.audioPlayer?.isPlaying ?? false)
        XCTAssertFalse(audioCell.playButton.isSelected)
    }

    func testPauseSound() {
        let audioMessage = getAudioMessage()
        let audioCell = AudioMessageCell(frame: CGRect.zero)
        audioController.playSound(for: audioMessage, in: audioCell)
        audioController.pauseSound(for: audioMessage, in: audioCell)
        XCTAssertNotNil(audioController.audioPlayer)
        XCTAssertNotNil(audioController.playingCell)
        XCTAssertNotNil(audioController.playingMessage)
        XCTAssertFalse(audioController.audioPlayer?.isPlaying ?? false)
        XCTAssertFalse(audioCell.playButton.isSelected)
    }

    func testResumeSound() {
        let audioMessage = getAudioMessage()
        let audioCell = AudioMessageCell(frame: CGRect.zero)
        audioController.playSound(for: audioMessage, in: audioCell)
        audioController.pauseSound(for: audioMessage, in: audioCell)
        audioController.resumeSound()
        XCTAssertNotNil(audioController.audioPlayer)
        XCTAssertNotNil(audioController.playingCell)
        XCTAssertNotNil(audioController.playingMessage)
        XCTAssertTrue(audioController.audioPlayer?.isPlaying ?? false, "Audio player should be playing")
        XCTAssertTrue(audioCell.playButton.isSelected, "Audio cell play button should be in selected state")
    }

    func testConfigureAudioCellWhileIsCurrentlyPlaying() {
        let audioMessage = getAudioMessage()
        let audioCell = AudioMessageCell(frame: CGRect.zero)
        audioController.playSound(for: audioMessage, in: audioCell)
        audioController.configureAudioCell(audioCell, message: audioMessage)
        XCTAssertEqual(audioCell.durationLabel.text, "0:00")
        XCTAssertEqual(audioCell.progressView.progress, 0.0)
        XCTAssertTrue(audioCell.playButton.isSelected, "Audio cell play button should be in selected state")
    }

    func testConfigureAudioCellWhenOtherCellIsPlaying() {
        let playingMessage = getAudioMessage()
        let playingCell = AudioMessageCell(frame: CGRect.zero)
        let messageToConfigure = getAudioMessage("configure_message_Id")
        let cellToConfigure = AudioMessageCell(frame: CGRect.zero)
        audioController.playSound(for: playingMessage, in: playingCell)
        audioController.configureAudioCell(cellToConfigure, message: messageToConfigure)
        XCTAssertEqual(cellToConfigure.progressView.progress, 0.0)
        XCTAssertFalse(cellToConfigure.playButton.isSelected)
    }

    // MARK: - Helpers
    private func getAudioMessage(_ messageId: String = UUID().uuidString ) -> MockMessage {
        let audioURL = Bundle.init(for: AdioControllerTests.self).url(forResource: "sound1", withExtension: "m4a")!
        let audioMessage = MockMessage(audioURL: audioURL, duration: 4.0, sender: Sender(id: "sender_1", displayName: "Sender 1"), messageId: messageId)
        return audioMessage
    }

}


private class MockDisplayDelegate: MessagesDisplayDelegate {

    // MARK: - MessagesDisplayDelegate

    func audioProgressTextFormat(_ duration: Float, for audioCell: AudioMessageCell, in messageCollectionView: MessagesCollectionView) -> String {
        var retunValue = "0:00"
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
