# CHANGELOG

The changelog for `MessageKit`. Also see the [releases](https://github.com/MessageKit/MessageKit/releases) on GitHub.

--------------------------------------

## Upcoming release
----------------

## [Prerelease] 0.8.0
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

## [Prerelease] 0.7.4

- Fixes invalid image path for Carthage resources.

## [Prerelease] 0.7.3

- Fixes missing asset bundle resources for Carthage installation.

## [Prerelease] 0.7.2

## [Prerelease] 0.7.1

- Fixes missing asset bundle resources in framework.

## [Prerelease] 0.7.0

This release closes the [0.7 milestone](https://github.com/MessageKit/MessageKit/milestone/8?closed=1)

## [Prerelease] 0.6.0

This release closes the [0.6 milestone](https://github.com/MessageKit/MessageKit/milestone/7?closed=1).

## [Prerelease] 0.5.0

This release closes the [0.5 milestone](https://github.com/MessageKit/MessageKit/milestone/5?closed=1).

## [Prerelease] 0.4.0

This release closes the [0.4 milestone](https://github.com/MessageKit/MessageKit/milestone/4?closed=1).

## [Prerelease] 0.3.0

This release closes the [0.3 milestone](https://github.com/MessageKit/MessageKit/milestone/3?closed=1).

## [Prerelease] 0.2.0

This release closes the [0.2 milestone](https://github.com/MessageKit/MessageKit/milestone/2?closed=1).

## [Prerelease] 0.1.0

This release closes the [0.1 milestone](https://github.com/MessageKit/MessageKit/milestone/1?closed=1).

Initial release. :tada:
