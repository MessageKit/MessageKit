# CHANGELOG

The changelog for `MessageKit`. Also see the [releases](https://github.com/MessageKit/MessageKit/releases) on GitHub.

--------------------------------------

## Upcoming release

### Added

-  **Breaking Change** Added `InputItem`, a protocol that `InputBarButtonItem` now conforms to. `MessageInputBar` has been switch to allow items that conform to `InputItem` so you no longer are restricted to just `InputBarButtonItem`
[#279](https://github.com/MessageKit/MessageKit/pull/279) by [@nathantannar4](https://github.com/nathantannar4).

- Added `removedCachedAttributes(for:MessageType)`, `removeAllCachedAttributes()`, and `attributesCacheMaxSize` to
`MessagesCollectionViewFlowLayout` to manage the caching of layout information for messages.
[#263](https://github.com/MessageKit/MessageKit/pull/263) by [@SD10](https://github.com/sd10).

-  Created `SeparatorLine` and `InputStackView` as their own subclass of `UIView` and `UIStackView` respectively. This just improves reusability.
[#273](https://github.com/MessageKit/MessageKit/pull/273) by [@nathantannar4](https://github.com/nathantannar4).

### Changed

-  **Breaking Change**  The property enum used to define the stack view position, `MessageInputBar.UIStackViewPosition` was changed to the enum `InputStackView.Position`
[#279](https://github.com/MessageKit/MessageKit/pull/279) by [@nathantannar4](https://github.com/nathantannar4).

- Layout anchors for the `MessagesCollectionView` and `MessageInputBar` now include the safeAreaLayoutGuide to fix layout issues on iPhone X
[#280](https://github.com/MessageKit/MessageKit/pull/280) by [@nathantannar4](https://github.com/nathantannar4).


-  **Breaking Change**  The properties `leftStackView`, `rightStackView` and `bottomStackView` in `MessageInputBar` are now of type `InputStackView`. The property `separatorLine` is also now of type `SeparatorLine` in `MessageInputBar`.
[#273](https://github.com/MessageKit/MessageKit/pull/273) by [@nathantannar4](https://github.com/nathantannar4).

- Layout information is now being cached by `MessagesCollectionViewFlowLayout` for each `MessageType` using the
`messageId` property. (This means if your layout is dynamic over the `IndexPath` you need to handle cache invalidation).
[#263](https://github.com/MessageKit/MessageKit/pull/263) by [@SD10](https://github.com/sd10).

### Fixed

-  Fixed a bug that prevented the `textAllignment` property of `InputTextView`'s `placeholderLabel` from having noticable differences when changed to `.center` or `.right`.
[#262](https://github.com/MessageKit/MessageKit/pull/262) by [@nathantannar4](https://github.com/nathantannar4).

-  Initial `contentInset.bottom` reference changed from `messageInputBar` to `inputAccessoryView` to allow custom `inputAccessoryView`'s that don't break the initial layout.
[#267](https://github.com/MessageKit/MessageKit/pull/262) by [@nathantannar4](https://github.com/nathantannar4).

-  Changes the `MessageInputBar` bottom `UIStackView`'s `bottomAnchor` to `layoutMarginsGuide.bottomAnchor` to fix issues on the iPhone X.
[#266](https://github.com/MessageKit/MessageKit/pull/266) by [@nathantannar4](https://github.com/nathantannar4).

-  Initial `contentInset.bottom` reference changed from `messageInputBar` to `inputAccessoryView` to allow custom inp`inputAccessoryView`'s that don't break the initial layout
[#267](https://github.com/MessageKit/MessageKit/pull/262) by [@nathantannar4](https://github.com/nathantannar4).

### Removed

- **Breaking Change** Removed `additionalTopContentInset` property of `MessagesViewController` because this is no longer necessary
when `extendedLayoutIncludesOpaqueBars` is `true`.
[#250](https://github.com/MessageKit/MessageKit/pull/250) by [@SD10](https://github.com/SD10).

## [[Prerelease] 0.9.0](https://github.com/MessageKit/MessageKit/releases/tag/0.9.0)

### Added

- **Breaking Change** `.custom((MessageContainerView)->Void)` case to `MessageStyle` enum. 
[#163](https://github.com/MessageKit/MessageKit/pull/163) by [@SD10](https://github.com/SD10).

- **Breaking Change** `UIEdgeInsets` associated value to all `LabelAlignment` enum cases. 
[#166](https://github.com/MessageKit/MessageKit/pull/166) by [@SD10](https://github.com/SD10).

- **Breaking Change** `.emoji(String)` case to `MessageData` enum. 
[#222](https://github.com/MessageKit/MessageKit/pull/222) by [@SirArkimdes](https://github.com/SirArkimedes).

- **Breaking Change** `TextMessageDisplayDelegate` to handle `enabledDetecors(for:at:in)` and moves `textColor(for:at:in)` to this namespace.
[#230](https://github.com/MessageKit/MessageKit/pull/230) by [@SD10](https://github.com/sd10)

- `LocationMessageDisplayDelegate` to customize a location messages appearance and add a `MKAnnotationView` to location message snapshots. 
[#150](https://github.com/MessageKit/MessageKit/pull/150) by [@etoledom](https://github.com/etoledom).

- `messageLabelInsets(for:indexPath:messagesCollectionView` method to `MessagesLayoutDelegate`. 
[#162](https://github.com/MessageKit/MessageKit/pull/162) by [@SD10](https://github.com/SD10).

- `animationBlockForLocation(message:indexPath:messagesCollectionView)` method to `LocationMessageDisplayDelegate` to customize the display animation of the location message's map.
[#210](https://github.com/MessageKit/MessageKit/pull/210) by [@etoledom](https://github.com/etoledom).

- `scrollsToBottomOnFirstLayout` property to automatically scroll to the bottom of `MessagesCollectionView` on first load.
[#213](https://github.com/MessageKit/MessageKit/pull/213) by [@FraDeliro](https://github.com/FraDeliro).

- `scrollsToBottomOnKeyboardDidBeginEditing` property to automatically scroll to the bottom of `MessagesCollectionView` when the keyboard begins editing.
[#217](https://github.com/MessageKit/MessageKit/pull/217) by [@SD10](https://github.com/SD10).

- `additionalTopContentInset` property to `MessagesColectionViewController` to allow users to account for extra subviews.
[#218](https://github.com/MessageKit/MessageKit/pull/218) by [@SD10](https://github.com/SD10).

- `messagePadding(for:at:in)` method to `MessagesLayoutDelegate` to dynamically set padding around `MessageContainerView`.
[#208](https://github.com/MessageKit/MessageKit/pull/208) by [@SD10](https://github.com/SD10).

### Fixed

-  `MessageInputBar` now correctly sizes itself when breaking its max height or pasting in large amounts of text
[#173](https://github.com/MessageKit/MessageKit/pull/173) by [@nathantannar4](https://github.com/nathantannar4).

- `MessageInputBar` faced a rendering issue on subsequent presentations of a `MessageViewController`. This was originally patched by adding a copy to the view during `viewDidAppear(animated:)` however that led to other issues [#116](https://github.com/MessageKit/MessageKit/issues/116). A correct patch has now been applied.
[#178](https://github.com/MessageKit/MessageKit/pull/178) by [@nathantannar4](https://github.com/nathantannar4).

- Incorrect sizing of `MessagesCollectionView`s content inset by setting `extendedLayoutIncludesOpaqueBars` to true by default.
[#204](https://github.com/MessageKit/MessageKit/pull/204) by [@SD10](https://github.com/SD10).

- `scrollIndicatorInsets` to match the insets of the `MessagesCollectionView`.
[#174](https://github.com/MessageKit/MessageKit/pull/174) by [@etoledom](https://github.com/etoledom).

- `MediaMessageCell` had an offset `PlayButtonView` that was being constrained to the cell and not the message container.
[#239](https://github.com/MessageKit/MessageKit/pull/239) by [@SirArkimedes](https://github.com/SirArkimedes).

### Changed

- **Breaking Change** `snapshotOptionsForLocation` method is now part of `LocationMessageDisplayDelegate`. 
[#150](https://github.com/MessageKit/MessageKit/pull/150) by [@etoledom](https://github.com/etoledom).

- **Breaking Change** `setMapSnapshotImage` now includes an `annotationView: MKAnnotationView?` argument. 
[#150](https://github.com/MessageKit/MessageKit/pull/150) by [@etoledom](https://github.com/etoledom).

- **Breaking Change** `messageLabelInsets` has been made into a method on `MessagesLayoutDelegate`. 
[#162](https://github.com/MessageKit/MessageKit/pull/162) by [@SD10](https://github.com/SD10).

- **Breaking Change** `messageLabelInsets` now defaults to a `left` inset of 18 for incoming messages
 and a `right` inset of 18 for outgoing messages. 
[#162](https://github.com/MessageKit/MessageKit/pull/162) by [@SD10](https://github.com/SD10).

- **Breaking Change** `InputTextView`'s `UITextViewDelegate` is now set to `self`
[#173](https://github.com/MessageKit/MessageKit/pull/173) by [@nathantannar4](https://github.com/nathantannar4).

- **Breaking Change** `MessagesDisplayDelegate` `messageHeaderView(for:at:in)` and `messageFooterView(for:at:in)` to return non-optionals.
[#229](https://github.com/MessageKit/MessageKit/pull/229) by [@SD10](https://github.com/SD10).

- **Breaking Change** `MessagesCollectionView` `dequeueMessageHeaderView(withIdentifier:for:)` & `dequeueMessageFooterView(widthIdentifier:for:)`
have been renamed to `dequeueReusableHeaderView(CollectionViewReusable.Type,for:)` & `dequeueReusableFooterView(CollectionViewReusable.Type,for:)`.
[#229](https://github.com/MessageKit/MessageKit/pull/229) by [@SD10](https://github.com/SD10).

- `configure` method of all `MessageCollectionViewCell` types to be marked as `open`.
[#200](https://github.com/MessageKit/MessageKit/pull/200) by [@SD10](https://github.com/sd10).

- `MessageHeaderView`, `MessageFooterView`, and `MessageDateHeaderView` initializers to be `public`.
[#175](https://github.com/MessageKit/MessageKit/pull/175) by [@cwalo](https://github.com/cwalo).

- `UICollectionViewDataSource` and `UICollectionViewDelegate` methods of `MessagesViewController` to be `open`.
[#177](https://github.com/MessageKit/MessageKit/pull/177) by [@cwalo](https://github.com/cwalo).

### Removed

- **Breaking Change** `cellTopLabelInsets` and `cellBottomLabelInsets` from `MessagesCollectionViewFlowLayout`.
[#166](https://github.com/MessageKit/MessageKit/pull/166) by [@SD10](https://github.com/SD10).

- **Breaking Change** `messageToViewEdgePadding` on `MessagesCollectionViewFlowLayout` in favor of `messagePadding(for:at:in)`.
[#208](https://github.com/MessageKit/MessageKit/pull/208) by [@SD10](https://github.com/SD10).

## [[Prerelease] 0.8.2](https://github.com/MessageKit/MessageKit/releases/tag/0.8.2)
### Added
- Support for Swift 4

## [[Prerelease] 0.8.1](https://github.com/MessageKit/MessageKit/releases/tag/0.8.1)
### Added
- Support for Swift 3.2 and Xcode 9

## [[Prerelease] 0.8.0](https://github.com/MessageKit/MessageKit/releases/tag/0.8.0)

This release closes the [0.8 milestone](https://github.com/MessageKit/MessageKit/milestone/9?closed=1).

### Added
- **Breaking Change** `MessageData` now supports `.photo(UIImage)`, `.location(CLLocation)`, `.video(file: URL, thumbnail: UIImage)` cases.
- **Breaking Change** `MessageCollectionViewCell` is now generic over its `ContentView` constrained to `UIView`.
- **Breaking Change** `TextMessageCell` subclass of `MessageCollectionViewCell` to support text messages.
- `MediaMessageCell` subclass of `MessageCollectionViewCell` to support photo/video messages.
- `LocationMessageCell` subclass of `MessageCollectionViewCell` to support location messages.
- Adds `LocationMessageLayoutDelegate` for sizing of location messages.
- Adds `MediaMessageLayoutDelegate` for sizing of media messages.
- `AvatarView` now supports `fontMinimumScaleFactor`, `placeholderFontColor`, and `placeholderFont` properties

### Changed
- Keyboard handling no longer adjusts the top & bottom insets for `MessagesCollectionView`.
- `MessageStyle`s are now applied as a `mask` on the `MessageContainerView`

### Deprecated
- `MessageCollectionViewCell`'s `messageLabel` has been renamed to `messageContentView`
- `AvatarView`'s `setBackground(color: UIColor)` method has been deprecated in favor of `backgroundColor`
- `AvatarView`'s `getImage()` method has been deprecated in favor of a new `image` property.

### Fixed
- Fixes extra height on text messages due to font specified in `MessagesCollectionViewFlowLayout` not being applied.
- `AvatarView`'s placeholder image is no longer constrained to a size of `30 x 30`.
- `AvatarView`'s placeholder text can now auto-adjust based on available width.

## [[Prerelease] 0.7.4](https://github.com/MessageKit/MessageKit/releases/tag/0.7.4)

- Fixes invalid image path for Carthage resources.

## [[Prerelease] 0.7.3](https://github.com/MessageKit/MessageKit/releases/tag/0.7.3)

- Fixes missing asset bundle resources for Carthage installation.

## [[Prerelease] 0.7.2](https://github.com/MessageKit/MessageKit/releases/tag/0.7.2)

## [[Prerelease] 0.7.1](https://github.com/MessageKit/MessageKit/releases/tag/0.7.1)

- Fixes missing asset bundle resources in framework.

## [[Prerelease] 0.7.0](https://github.com/MessageKit/MessageKit/releases/tag/0.7.0)

This release closes the [0.7 milestone](https://github.com/MessageKit/MessageKit/milestone/8?closed=1)

## [[Prerelease] 0.6.0](https://github.com/MessageKit/MessageKit/releases/tag/0.6.0)

This release closes the [0.6 milestone](https://github.com/MessageKit/MessageKit/milestone/7?closed=1).

## [[Prerelease] 0.5.0](https://github.com/MessageKit/MessageKit/releases/tag/0.5.0)

This release closes the [0.5 milestone](https://github.com/MessageKit/MessageKit/milestone/5?closed=1).

## [[Prerelease] 0.4.0](https://github.com/MessageKit/MessageKit/releases/tag/0.4.0)

This release closes the [0.4 milestone](https://github.com/MessageKit/MessageKit/milestone/4?closed=1).

## [[Prerelease] 0.3.0](https://github.com/MessageKit/MessageKit/releases/tag/0.3.0)

This release closes the [0.3 milestone](https://github.com/MessageKit/MessageKit/milestone/3?closed=1).

## [[Prerelease] 0.2.0](https://github.com/MessageKit/MessageKit/releases/tag/0.2.0)

This release closes the [0.2 milestone](https://github.com/MessageKit/MessageKit/milestone/2?closed=1).

## [[Prerelease] 0.1.0](https://github.com/MessageKit/MessageKit/releases/tag/0.1.0)

This release closes the [0.1 milestone](https://github.com/MessageKit/MessageKit/milestone/1?closed=1).

Initial release. :tada:
