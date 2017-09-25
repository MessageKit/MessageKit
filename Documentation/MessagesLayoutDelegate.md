# MessagesLayoutDelegate

The `MessagesLayoutDelegate` protocol is responsible for sizing all the content inside a `MessageCollectionViewCell` and adjusting the cell's subviews position in relation to each other. All of `MessagesLayoutDelegate` methods have default implementations. You can provide your own implementation to override their behavior.

### Adjusting the Size of the Avatar

```Swift
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize
```

You can use the `avatarSize` method to adjust the size of the `AvatarView` for each `MessageCollectionView` cell. The default size is `30 x 30`. If you don't want an `AvatarView` in your cell, just return a value of `.zero`.

### Adjusting the position of the Avatar

```Swift
    func avatarAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarAlignment
```

You can use the `avatarAlignment` method to adjust the position of the `AvatarView` in the cell relative to the `MessageCollectionViewCell` or the `MessageContainerView`. This method requires you return a value from the `AvatarAlignment` enum which has the following 5 cases:

### AvatarAlignment
```Swift
public enum AvatarAlignment {
	case cellTop
	case messageTop
	case messageCenter
	case messageBottom
	case cellBottom
}
```
The default value for this method is `.cellBottom`.


### Adjusting the cellTopLabel & cellBottomLabel positions
```Swift
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment

    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment
```

You can use the `cellTopLabelAlignment` and `cellBottomLabelAlignment` methods to adjust the position of the labels relative to the `MessageCollectionViewCell` or the `MessageContainerView`. This method requires you return a value from the `LabelAlignment` enum which has the following 5 cases:

```Swift
public enum LabelAlignment {
	case cellTrailing
	case cellLeading
	case cellCenter
	case messageTrailing
	case messageLeading
}
```

By default, the `cellTopLabel` is aligned `.messageTrailing` if the message is from the current sender and `.messageLeading` otherwise.

By default, the `cellBottomLabel` is aligned `.messageLeading` if the message is from the current sender and `.messageTrailing` otherwise.

### Adjusting the size of the MessageHeaderView and MessageFooterView

```Swift
    func headerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize

    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize
```

You can use the `headerViewSize` and `footerViewSize` methods to adjust the size of the header or footer views for each `MessageCollectionViewCell`. If you don't want to display a `MessageHeaderView` or `MessageFooterView` just return a size of `.zero` respectively. 
