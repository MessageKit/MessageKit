# Quick Start Guide

## MessageType Protocol
The driving force behind **MessageKit** is the `MessageType` protocol which provides the minimum requirements for your own native message model. The `MessageType` protocol has the following 4 required properties:

```Swift
public protocol MessageType {

    var sender: Sender { get }

    var messageId: String { get }

    var sentDate: Date { get }

    var data: MessageData { get }
}
```
First, each `MessageType` is required to have a `Sender` which contains two properties, `id` and `displayName`:
### Sender
```Swift
public struct Sender {

    public let id: String

    public let displayName: String
}
```
**MessageKit** uses the `Sender` type to determine if a message was sent by the current user or to the current user.

Second, each message must have its own `messageId` which is a unique `String` identifier for the message.

Third, each message must have a `sentDate` which represents the `Date` that each message was sent.

Fourth, each message must specify what type of data this message contains through the `data: MessageData` property:
### MessageData

```Swift
public enum MessageData {
    case text(String)
    case attributedText(NSAttributedString)
    case photo(UIImage)
    case video(file: URL, thumbnail: UIImage)
    case location(CLLocation)
}
```
`MessageData` has 5 different cases representing the types of messages that **MessageKit** can display.

- `text(String)` - Use this case if you just want to display a normal text message without any attributes.
- **NOTE**: You must also specify the `UIFont` you want to use for this text by setting the `messageLabelFont` property of `MessagesCollectionViewFlowLayout`.

- `attributedText(NSAttributedString)` - Use this case if you want to display a text message with attributes
- **NOTE**: It is recommended that you use `attributedText` regardless of the complexity of your text's attributes. When using this method you do not need to set the `messageLabelFont` property of `MessagesCollectionViewFlowLayout` and generally this method will decrease the probability of programmer error and increase performance.

- `photo(UIImage)` - Use this case to display a photo message.


- `video(file: URL, thumbnail: UIImage)` - Use this case to display a video message.


- `location(CLLocation)` - Use this case to display a location message.

# MessagesViewController

## Subclassing MessagesViewController
To begin using **MessageKit** you first need to subclass `MessagesViewController`:
```Swift
class ChatViewController: MessagesViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
```
**NOTE**: If you override any of the `UIViewController` lifecycle methods such as `viewDidLoad`, `viewWillAppear`, `viewDidAppear`, make sure to call the superclass implementation of these methods.

## Displaying Messages in your MessagesViewController
In order to start displaying messages in your `MessagesViewController` subclass, you NEED to conform to the following 3 protocols:

1. `MessagesDataSource`
2. `MessagesLayoutDelegate`
3. `MessagesDisplayDelegate`

```Swift
class ChatViewController: MessagesViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
	}
}
```

### MessagesDataSource

You must implement the following 3 methods to conform to `MessagesDataSource`:

```Swift
// Some global variables for the sake of the example. Using globals is not recommended!
let sender = Sender(id: "any_unique_id", displayName: "Steven")
let messages: [MessageType] = []

extension ChatViewController: MessagesDataSource {

	func currentSender() -> Sender {
		return Sender(id: "any_unique_id", displayName: "Steven")
	}

	func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
}
```
**NOTE**: If you look closely at the implementation of the `messageForItem` method you'll see that we use the `indexPath.section` to retrieve our `MessageType` from the array as opposed to the traditional `indexPath.row` property. This is because in **MessageKit** each `MessageType` is in its own section of the `MessagesCollectionView`.

As you can see **MessageKit** does not require you to return a `MessagesCollectionViewCell` like the traditional `UITableView` or `UICollectionView` API. All that is required is for you to return your `MessageType` model object. We take care of applying the model to the cell for you.

### MessagesLayoutDelegate & MessagesDisplayDelegate

The `MessagesLayoutDelegate` and `MessagesDisplayDelegate` don't require you to implement any methods as they have default implementations for everything. You just need to make your `MessagesViewController` subclass conform to these two protocols and set them in the `MessagesCollectionView` object.

```Swift
extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}
```
