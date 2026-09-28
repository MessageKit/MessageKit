## MessageKit 5.0 Migration Guide

### Migration

- DEPRECATION:
    ```swift
    MessagesDataSource.numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
    ```
    is renamed to
    ```swift
    MessagesDataSource.numberOfMessageSections(in messagesCollectionView: MessagesCollectionView) -> Int
    ```
    The old name still compiles and still works, so this is not a breaking
    change. You will see a deprecation warning until you rename it.

    The old name read as the total number of sections, and it never was: it
    counts the sections that hold messages. `MessagesViewController` reserves
    the typing indicator's section on top of whatever you return, in its own
    `UICollectionViewDataSource` conformance:

    ```swift
    let sections = messagesDataSource.numberOfMessageSections(in: collectionView)
    return collectionView.isTypingIndicatorHidden ? sections : sections + 1
    ```

    Adding one for the indicator yourself therefore counts that section twice,
    and the collection view then asks the data source for a message past the end
    of your array. That is the `Index out of range` and `Invalid number of
    sections` pair in [#1788](https://github.com/MessageKit/MessageKit/issues/1788),
    [#1787](https://github.com/MessageKit/MessageKit/issues/1787) and
    [#1387](https://github.com/MessageKit/MessageKit/issues/1387).

    The old name also collided with `UICollectionViewDataSource`'s
    `numberOfSections(in:)`, which `MessagesViewController` implements. The two
    differed only in the parameter type, so the `+ 1` above looked like
    something you were overriding rather than something already done for you.

    Rename the method and return the message count, unchanged:

    ```swift
    // before
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
      messages.count
    }

    // after
    func numberOfMessageSections(in messagesCollectionView: MessagesCollectionView) -> Int {
      messages.count
    }
    ```

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
