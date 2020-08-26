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

internal struct MessageKitError {
    static let avatarPositionUnresolved = "AvatarPosition Horizontal.natural needs to be resolved."
    static let nilMessagesDataSource = "MessagesDataSource has not been set."
    static let nilMessagesDisplayDelegate = "MessagesDisplayDelegate has not been set."
    static let nilMessagesLayoutDelegate = "MessagesLayoutDelegate has not been set."
    static let notMessagesCollectionView = "The collectionView is not a MessagesCollectionView."
    static let layoutUsedOnForeignType = "MessagesCollectionViewFlowLayout is being used on a foreign type."
    static let unrecognizedSectionKind = "Received unrecognized element kind:"
    static let unrecognizedCheckingResult = "Received an unrecognized NSTextCheckingResult.CheckingType"
    static let couldNotLoadAssetsBundle = "MessageKit: Could not load the assets bundle"
    static let couldNotCreateAssetsPath = "MessageKit: Could not create path to the assets bundle."
    static let customDataUnresolvedCell = "Did not return a cell for MessageKind.custom(Any)."
    static let customDataUnresolvedSize = "Did not return a size for MessageKind.custom(Any)."
    static let couldNotFindColorAsset = "MessageKit: Could not load the color asset."
}
