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

public protocol MessageCellLayout {

    var incomingAvatarSize: CGSize { get set }
    var outgoingAvatarSize: CGSize { get set }

    var incomingAvatarPosition: AvatarPosition { get set }
    var outgoingAvatarPosition: AvatarPosition { get set }

    var incomingMessagePadding: UIEdgeInsets { get set }
    var outgoingMessagePadding: UIEdgeInsets { get set }

    var incomingCellTopLabelAlignment: LabelAlignment { get set }
    var outgoingCellTopLabelAlignment: LabelAlignment { get set }

    var incomingCellBottomLabelAlignment: LabelAlignment { get set }
    var outgoingCellBottomLabelAlignment: LabelAlignment { get set }

}

public struct TextMessageLayout: MessageCellLayout {


    public var incomingAvatarSize = CGSize(width: 30, height: 30)
    public var outgoingAvatarSize = CGSize(width: 30, height: 30)

    public var incomingAvatarPosition = AvatarPosition(vertical: .messageBottom)
    public var outgoingAvatarPosition = AvatarPosition(vertical: .messageBottom)

    public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18)

    public var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    public var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)

    public var incomingCellTopLabelAlignment = LabelAlignment.messageLeading(.zero)
    public var outgoingCellTopLabelAlignment = LabelAlignment.messageTrailing(.zero)

    public var incomingCellBottomLabelAlignment = LabelAlignment.messageTrailing(.zero)
    public var outgoingCellBottomLabelAlignment = LabelAlignment.messageLeading(.zero)

}

public struct MediaMessageLayout: MessageCellLayout {

    public var incomingAvatarSize = CGSize(width: 30, height: 30)
    public var outgoingAvatarSize = CGSize(width: 30, height: 30)

    public var incomingAvatarPosition = AvatarPosition(vertical: .messageBottom)
    public var outgoingAvatarPosition = AvatarPosition(vertical: .messageBottom)

    public var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    public var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)

    public var incomingCellTopLabelAlignment = LabelAlignment.messageLeading(.zero)
    public var outgoingCellTopLabelAlignment = LabelAlignment.messageTrailing(.zero)

    public var incomingCellBottomLabelAlignment = LabelAlignment.messageTrailing(.zero)
    public var outgoingCellBottomLabelAlignment = LabelAlignment.messageLeading(.zero)

}
