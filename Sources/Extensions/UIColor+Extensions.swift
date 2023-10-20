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

import Foundation
import UIKit

extension UIColor {
  // MARK: Internal

  internal static var incomingMessageBackground: UIColor { colorFromAssetBundle(named: "incomingMessageBackground") }

  internal static var outgoingMessageBackground: UIColor { colorFromAssetBundle(named: "outgoingMessageBackground") }

  internal static var incomingMessageLabel: UIColor { colorFromAssetBundle(named: "incomingMessageLabel") }

  internal static var outgoingMessageLabel: UIColor { colorFromAssetBundle(named: "outgoingMessageLabel") }

  internal static var incomingAudioMessageTint: UIColor { colorFromAssetBundle(named: "incomingAudioMessageTint") }

  internal static var outgoingAudioMessageTint: UIColor { colorFromAssetBundle(named: "outgoingAudioMessageTint") }

  internal static var collectionViewBackground: UIColor { colorFromAssetBundle(named: "collectionViewBackground") }

  internal static var typingIndicatorDot: UIColor { colorFromAssetBundle(named: "typingIndicatorDot") }

  internal static var label: UIColor { colorFromAssetBundle(named: "label") }

  internal static var avatarViewBackground: UIColor { colorFromAssetBundle(named: "avatarViewBackground") }

  // MARK: Private

  private static func colorFromAssetBundle(named: String) -> UIColor {
    guard let color = UIColor(named: named, in: Bundle.messageKitAssetBundle, compatibleWith: nil) else {
      fatalError(MessageKitError.couldNotFindColorAsset)
    }
    return color
  }
}
