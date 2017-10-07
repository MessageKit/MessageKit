/*
 MIT License
 
 Copyright (c) 2017 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

open class AttachmentManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open weak var delegate: AttachmentManagerDelegate?
    
    open weak var dataSource: AttachmentManagerDataSource?
    
    open lazy var attachmentView: AttachmentsView = { [weak self] in
        let attachmentView = AttachmentsView()
        attachmentView.dataSource = self
        attachmentView.delegate = self
        return attachmentView
    }()
    
    open var attachments = [AnyObject]() {
        didSet {
            reload()
        }
    }
    
    /// A flag you can use to determine if you want the manager to be always visible
    open var isPersistent = false {
        didSet {
            reload()
        }
    }
    
    /// The block that will be called when the add attachment cell is pressed. When not nil, the add attachment cell is added
    open var addAttachmentCellPressedBlock: ((AttachmentManager)->Void)? {
        didSet {
            reload()
        }
    }
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
    }
    
    open func reload() {
        attachmentView.reloadData()
        delegate?.attachmentManager(self, didReloadTo: attachments)
    }
    
    open func invalidate() {
        attachments.removeAll()
    }
    
    /// Performs an animated insertion of an attachment at an index
    ///
    /// - Parameter index: The index to insert the attachment at
    open func insertAttachment(_ attachment: AnyObject, at index: Int) {
        
        attachmentView.performBatchUpdates({
            self.attachments.insert(attachment, at: index)
            self.attachmentView.insertItems(at: [IndexPath(row: index, section: 0)])
        }, completion: { success in
            self.attachmentView.reloadData()
            self.delegate?.attachmentManager(self, didInsert: attachment, at: index)
        })
    }
    
    /// Performs an animated removal of an attachment at an index
    ///
    /// - Parameter index: The index to remove the attachment at
    open func removeAttachment(at index: Int) {
        
        let attachment = attachments[index]
        attachmentView.performBatchUpdates({
            self.attachments.remove(at: index)
            self.attachmentView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }, completion: { success in
            self.attachmentView.reloadData()
            self.delegate?.attachmentManager(self, didRemove: attachment, at: index)
        })
    }
    
    // MARK: - UICollectionViewDelegate
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == attachments.count {
            addAttachmentCellPressedBlock?(self)
        }
    }

    // MARK: - UICollectionViewDataSource
    
    open func numberOfItems(inSection section: Int) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count + (addAttachmentCellPressedBlock != nil ? 1 : 0)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == attachments.count {
            return addAttachmentCell(in: collectionView, at: indexPath)
        } else if let dataSource = dataSource {
            return dataSource.attachmentManager(self, cellFor: attachments[indexPath.row], at: indexPath)
        }
        return defaultCell(in: collectionView, for: attachments[indexPath.row], at: indexPath) ?? collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = collectionView.frame.height
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            height -= (layout.sectionInset.bottom + layout.sectionInset.top)
        }
        return CGSize(width: height, height: height)
    }
    
    // MARK: - Default Cells
    
    open func defaultCell(in collectionView: UICollectionView, for attachment: AnyObject, at indexPath: IndexPath) -> AttachmentCell? {
        
        if let image = attachments[indexPath.row] as? UIImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAttachmentCell.reuseIdentifier, for: indexPath) as? ImageAttachmentCell else {
                fatalError()
            }
            cell.indexPath = indexPath
            cell.manager = self
            cell.imageView.image = image
            return cell
        }
        return nil
    }
    
    open func addAttachmentCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> AttachmentCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as? AttachmentCell else {
            fatalError()
        }
        cell.deleteButton.isHidden = true
        // Draw a plus
        let frame = CGRect(origin: CGPoint(x: cell.bounds.origin.x,
                                           y: cell.bounds.origin.y),
                           size: CGSize(width: cell.bounds.width - cell.padding.left - cell.padding.right,
                                        height: cell.bounds.height - cell.padding.top - cell.padding.bottom))
        let strokeWidth: CGFloat = 3
        let length: CGFloat = frame.width / 2
        let vLayer = CAShapeLayer()
        vLayer.path = UIBezierPath(roundedRect: CGRect(x: frame.midX - (strokeWidth / 2),
                                                       y: frame.midY - (length / 2),
                                                       width: strokeWidth,
                                                       height: length), cornerRadius: 5).cgPath
        vLayer.fillColor = UIColor.lightGray.cgColor
        let hLayer = CAShapeLayer()
        hLayer.path = UIBezierPath(roundedRect: CGRect(x: frame.midX - (length / 2),
                                                       y: frame.midY - (strokeWidth / 2),
                                                       width: length,
                                                       height: strokeWidth), cornerRadius: 5).cgPath
        hLayer.fillColor = UIColor.lightGray.cgColor
        cell.containerView.layer.addSublayer(vLayer)
        cell.containerView.layer.addSublayer(hLayer)
        return cell
    }
}
