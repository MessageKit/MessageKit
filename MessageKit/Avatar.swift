//
//  Avatar.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation

// MARK: - Avatar

public struct Avatar {
    
    // MARK: - Properties
    
    public let image: UIImage?
    
    public let highlightedImage: UIImage?
    
    public let placeholderImage: UIImage
    
    // MARK: - Initializers
    
    public init(image: UIImage? = nil, highlightedImage: UIImage? = nil, placeholderImage: UIImage) {
        self.image = image
        self.highlightedImage = highlightedImage
        self.placeholderImage = placeholderImage
    }
    
    // MARK: - Methods
    
    public func image(highlighted: Bool) -> UIImage {
        return (highlighted ? highlightedImage : image) ?? placeholderImage
    }
}
