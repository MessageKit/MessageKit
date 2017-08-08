//
//  Avatar.swift
//  MessageKit
//
//  Created by Dan Leonard on 8/7/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation
public struct Avatar {
    
    public let image: UIImage?
    public var initals: String = "?"
    
    public init(image: UIImage? = nil, initals: String = "?") {
        self.image = image
        self.initals = initals
    }
    
}
