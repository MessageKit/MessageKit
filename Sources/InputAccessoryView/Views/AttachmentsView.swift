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

open class AttachmentsView: UICollectionView {
    
    // MARK: - Properties
    
    open var attachmentViewHeight: CGFloat = 100
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: attachmentViewHeight)
    }
    
    // MARK: - Initialization
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset.top = 5
        layout.sectionInset.bottom = 5
        layout.footerReferenceSize = CGSize(width: 5, height: 0)
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        backgroundColor = .white
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = true
        setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        register(AttachmentCell.self, forCellWithReuseIdentifier: "AttachmentCell")
        register(ImageAttachmentCell.self, forCellWithReuseIdentifier: ImageAttachmentCell.reuseIdentifier)
    }
}
