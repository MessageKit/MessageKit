# Custom cells 

## Creating a cell based on MessageBubble with MessageKit

To make a custom cell, you have to make a cell that inherit from `UICollectionViewCell`.

```swift
import UIKit
import MessageKit

open class CustomCell: UICollectionViewCell {
    
    let label = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    open func setupSubviews() {
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 13)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        // Do stuff
        switch message.kind {
        case .custom(let data):
            guard let systemMessage = data as? String else { return }
            label.text = systemMessage
        default:
            break
        }
    }
    
}
```

Once you have your cell, you need to tell the size of your cell. How can to do that ?

You have to make a class that inherit from `MessageSizeCalculator` or `CellSizeCalculator` to make a custom cell size calculator

You have to make a class that inherit from `MessagesCollectionViewFlowLayout` and add you custom size calculator that will calcul the size of your cell.

You must override two method to achieve that:

- `messageSizeCalculators()` to add your custom cell size calculator
- `cellSizeCalculatorForItem(at indexPath: IndexPath)` to choose with which cell you will use your custom cell calculator


You can see this example from the master branch:

```swift
open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    
    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
    
    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()
        // Append any of your custom `MessageSizeCalculator` if you wish for the convenience
        // functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
        superCalculators.append(customMessageSizeCalculator)
        return superCalculators
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    
    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        return CGSize(width: collectionViewWidth - inset, height: 44)
    }
  
}

```

## Creating a cell based on MessageBubble with MessageKit

[MessageContentCell](https://github.com/MessageKit/MessageKit/blob/master/Sources/Views/Cells/MessageContentCell.swift) is the class used by [MessageKit](https://github.com/MessageKit/MessageKit) to display your message in a chat bubble
You can create a cell by just extending this class: 

```swift
import MessageKit
import UIKit

open class CustomCell: MessageContentCell {

     open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
         super.configure(with: message, at: indexPath, and: messagesCollectionView)


      }

     override open func layoutAccessoryView(with attributes: MessagesCollectionViewLayoutAttributes) {
         // Accessory view is always on the opposite side of avatar
     }
  
  }
```

If you want to extend other [Cells](https://github.com/MessageKit/MessageKit/blob/master/Sources/Views/Cells)
