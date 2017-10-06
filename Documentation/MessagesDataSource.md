# MessagesDataSource

The `MessagesDataSource` is responsible for returning all forms of data for the `MessageCollectionViewCell`. This includes the number of cells in the `MessageCollectionView`, the `MessageType` for each cell, the `Avatar` to be used for the `AvatarView`, the current `Sender` of each message, and finally the `NSAttributedString` text for the `cellTopLabel` and `cellBottomLabel` of each cell.

The `MessagesDataSource` requires that you implement the following 3 methods:

```Swift
	func currentSender() -> Sender

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType

	func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int
```

### Providing an avatar image for AvatarView

```Swift
    func avatar(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar
```
You can use the `avatar` method to return an `Avatar` object containing the image you want to display in the `AvatarView`.  
The `Avatar` type has the following 2 properties:

### Avatar
```Swift
public struct Avatar {
	public let image: UIImage?
	public var initials: String = "?"
}
```

If no image is provided then the `AvatarView` will generate a placeholder image using the specified initials of the `Avatar`. The default value of this method returns an `Avatar` with initials of "?".


### Providing cellTopLabel text & cellBottomLabelText
```Swift
	func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
```
The `cellTopLabelAttributedText` & `cellBottomLabelAttributedText` methods both default to `nil`. If these methods return `nil` the label will have a size of `.zero` in the `MessageCollectionViewCell`. 


