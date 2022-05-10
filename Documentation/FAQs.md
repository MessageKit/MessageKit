# MessageKit Frequently Asked Questions

- [Why doesn't the `MessageInputBar` appear in my controller?](#why-doesnt-the-messageinputbar-appear-in-my-controller)
- [How can I remove the `AvatarView` from the cell?](#how-can-i-remove-the-avatarview-from-the-cell)
- [How can I move the `AvatarView` to prevent it from overlapping text in the `MessageBottomLabel` or `CellTopLabel`?](#how-can-i-move-the-avatarview-to-prevent-it-from-overlapping-text-in-the-messagebottomlabel-or-celltoplabel)
- [How can I dismiss the keyboard?](#how-can-i-dismiss-the-keyboard)
- [How can I get a reference to the `MessageType` in the `MessageCellDelegate` methods?](#how-can-i-get-a-reference-to-the-messagetype-in-the-messagecelldelegate-methods)
- [Animations are laggy/Scrolling is not smooth/General poor performance](#animations-are-laggyscrolling-is-not-smoothgeneral-poor-performance)
- [How can I use MessageKit with SwiftUI](#how-can-i-use-messagekit-with-swiftui)

## Why doesn't the `MessageInputBar` appear in my controller?

If you're using the `MessagesViewController` as a child view controller then
you have to call `becomeFirstResponder()` on your view controller. The
reason is because the `MessageInputBar` is the `inputAccessoryView` of the
`MessagesViewController`. This means that it is not in the view hierarchy of
`MessagesViewController`'s root view.

```Swift
class ParentVC: UIViewController {
    override func viewDidLoad() {
       super.viewDidLoad()
       let childVC = MessagesViewController()
       addChildViewController(childVC)
       self.view.addSubview(childVC.view)
       childVC.didMove(toParentViewController:self)
       self.becomeFirstResponder()
    }
}
```

## How can I remove the `AvatarView` from the cell?

You can set the `AvatarView` to hidden through the `configureAvatarView(_:AvatarView,for:MessageType,at:IndexPath,in:MessagesCollectionView)` method of `MessagesDisplayDelegate`.

```Swift
func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
  avatarView.isHidden = true
}
```

If you would also like to remove the space the `AvatarView` occupies, you have to change the properties
`outgoingAvatarSize` or `incomingAvatarSize` of the `CellSizeCalculator` object for the respective message to `CGSize.zero` in
`viewDidLoad`.

```Swift
if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
  layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
  layout.textMessageSizeCalculator.incomingAvatarSize = .zero
}
```

If you would like to remove the space the `AvatarView` occupies from all `CellSizeCalculator`s there are
convenience methods so that you do not have to specify it for each `CellSizeCalculator` on `MessagesCollectionViewFlowLayout`.

```Swift
if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
  layout.setMessageIncomingAvatarSize(.zero)
  layout.setMessageOutgoingAvatarSize(.zero)
}
```

## How can I move the `AvatarView` to prevent it from overlapping text in the `MessageBottomLabel` or `CellTopLabel`?

If you have resized the `AvatarView` to be larger than the default size in MessageKit then you may notice that the
`AvatarView` overlaps text either in the `MessageBottomLabel` or `CallTopLabel`. MessageKit allows the `AvatarView`
to overlap this text on purpose so that users can create more complex layouts that fit their needs.

If you would like to move the `AvatarView`, there are convenience methods that allow you to change the horizontal or
vertical positioning of the `AvatarView` for both incoming and outgoing messages.

```Swift
if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
    // set the vertical position of the Avatar for incoming messages so that the bottom of the Avatar
    // aligns with the bottom of the Message
    layout.setMessageIncomingAvatarPosition(.init(vertical: .messageBottom))

    // set the vertical position of the Avatar for outgoing messages so that the bottom of the Avatar
    // aligns with the `cellBottom`
    layout.setMessageOutgoingAvatarPosition(.init(vertical: .cellBottom))
}
```

There are other options provided as well so take a look at the `AvatarPosition` struct to see what they are.

## How can I dismiss the keyboard?

The `MessagesViewController` needs to resign the first responder.

```Swift
let controller = MessagesViewController()
controller.resignFirstResponder()
```

## How can I get a reference to the `MessageType` in the `MessageCellDelegate` methods?

You can use `UICollectionView`'s method `indexPath(for: UICollectionViewCell)` to get the
`IndexPath` for the `MessageCollectionViewCell` argument. Using this `IndexPath`, you can
then get the `MessageType` for this cell through the `MessagesDataSource` method
`messageForItem(at:IndexPath,in:MessagesCollectionView)`.

```Swift
func didTapMessage(in cell: MessageCollectionViewCell) {
    guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
    guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
    let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
}
```

## Animations are laggy/Scrolling is not smooth/General poor performance

In general, if you're experiencing performance issues, you should look through the implementation of your MessageKit delegate methods like `var currentSender`, etc to find any expensive/blocking method calls or operations. Some delegate methods are called many times per message rendered and thus if their implementations are not efficient then performance can significantly degrade. Avoid doing blocking activities like synchronous database lookups, keychain access, networking, etc. in your MessageKit delegate methods. You should instead cache what you need.

## How can I use MessageKit with SwiftUI?

MessageKit support of SwiftUI is experimental at best and there is no active work being done on adding more support
