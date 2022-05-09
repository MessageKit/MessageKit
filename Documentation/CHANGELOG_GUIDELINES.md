# Changelog Guidelines

Here you can find the general guidelines for maintaining the Changelog (or adding new entry). We follow the guidelines from [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) with few additions. 

## Guiding Principles
- Changelogs are for humans, not machines.
- There should be an entry for every single version.
- The same types of changes should be grouped.
- Versions and sections should be linkable.
- The latest version comes first.
- The release date of each versions is displayed.
- Mention whether you follow Semantic Versioning.

... with MessageKit-specific additions:
- Add PR number and a GitHub tag at the end of each entry.
- Each breaking change entry should have **Breaking Change** label at the beginning of this entry.
- **Breaking Change** entries should be placed at the top of the section it's in.

## Types of changes
- **Added** for new features.
- **Changed** for changes in existing functionality.
- **Deprecated** for soon-to-be removed features.
- **Removed** for now removed features.
- **Fixed** for any bug fixes.
- **Security** in case of vulnerabilities.

## Example:

### Added

- Added `removedCachedAttributes(for:MessageType)`, `removeAllCachedAttributes()`, and `attributesCacheMaxSize` to
`MessagesCollectionViewFlowLayout` to manage the caching of layout information for messages.
[#263](https://github.com/MessageKit/MessageKit/pull/263) by [@SD10](https://github.com/sd10).

### Changed

-  **Breaking Change**  The properties `leftStackView`, `rightStackView` and `bottomStackView` in `MessageInputBar` are now of type `InputStackView`. The property `separatorLine` is also now of type `SeparatorLine` in `MessageInputBar`.
[#273](https://github.com/MessageKit/MessageKit/pull/273) by [@nathantannar4](https://github.com/nathantannar4).

- Layout information is now being cached by `MessagesCollectionViewFlowLayout` for each `MessageType` using the
`messageId` property. (This means if your layout is dynamic over the `IndexPath` you need to handle cache invalidation).
[#263](https://github.com/MessageKit/MessageKit/pull/263) by [@SD10](https://github.com/sd10).

### Fixed

-  Fixed a bug that prevented the `textAlignment` property of `InputTextView`'s `placeholderLabel` from having noticeable differences when changed to `.center` or `.right`.
[#262](https://github.com/MessageKit/MessageKit/pull/262) by [@nathantannar4](https://github.com/nathantannar4).

### Removed

- **Breaking Change** Removed `additionalTopContentInset` property of `MessagesViewController` because this is no longer necessary
when `extendedLayoutIncludesOpaqueBars` is `true`.
[#250](https://github.com/MessageKit/MessageKit/pull/250) by [@SD10](https://github.com/SD10).
