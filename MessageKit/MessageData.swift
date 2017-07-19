//
//  MessageData.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation
import class CoreLocation.CLLocation

// MARK: - MessageData

public enum MessageData {
    
    case text(String)
    
    case attributedText(NSAttributedString)
    
    case audio(Data)
    
    case location(CLLocation)
    
    case photo(UIImage)
    
    case video(file: NSURL, thumbnail: UIImage)
    
    case system(String)
    
    case custom(Any)
    
    case placeholder
}
