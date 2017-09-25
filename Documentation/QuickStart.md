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



