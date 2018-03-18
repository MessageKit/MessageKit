# MessagesDisplayDelegate
The `MessagesDisplayDelegate` protocol allows you to customize the general appearance of `MessageCollectionViewCells`, `TextMessageCells`, and their accompanying `MessageHeaderView` or `MessageFooterView`. 

All of `MessagesDisplayDelegate`'s methods have default implementations. You can override their behavior by providing your own implementation.

## Customizing MessageCollectionViewCell

### Customizing the messageContainerView's background color

```Swift
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
```

The default implementation of this method uses the `isFromCurrentSender` method of `MessagesDataSource` to evaluate if the message is from the current sender. It returns backgroundColor of light green if the message is from the current sender and light gray otherwise.


### Customizing the messageContainerView's style

```Swift
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle
```

This method allows you to customize the `MessageStyle` for the cell which is an enum containing the following 5 cases:
### MessageStyle
```Swift
public enum MessageStyle {
	case none
    case bubble
    case bubbleOutline(UIColor)
    case bubbleTail(TailCorner, TailStyle)
    case bubbleTailOutline(UIColor, TailCorner, TailStyle)
}
```
- `none` Use this case if you want now style applied to the `messageContainerView`


- `bubble` Use this case if you want message bubbles


- `bubbleOutline(UIColor)` Use this case if you want message bubbles with an outline. The associated value `UIColor` is the color to use for the outline of the bubble.


- `bubbleTail(TailCorner, TailStyle)` Use this case if you want message bubbles with a tail. You must specify the corner where the tail will be located and which tail style you'd like the bubble to have.


- `bubbleTailOutline(UIColor, TailCorner, TailStyle)` Use this case if you want message bubbles with both a tail and outline. You must specify where the tail will be located and which tail style you'd like the bubble to have.

The default `MessageStyle` for a `MessageCollectionViewCell` is `.bubble`.

### TailStyle
**MessageKit** currently supports 2 types of `TailStyle`:
```Swift
public enum TailStyle {
	case curved
	case pointedEdge
}
```
The `curved` style is the type of tail that **iMessage** uses and the `pointedEdge` style is like **Google Hangouts**.


### TailCorner
The `TailCorner` is just a simple enum representing the 4 corners of the `messageContainerView`:
```Swift
public enum TailStyle {
	case topLeft
	case bottomRight
	case topRight
	case bottomRight
}
```

### Customizing MessageHeaderView & MessageFooterView

Since **MessageKit** puts each `MessageType` in its own section in the `MessagesCollectionView`, this allows each message to have its own section `MessageHeaderView` and `MessageFooterView`. You  can use the following 2 methods to provide custom section headers and footers for your messages:

```Swift
    func messageHeaderView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageHeaderView?
    
    func messageFooterView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageFooterView?
```

By default, `messageHeaderView` uses the method `shouldDisplayHeader(for:_:_)` of `MessagesDisplayDelegate` to determine if it should return a `MessageHeaderView` subclass called `MessageDateHeaderView` or `nil`. The `shouldDisplayHeader(for:_:_)` method checks the `showsDateHeaderAfterTimeInterval` property of `MessagesCollectionView` and returns `true` if the the last message was sent after the specified time interval. The default value of this `TimeInterval` is **1 hour**. 

By default, `messageFooterView` returns `nil`.

In order to return a custom subclass for the header or footer you will need to register the custom cell via `messagesCollectionView.register` and optionally customise `headerViewSize` or `footerViewSize` within the assigned `MessagesLayoutDelegate`.

### Customizing a TextMessageCell's text color

```Swift
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
```

The default implementation of this method uses the `isFromCurrentSender` method of `MessagesDataSource` to evaluate if the message is from the current sender. It returns a text color of `UIColor.white` if the message is from the current sender and `UIColor.darkText` otherwise.

**NOTE:** This method only applies to `TextMessageCell`



