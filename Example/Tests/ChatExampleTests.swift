//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://messagekit.github.io
//
//
//  GitHub
//  https://github.com/MessageKit/MessageKit
//
//
//  License
//  Copyright (c) 2016-present Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
@testable import ChatExample

@MainActor
final class ChatExampleTests: XCTestCase {
  /// Settings lets every message type be switched off. `randomMessageType()` used to
  /// force unwrap the empty result, which crashed the app on the next message.
  func testRandomMessageTypeFallsBackToTextWhenNothingIsEnabled() {
    let defaults = UserDefaults.standard
    let keys = SampleData.MessageTypes.allCases.map { "\($0.rawValue) Messages" }
    let previous = keys.map { defaults.object(forKey: $0) }
    defer {
      for (key, value) in zip(keys, previous) {
        value.map { defaults.set($0, forKey: key) } ?? defaults.removeObject(forKey: key)
      }
    }

    for key in keys {
      defaults.set(false, forKey: key)
    }

    XCTAssertEqual(SampleData.shared.randomMessageType(), .Text)
  }
}
