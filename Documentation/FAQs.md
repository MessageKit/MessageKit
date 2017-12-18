# MessageKit Frequently Asked Questions

**Why doesn't the `MessageInputBar` appear in my controller?**

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

**How can I remove the `AvatarView` from the cell?**

If you return `CGSize.zero` from the `MessagesLayoutDelegate` method
`avatarSize(for:MessageType,at:IndexPath,in:MessagesCollectionView)`, the `AvatarView`
will not be visible for that cell.

```Swift
func avatarSize(for: MessageType, at: IndexPath, in: MessagesCollectionView) -> CGSize {
    return .zero
}
```

**How can I dismiss the keyboard?**

The `MessagesViewController` needs to resign the first responder.

```Swift
let controller = MessagesViewController()
controller.resignFirstResponder()
```

**How can I get a reference to the `MessageType` in the `MessageCellDelegate` methods?**

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
