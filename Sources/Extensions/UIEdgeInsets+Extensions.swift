//
//  UIEdgeInsets+Extensions.swift
//  MessageKit
//
//  Created by Steven Deutsch on 1/26/18.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import Foundation

extension UIEdgeInsets {

    var vertical: CGFloat {
        return top + bottom
    }

    var horizontal: CGFloat {
        return left + right
    }

}
