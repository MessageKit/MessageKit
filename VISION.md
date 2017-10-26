## MessageKit Vision

### Goals
- Provide a suitable replacement (but not absolute mirror image) of JSQMessagesViewController.
- Provide “sensible defaults, but also customization hooks" - @jessesquires
- Favor a Swift-first, idiomatic API.
- Build a centralized MessageViewController project for iOS.
- Cultivate an inclusive open source community through respectful discussion.

### Scope
MessageKit will only concern itself with the **MessagesViewController**. 

We will **not** support other views such as:  **Photo Pickers** and **Video/Music Players**.

Instead, MessageKit will provide you with hooks to easily handle your different message types and present a view of your choice. We believe this is more flexible, maintainable, and reasonable.

### Technical Considerations
- **iOS version**: 
We will strive to support the 3 latest versions of iOS.

- **Objective-C Compatability**: 
We will not sacrifice functionality or an idiomatic Swift API to support Objective-C, but would love to improve Objective-C compatability where possible.

- **Layouts**: 
We will favor programmatic layouts over `.xib`s where ever possible.
