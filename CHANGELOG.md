# CHANGELOG

The changelog for `MessageKit`. Also see the [releases](https://github.com/MessageKit/MessageKit/releases) on GitHub.

--------------------------------------

## Upcoming release

### Changed

- Fixed the way that the Strings and UIImages are parsed in the `InputTextView` to prevent crashes in `parseForComponents()`. 
[#791](https://github.com/MessageKit/MessageKit/pull/791) by [@nathantannar4](https://github.com/nathantannar4)

- **Breaking Change** Updated codebase to Swift 4.2 [#883](https://github.com/MessageKit/MessageKit/pull/883) by [@nathantannar4](https://github.com/nathantannar4)

### Added

- Added support for detection and handling of `NSLink`s inside of messages.
[#815](https://github.com/MessageKit/MessageKit/pull/815) by [@jnic](https://github.com/jnic)

- Added customizable `accessoryView`, with a new `MessagesDisplayDelegate` function `configureAccessoryView`, and corresponding size & padding properties in `MessageSizeCalculator`. The `accessoryView` is aligned to the center of the `messageContainerView`.
[#710](https://github.com/MessageKit/MessageKit/pull/710) by [@hyouuu](https://github.com/hyouuu)

- Added a tap gesture recognition to the `accessoryView` which calls the  `MessageCellDelagate` function `didTapAccessoryView(in:)`. 
[#834](https://github.com/MessageKit/MessageKit/pull/834) by [@nathantannar4](https://github.com/nathantannar4)

- Added `additionalBottomInset` property that allows to adjust the bottom content inset automatically set on the messages collection view by the view controller. 
[#787](https://github.com/MessageKit/MessageKit/pull/787) by [@andreyvit](https://github.com/andreyvit)

### Fixed

-  Fixed a bug that prevented `MessageLabel` from laying out properly when contained by superviews using autolayout.
[#889](https://github.com/MessageKit/MessageKit/pull/889) by [@marius-serban](https://github.com/marius-serban).


- **Breaking Change** Fixed typo of `scrollsToBottomOnKeybordBeginsEditing` to `scrollsToBottomOnKeyboardBeginsEditing`.
[#856](https://github.com/MessageKit/MessageKit/pull/856) by [@p-petrenko](https://github.com/p-petrenko)

- Fixed bottom content inset adjustment when using an undocked keyboard on iPad, or when `edgesForExtendedLayout` does not include `.top`, or when a parent container view controller adds extra views at the top of the screen. 
[#787](https://github.com/MessageKit/MessageKit/pull/787) by [@andreyvit](https://github.com/andreyvit)

- Fixed the `MessageData.emoji` case to use 2x the `messageLabelFont` size by default.
[#795](https://github.com/MessageKit/MessageKit/pull/795) by [@Vortec4800](https://github.com/vortec4800).

### Fixed

- Fixed `MessagesCollectionView` to allow to use nibs with `MessageReusableView`.
[#832](https://github.com/MessageKit/MessageKit/pull/832) by [@maxxx777](https://github.com/maxxx777).
- Fixed multiple crashes at views, when views are being called from another XIB. [#905](https://github.com/MessageKit/MessageKit/pull/905) by [@talanov](https://github.com/talanov).

## [1.0.0](https://github.com/MessageKit/MessageKit/releases/tag/1.0.0)

- First major release.

## [[Prerelease] 1.0.0-beta.2](https://github.com/MessageKit/MessageKit/releases/tag/1.0.0-beta.2)

### Changed

- Relaxed the settable requirement for the `LocationItem` and `MediaItem` protocols.
[#727](https://github.com/MessageKit/MessageKit/pull/716) by [@SD10](https://github.com/sd10).

### Fixed

- Fixed `MessageContentCell`'s subviews `frame` when size equal to `.zero`.
[#716](https://github.com/MessageKit/MessageKit/pull/716) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `MessagesCollectionView`'s bottom inset when hardware keyboard is connected. Do not adjust `MessagesCollection`'s inset when being popped.
[#707](https://github.com/MessageKit/MessageKit/pull/707) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `LabelAlignment` initializer which has default internal access control.
[#705](https://github.com/MessageKit/MessageKit/pull/705) by [@zhongwuzw](https://github.com/zhongwuzw).

### Added

- Added convenience method to set properties for all `MessageSizeCalculator`s.
[#697](https://github.com/MessageKit/MessageKit/pull/697) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 1.0.0-beta.1](https://github.com/MessageKit/MessageKit/releases/tag/1.0.0-beta.1)

### Added

- **Breaking Change** Added new `MessagesDataSource` delegate methods, `numberOfSections(in)` and `numberOfItems(inSection:in)`.
[#601](https://github.com/MessageKit/MessageKit/pull/601) by [@SD10](https://github.com/sd10), [@zhongwuzw](https://github.com/zhongwuzw).

- **Breaking Change** Added new protocol `MediaItem` as the associated value for the
`MessageData.video` and `MessageData.photo` cases.
[#587](https://github.com/MessageKit/MessageKit/pull/587) by [@SD10](https://github.com/sd10).

- **Breaking Change** Added new protocol `LocationItem` as the associated value for
the `MessageData.location` case.
[#587](https://github.com/MessageKit/MessageKit/pull/587) by [@SD10](https://github.com/sd10).

- **Breaking Change** Added new `DetectorType` called `.transitInformation`  to message label.
[#520](https://github.com/MessageKit/MessageKit/pull/520) by [@nosarj](https://github.com/nosarj).

- **Breaking Change** Added `.custom(Any?)` case to `MessageData`.
[#498](https://github.com/MessageKit/MessageKit/pull/498) by [@SD10](https://github.com/SD10).

- **Breaking Change** Added `.messageLabelTop` case to `AvatarPosition.Vertical` enum.
[#596](https://github.com/MessageKit/MessageKit/pull/596) by [@zhongwuzw](https://github.com/zhongwuzw)

- Added `CellSizeCalculator` protocol that is responsible for sizing and configuring attributes of a  `MessageCollectionViewCell`.
[#579](https://github.com/MessageKit/MessageKit/pull/579) by [@SD10](https://github.com/SD10).

- Added `MessageSizeCalculator`, `MediaMessageSizeCalculator`, `TextMessageSizeCalculator`, and `LocationMessageSizeCalculator`
classes that are responsible for sizing the `MessagesCollectionViewCell` types provided by MessageKit.
[#579](https://github.com/MessageKit/MessageKit/pull/579) by [@SD10](https://github.com/sd10).

- Added three new methods `cellTopLabelHeight(for:at:in)`, `messageTopLabelHeight(for:at:in)`, and `messageBottomLabelHeight(for:at:in)` to `MessagesLayoutDelegate`.
[#580](https://github.com/MessageKit/MessageKit/pull/580) by [@SD10](https://github.com/sd10).

- Added new class `InsetLabel`.
[#580](https://github.com/MessageKit/MessageKit/pull/580) by [@SD10](https://github.com/sd10).

- Added new method `configureMediaMessageImageView(_:for:at:in)` to configure the `UIImageView` of a
`MediaMessageCell` asynchronously.
[#592](https://github.com/MessageKit/MessageKit/pull/592) by [@zhongwuzw](https://github.com/zhongwuzw), [@SD10](https://github.com/sd10)

- Added new `MessageContentCell` class and `MessageReusableView` class.
[#596](https://github.com/MessageKit/MessageKit/pull/596) by [@SD10](https://github.com/sd10).

### Changed

- **Breaking Change** Renamed `MessageData` enum to `MessageKind` and changed `MessageType`'s `data` property name to `kind`.
 [#658](https://github.com/MessageKit/MessageKit/658) by [@zhongwuzw](https://github.com/zhongwuzw).

- **Breaking Change** Changed the `messageFooterView(for:in)` and `messageHeaderView(for:in)` methods of
`MessagesDisplayDelegate` by removing the `message` parameter.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** Changed the `footerViewSize(for:in)` and `headerViewSize(for:in)` methods of `MessagesLayoutDelegate`
by removing the `MessageType` and `IndexPath` parameters and replacing them with a new `section: Int` parameter.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** The reuse identifiers of all `MessageReusableView`s and `MessageCollectionViewCell`s have been 
changed to match their class name exactly.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** `MessageHeaderView` and `MessageFooterView` now subclass `MessageReusableView` class.
[#596](https://github.com/MessageKit/MessageKit/pull/596) by [@SD10](https://github.com/sd10).

- **Breaking Change** Renamed `MessageCollectionViewCell` to `MessageContentCell`. 
The `MessageCollectionViewCell` class is now a bare bones subclass. 
[#596](https://github.com/MessageKit/MessageKit/pull/596) by [@SD10](https://github.com/sd10).

- **Breaking Change** Changed `LabelAlignment` to be a `struct` with properties of 
`textAlignment: NSTextAlignment` and `textInsets: UIEdgeInsets` to position the text in the `cellTopLabel` and `cellBottomLabel`.
[#580](https://github.com/MessageKit/MessageKit/pull/580) by [@SD10](https://github.com/sd10).

- **Breaking Change** The type of `cellTopLabel` and `cellBottomLabel` has been changed to `InsetLabel`.
[#580](https://github.com/MessageKit/MessageKit/pull/580) by [@SD10](https://github.com/sd10).

- **Breaking Change** Renamed `cellTopLabel` to `messageTopLabel` and renamed `cellBottomLabel` to `messageBottomLabel`.
[#659](https://github.com/MessageKit/MessageKit/pull/659) by [@SD10](https://github.com/sd10).

- **Breaking Change** Renamed the `didTapTopLabel` and `didTapBottomLabel` methods of `MessageCellDelegate` to `didTapMessageTopLabel` and `didTapMessageBottomLabel`.
[#659](https://github.com/MessageKit/MessageKit/pull/659) by [@SD10](https://github.com/sd10).

- **Breaking Change** Renamed `cellBottomLabelAttributedText` method of `MessagesDataSource` to `messageBottomLabelAttributedText`.
[#659](https://github.com/MessageKit/MessageKit/pull/659) by [@zhongwuzw](https://github.com/zhongwuzw).

- The `MessageData.emoji` case no longer uses a default font of 2x the `messageLabelFont` size.
You must now set this font explicitly through the `emojiMessageSizeCalculator` on `MessagesCollectionViewFlowLayout`.
[#530](https://github.com/MessageKit/MessageKit/pull/579) by [@SD10](https://github.com/sd10).

- Changed the `contentMode` of the `UIImageView` for `MediaMessageCell` to be `.scaleAspectFill`.
[#587](https://github.com/MessageKit/MessageKit/pull/587) by [@SD10](https://github.com/sd10).

- The result of the `MessagesDisplayDelegate` method `textColor(for message:...)` no longer applies to `.attributedText` case of `MessageData`.
[#625](https://github.com/MessageKit/MessageKit/pull/625) by [@cwalo](https://github.com/cwalo).

- Removed the explicit height constraint from the `separatorLine` in `MessageInputBar`.
[#667](https://github.com/MessageKit/MessageKit/pull/667) by [@zhongwuzw](https://github.com/zhongwuzw)

### Removed

- **Breaking Change** Removed `NSLayoutConstraintSet` by changing access control from `public` to `internal`.
[#607](https://github.com/MessageKit/MessageKit/pull/607) by [@zhongwuzw](https://github.com/zhongwuzw).

- **Breaking Change** Removed the `showsDateHeaderAfterTimeInterval` property of `MessagesCollectionView`.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed the `reuseIdentifer` method from `MessageCollectionViewCell`, `TextMessageCell`,
`LocationMessageCell`, `MediaMessageCell`, and `MessageContentCell`.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed the `CollectionViewReusable` protocol.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed `MessageHeaderView` and `MessageFooterView` in favor of `MessageReusableView`.
[#615](https://github.com/MessageKit/MessageKit/pull/615) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed `numberOfMessages(in)` method of `MessagesDataSource`, instead please use `numberOfSections(in)` and `numberOfItems(inSection:in)`.
[#601](https://github.com/MessageKit/MessageKit/pull/601) by [@SD10](https://github.com/sd10), [@zhongwuzw](https://github.com/zhongwuzw).

- **Breaking Change** Removed the `messageLabelFont` property from `MessagesCollectionViewFlowLayout`.
You can now set this property through `textMessageSizeCalculator` property.
[#579](https://github.com/MessageKit/MessageKit/pull/579) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed `MessageDateHeaderView` class in favor of using `cellTopLabel`.
[#659](https://github.com/MessageKit/MessageKit/pull/659) by [@zhongwuzw](https://github.com/zhongwuzw).

### Fixed

- Fixed equality checking on `MessagesCollectionViewLayoutAttributes`.
[#593](https://github.com/MessageKit/MessageKit/pull/593) by [@zhongwuzw](https://github.com/zhongwuzw), [@SD10](https://github.com/sd10)

## [[Prerelease] 0.13.5](https://github.com/MessageKit/MessageKit/releases/tag/0.13.5)

### Fixed

- Fixed `MessageLabel` touch location offset calculation.
[#664](https://github.com/MessageKit/MessageKit/pull/664) by [@austinwright](https://github.com/austinwright).

## [[Prerelease] 0.13.4](https://github.com/MessageKit/MessageKit/releases/tag/0.13.4)

### Fixed

- Fixed `bubbleTailOutline` invalidation of message bubble.
[#633](https://github.com/MessageKit/MessageKit/pull/633) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `boundingRect(with:options:attributes:context)` wrong size calculation when use some font, e.g. custom font.
[#645](https://github.com/MessageKit/MessageKit/pull/645) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.13.3](https://github.com/MessageKit/MessageKit/releases/tag/0.13.3)

### Fixed

- Fixed font invalidation of `attributedString` in `MessageLabel`.
[#623](https://github.com/MessageKit/MessageKit/pull/623) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.13.2](https://github.com/MessageKit/MessageKit/releases/tag/0.13.2)

### Added

- Added `shouldManageSendButtonEnabledState` to `MessageInputBar` to disable automatically managing `MessageInputBar.sendButton`'s
 `isEnabled` state when text changes. (Default value is `true`).
[#530](https://github.com/MessageKit/MessageKit/pull/530) by [@clayellis](https://github.com/clayellis).

### Fixed

- Fixed wrong separated components in messageInputBar.
[#577](https://github.com/MessageKit/MessageKit/pull/577) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.13.1](https://github.com/MessageKit/MessageKit/releases/tag/0.13.1)

### Fixed

- Optimize `collectionView` scroll behavior when abruptly stops scrolling.
[#470](https://github.com/MessageKit/MessageKit/pull/470) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `messageInputBar` sendButton not disabled in some situations.
[#475](https://github.com/MessageKit/MessageKit/pull/475) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed message bubble tail orientation invalidation in `iOS9`.
[#469](https://github.com/MessageKit/MessageKit/pull/469) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.13.0](https://github.com/MessageKit/MessageKit/releases/tag/0.13.0)

### Fixed

- Fixed message rendering when `MessagesViewController` sliding back.
[#454](https://github.com/MessageKit/MessageKit/pull/454) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `iPhoneX` `MessageInputBar` transparent bottom area when `keyboardDismissMode` is `interactive`.
[#425](https://github.com/MessageKit/MessageKit/pull/425) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed wrong `contentInset` calculation when `navigationBar` is `hidden`
[#444](https://github.com/MessageKit/MessageKit/pull/444) by [@zhongwuzw](https://github.com/zhongwuzw).

### Added

- Added `configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)` method in `MessagesDisplayDelegate` `protocol` to configure `avatarView`.
[#416](https://github.com/MessageKit/MessageKit/pull/416) by [@zhongwuzw](https://github.com/zhongwuzw).

- Added copy support for image, text, and emoji messages.
[#418](https://github.com/MessageKit/MessageKit/pull/418) by [@zhongwuzw](https://github.com/zhongwuzw).

- Added `UIImage` paste support to the `InputTextView`. Images can easily be accessed using the `InputTextView.images` property. 
See the example project for an updated use case.  
[#423](https://github.com/MessageKit/MessageKit/pull/423) by [@nathantannar4](https://github.com/nathantannar4).

### Removed

- **Breaking Change** Removed `avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)` method of `MessagesDataSource`, use `configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)` instead.
[#416](https://github.com/MessageKit/MessageKit/pull/416) by [@zhongwuzw](https://github.com/zhongwuzw).

### Changed

- **Breaking Change** Moved the `handleTapGesture(_ gesture: UIGestureRecognizer)` method from `MessagesCollectionViewCell` to `MessagesCollectionView`.
[#417](https://github.com/MessageKit/MessageKit/pull/417) by [@zhongwuzw](https://github.com/zhongwuzw).

- **Breaking Change** Changed `AvatarView` from type `UIView` to type `UIImageView`.
 [#417](https://github.com/MessageKit/MessageKit/pull/417) by [@zhongwuzw](https://github.com/zhongwuzw).


## [[Prerelease] 0.12.1](https://github.com/MessageKit/MessageKit/releases/tag/0.12.1)

### Fixed

- Fixed `LocationMessageCell` reuse bug, to avoid inconsistency when get capture image asynchronously. 
[#428](https://github.com/MessageKit/MessageKit/pull/428) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `MessageLabel` detector attributes not being applied due to early exit.
[#429](https://github.com/MessageKit/MessageKit/pull/429) by [@antoinelamy](https://github.com/antoinelamy).

## [[Prerelease] 0.12.0](https://github.com/MessageKit/MessageKit/releases/tag/0.12.0)

### Added

- Added `reloadDataAndKeepOffset()` method to `MessagesCollectionView` to maintain the current position
when reloading data.
[#284](https://github.com/MessageKit/MessageKit/pull/284) by [@azurechen](https://github.com/azurechen).

- Added `maintainPositionOnKeyboardFrameChanged: Bool` property to maintain the current position of the 
`MessagesCollectionView` when the height of the `MessageInputBar` changes.
[#340](https://github.com/MessageKit/MessageKit/pull/340) by [@KEN-chan](https://github.com/KEN-chan).

- Added `detectorAttributes(for:and:at:)` method to `MessagesDisplayDelegate` allowing `DetectorType`
attributes to be set outside of the cell.
[#397](https://github.com/MessageKit/MessageKit/pull/397) by [@SD10](https://github.com/sd10).

### Fixed

- Fixed `indexPathForLastItem` bug when `numberOfSections` equal to 1. 
[#395](https://github.com/MessageKit/MessageKit/issues/395) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `scrollToBottom(animated:)` not work in some situations.
[#395](https://github.com/MessageKit/MessageKit/issues/395) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixed `.attributedText(NSAttributedString)` messages that were not using the `textColor` from the
`MessagesDisplayDelegate` method.
[#414](https://github.com/MessageKit/MessageKit/issues/414) by [@SD10](https://github.com/sd10).

- Fixed a bug where new messages using `.attributedText(NSAttributedString)` have the incorrect font.
[#412](https://github.com/MessageKit/MessageKit/issues/412) by [@SD10](https://github.com/sd10).


### Changed

- **Breaking Change** The `MessageLabel` properties `addressAttributes`, `dateAttributes`, `phoneNumberAttributes`,
and `urlAttributes` are now read only. Please use `setAttributes(_:detector:)` to set these properties. 
[#397](https://github.com/MessageKit/MessageKit/pull/397) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed the generic constraint `<ContentView: UIView>` from `MessageCollectionViewCell`.
[#391](https://github.com/MessageKit/MessageKit/pull/391) by [@SD10](https://github.com/sd10).

- **Breaking Change** The `contentView` property has been renamed to `imageView` for `LocationMessageCell` and `MediaMessageCell`
and `messageLabel` for `TextMessageCell`.
[#391](https://github.com/MessageKit/MessageKit/pull/391) by [@SD10](https://github.com/sd10).

- **Breaking Change** Changed the name of  `MessageInputBar`'s property `maxHeight` to `maxTextViewHeight` as the property is the max height the `InputTextView` can have, not the `MessageInputBar` itself.
[#380](https://github.com/MessageKit/MessageKit/pull/380) by [@nathantannar4](https://github.com/nathantannar4).

- **Breaking Change**  Adds a new view `contentView` of type `UIView` to the MessageInputBar to hold the main subviews of the `MessageInputBar`. Reduces complexity of constraints for easier testing/debugging.
[#384](https://github.com/MessageKit/MessageKit/pull/384) by [@nathantannar4](https://github.com/nathantannar4).

### Removed

- **Breaking Change** Removed `scrollsToBottomOnFirstLayout` flag of `MessagesViewController`.
[#395](https://github.com/MessageKit/MessageKit/pull/395) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.11.0](https://github.com/MessageKit/MessageKit/releases/tag/0.11.0)

### Added

- **Breaking Change** Added a top `InputStackView` to `MessageInputBar`. This adds the addition of the `.top` case to `InputStackView.Position`.
[#320](https://github.com/MessageKit/MessageKit/issues/320) by [@nathantannar4](https://github.com/nathantannar4).

- **Breaking Change** Added `AvatarPosition` and `avatarPosition(for:at:in)` to configure an
`AvatarView`'s vertical and horizontal position in a `MessageCollectionViewCell`.
[#322](https://github.com/MessageKit/MessageKit/pull/322) by [@SD10](https://github.com/sd10).

- Added `shouldCacheLayoutAttributes(for:MessageType)-> Bool` method to `MessagesLayoutDelegate`
to manage whether a `MessageType`'s layout information is cached or not.
[#364](https://github.com/MessageKit/MessageKit/pull/322) by [@SD10](https://github.com/sd10).

### Changed

- **Breaking Change** The `cellTopLabel` and `cellBottomLabel` properties of `MessageCollectionViewCell` are no longer
typed as `MessageLabel` and are now regular `UILabel`s.
[#355](https://github.com/MessageKit/MessageKit/pull/355) by [@SD10](https://github.com/sd10).

- All `DetectorType`s for `MessageLabel` are disabled by default.
[#356](https://github.com/MessageKit/MessageKit/pull/356) by [@SD10](https://github.com/sd10).

### Fixed

- **Breaking Change** Fixed all instances of misspelled `inital` property. `Avatar.inital` has changed to `Avatar.initial` 
and the initializer has changed from `public init(image: UIImage? = nil, initals: String = "?")` to `public init(image: UIImage? = nil, initials: String = "?")`. 
[#298](https://github.com/MessageKit/MessageKit/issues/298) by [@sidmclaughlin](https://github.com/sidmclaughlin).

- Fixed `MessageInputBar`'s `translucent` functionality.
[#348](https://github.com/MessageKit/MessageKit/pull/348) by [@zhongwuzw](https://github.com/zhongwuzw).

- Fixes infinite loop when dismissing keyboard on iPhone X.
[#350](https://github.com/MessageKit/MessageKit/pull/350) by [@nathantannar4](https://github.com/nathantannar4).

- Fixed incorrect sizing of `cellTopLabel` and `cellBottomLabel`.
[#371](https://github.com/MessageKit/MessageKit/pull/371/commits/949796d68d175d2f2c8700ed0cb769935aee2184) by [@SD10](https://github.com/sd10).

### Removed

- **Breaking Change** Removed `AvatarAlignment` and `avatarAlignment(for:at:in)` delegate method
in favor of new `AvatarPosition` representing both vertical and horizontal alignments.
[#322](https://github.com/MessageKit/MessageKit/pull/322) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed the `avatarAlwaysLeading` and `avatarAlwaysTrailing` properties of `MessagesCollectionViewFlow$
[#322](https://github.com/MessageKit/MessageKit/pull/322) by [@SD10](https://github.com/sd10).

- **Breaking Change** Removed `LocationMessageDisplayDelegate` & `TextMessageDisplayDelegate` and moved their methods
into the `MessagesDisplayDelegate` protocol. Removed `LocationMessageLayoutDelegate` & `MediaMessageLayoutDelegate` and
moved their methods into the `MessagesLayoutDelegate` protocol.
[#363](https://github.com/MessageKit/MessageKit/pull/363) by [@SD10](https://github.com/sd10).

## [[Prerelease] 0.10.2](https://github.com/MessageKit/MessageKit/releases/tag/0.10.2)

### Fixed

- Fixed `contentInset.top` adjustment of the `MessagesCollectionView` on iOS versions less than 11 where it was found that messages appeared under the navigation var
[#334](https://github.com/MessageKit/MessageKit/pull/334) by [@nathantannar4](https://github.com/nathantannar4).

- Fixed `cellbottomLabel` origin X for the `.messageLeading` alignment and
origin Y so that the `cellBottomLabel` is always under the `MessageContainerView`.
[#326](https://github.com/MessageKit/MessageKit/pull/326) by [@SD10](https://github.com/sd10). 

- Fixed pixelation of `AvatarView`'s placeholder text initials.
[#343](https://github.com/MessageKit/MessageKit/pull/343) by [@johnnyoin](https://github.com/johnnyoin).

- Fixed `MessageLabel` address detection handler.
[#341](https://github.com/MessageKit/MessageKit/pull/341) by [@zhongwuzw](https://github.com/zhongwuzw)

- Fixed crash for escaping block in `InputBarItem`’s `setSize(newValue:animated)` method.
[#342](https://github.com/MessageKit/MessageKit/pull/342) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.10.1](https://github.com/MessageKit/MessageKit/releases/tag/0.10.1)

### Fixed

-  Fixed a bug that caused a race condition to be met when invalidating the `intrinsicContentSize` of the `MessageInputBar` which froze the app during a "Select" or "Select All" long press
[#313](https://github.com/MessageKit/MessageKit/pull/313) by [@zhongwuzw](https://github.com/nathantannar4).

-  Fixed a bug that the `placeholderLabel` `subview` of `InputTextView` leads to ambiguous content size because of uncorrect `Auto Layout`.
[#310](https://github.com/MessageKit/MessageKit/pull/310) by [@zhongwuzw](https://github.com/zhongwuzw).

-  Fixed a bug that the `leftStackView`、`rightStackView` `subview` of `MessageInputBar` leads to ambiguous `Auto Layout` issue because of typo.
[#311](https://github.com/MessageKit/MessageKit/pull/311) by [@zhongwuzw](https://github.com/zhongwuzw).

### Changed

-  Changed `InputStackView` default `alignment` from `.fill` to `.bottom`.
[#311](https://github.com/MessageKit/MessageKit/pull/311) by [@zhongwuzw](https://github.com/zhongwuzw).

## [[Prerelease] 0.10.0](https://github.com/MessageKit/MessageKit/releases/tag/0.10.0)

### Added

- Added `removedCachedAttributes(for:MessageType)`, `removeAllCachedAttributes()`, and `attributesCacheMaxSize` to
`MessagesCollectionViewFlowLayout` to manage the caching of layout information for messages.
[#263](https://github.com/MessageKit/MessageKit/pull/263) by [@SD10](https://github.com/sd10).

-  Created `SeparatorLine` and `InputStackView` as their own subclass of `UIView` and `UIStackView` respectively. This just improves reusability.
[#273](https://github.com/MessageKit/MessageKit/pull/273) by [@nathantannar4](https://github.com/nathantannar4).

### Changed

-  **Breaking Change**  The properties `leftStackView`, `rightStackView` and `bottomStackView` in `MessageInputBar` are now of type `InputStackView`. The property `separatorLine` is also now of type `SeparatorLine` in `MessageInputBar`.
[#273](https://github.com/MessageKit/MessageKit/pull/273) by [@nathantannar4](https://github.com/nathantannar4).

- Layout information is now being cached by `MessagesCollectionViewFlowLayout` for each `MessageType` using the
`messageId` property. (This means if your layout is dynamic over the `IndexPath` you need to handle cache invalidation).
[#263](https://github.com/MessageKit/MessageKit/pull/263) by [@SD10](https://github.com/sd10).

- Layout anchors for the `MessagesCollectionView` and `MessageInputBar` now include the safeAreaLayoutGuide to fix layout issues on iPhone X
[#280](https://github.com/MessageKit/MessageKit/pull/280) by [@nathantannar4](https://github.com/nathantannar4).

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
