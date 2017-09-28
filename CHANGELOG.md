# CHANGELOG

The changelog for `MessageKit`. Also see the [releases](https://github.com/MessageKit/MessageKit/releases) on GitHub.

--------------------------------------

## Upcoming release
### Added
- **Breaking Change** `.custom((MessageContainerView)->Void)` case to `MessageStyle` enum. 
[#163](https://github.com/MessageKit/MessageKit/pull/163) by [@SD10](https://github.com/SD10).

- **Breaking Change** `UIEdgeInsets` associated value to all `LabelAlignment` enum cases. 
[#166](https://github.com/MessageKit/MessageKit/pull/166) by [@SD10](https://github.com/SD10).

- `LocationMessageDisplayDelegate` to customize a location messages appearance and add a `MKAnnotationView` to location message snapshots. 
[#150](https://github.com/MessageKit/MessageKit/pull/150) by [@etoledom](https://github.com/etoledom).

- `messageLabelInsets(for:indexPath:messagesCollectionView` method to `MessagesLayoutDelegate`. 
[#162](https://github.com/MessageKit/MessageKit/pull/162) by [@SD10](https://github.com/SD10).

### Fixed

-  `MessageInputBar` now correctly sizes itself when breaking its max height or pasting in large amounts of text
[#173](https://github.com/MessageKit/MessageKit/pull/173) by [@nathantannar4](https://github.com/nathantannar4).

- `MessageInputBar` faced a rendering issue on subsequent presentations of a `MessageViewController`. This was originally patched by adding a copy to the view during `viewDidAppear(animated:)` however that led to other issues [#116](https://github.com/MessageKit/MessageKit/issues/116). A correct patch has now been applied.
[#178](https://github.com/MessageKit/MessageKit/pull/178) by [@nathantannar4](https://github.com/nathantannar4).


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

### Removed
- **Breaking Change** `cellTopLabelInsets` and `cellBottomLabelInsets` from `MessagesCollectionViewFlowLayout`.
[#166](https://github.com/MessageKit/MessageKit/pull/166) by [@SD10](https://github.com/SD10).

----------------

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
