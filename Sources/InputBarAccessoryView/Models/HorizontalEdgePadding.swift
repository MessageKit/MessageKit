//
//  HorizontalEdgePadding.swift
//  InputBarAccessoryView
//
//  Created by Nathan Tannar on 2018-11-07.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import CoreGraphics

public struct HorizontalEdgePadding {
    public let left: CGFloat
    public let right: CGFloat

    public static let zero = HorizontalEdgePadding(left: 0, right: 0)

    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}
