//
//  FloatingPoint+Extensions.swift
//  MessageKit
//
//  Created by Gungor Basa on 9/11/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation


extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
