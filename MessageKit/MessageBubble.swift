//
//  MessageBubble.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import UIKit

// MARK: - MessageBubble

public struct MessageBubble {
    
    // MARK: - Properties
    
    public let image: UIImage
    
    public let highlightedImage: UIImage
    
    // MARK: - Methods
    
    public func image(highlighted: Bool) -> UIImage {
        return highlighted ? image : highlightedImage
    }
}
