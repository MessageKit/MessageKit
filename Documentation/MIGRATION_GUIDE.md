## MessageKit 4.0 Migration Guide

Version 4.0 contains some breaking changes if you want to upgrade from the previous version. In this documentation, we will cover most of the noticeable API changes.

### Migration

- BREAKING CHANGE:
    ```swift
    MessageSizeCalculator.messageContainerMaxWidth(for message: MessageType) -> CGFloat
    ```
    now has IndexPath argument
    ```swift
    MessageSizeCalculator.messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat
    ```
- BREAKING CHANGE:
    ```swift
    MessageSizeCalculator.messageContainerSize(for message: MessageType) -> CGSize
    ```
    now has IndexPath argument 
    ```swift
    MessageSizeCalculator.messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize
    ```
- BREAKING CHANGE:
   Renamed `func currentSender() -> SenderType` to `var currentSender: SenderType`
- BREAKING CHANGE:
   Deprecated `maintainPositionOnKeyboardFrameChangedMoved` in favor of `maintainPositionOnInputBarHeightChanged`.
