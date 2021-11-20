# MessageKit Custom Cell Guide(s)

- [How can I add a custom cell?](#how-can-i-add-a-custom-cell)

## How can I add a custom cell?

**Note:** If you choose to use the `.custom` kind you are responsible for all of the cell's layout. You can design the cell in code or Interface Builder. Any `UICollectionViewCell` can be returned for custom cells which means any of the styling you provide from the `MessageDisplayDelegate` will not affect your custom cell, even if you subclass your cell from `MessageContentCell`.

**Creating a custom cell involves four parts:**
1. Build a cell in Interface Builder or code that inherits from `UICollectionViewCell`
2. Set the size of your cell. Subclass  `MessageSizeCalculator` if you want your cell to have the default MessageKit layout design. Subclass  `CellSizeCalculator` if you want to further customize your own cell design. The implementation of this class will allow your custom cell to automatically size itself within the `messagesCollectionView`.
3. Add your custom cell size to the collection view flow layout. Subclass `MessagesCollectionViewFlowLayout`, and use the custom message size calculator from step 2, above.
4. Register your custom cell and reference your custom collection view flow layout.


### Example:

Let's take a look at what it takes to create a custom cell that displays a red block for your custom message.

- **1. Custom Cell**: We create a cell that inherits from `UICollectionViewCell`
**MyCustomCell.swift**
```swift
open class MyCustomCell: UICollectionViewCell {
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        self.contentView.backgroundColor = UIColor.red
    }
}
```

- **2. MessageSizeCalculator**: We set the size of our cell by creating a class that inherits from `MessageSizeCalculator`
**CustomMessageSizeCalculator.swift**
```swift
open class CustomMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType) -> CGSize {
    // Customize this function implementation to size your content appropriately. This example simply returns a constant size
    // Refer to the default MessageKit cell implementations, and the Example App to see how to size a custom cell dynamically
        return CGSize(width: 300, height: 130)
    }
}
```

- **3. MessageFlowLayout**: We add our custom message size calculator to our collection view layout by creating a class that inherits from `MessagesCollectionViewFlowLayout`
**MyCustomMessagesFlowLayout.swift**
```swift
open class MyCustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    lazy open var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)

    override open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        //before checking the messages check if section is reserved for typing otherwise it will cause IndexOutOfBounds error
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return typingIndicatorSizeCalculator
        }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath);
    }
}
```
- **4. Implementation**: We register our custom cell and reference our newly created `MyCustomMessagesFlowLayout.swift`
**ConversationViewController.swift**
```swift
internal class ConversationViewController: MessagesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MyCustomMessagesFlowLayout())
        messagesCollectionView.register(MyCustomCell.self)
        //...
    }
//...
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        //before checking the messages check if section is reserved for typing otherwise it will cause IndexOutOfBounds error
        if isSectionReservedForTypingIndicator(indexPath.section){
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(MyCustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
}
```
