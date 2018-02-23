//
//  MessageReusableView.swift
//  MessageKit
//
//  Created by Steven Deutsch on 2/23/18.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import Foundation

open class MessageReusableView: UICollectionReusableView, CollectionViewReusable {

    open class func reuseIdentifier() -> String {
        return "messagekit.reusableview.base"
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
