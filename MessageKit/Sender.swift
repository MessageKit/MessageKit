//
//  Sender.swift
//  MessageKit
//
//  Created by Steven on 7/19/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import Foundation

// MARK: - Sender

public struct Sender {

    // MARK: - Properties

    let id: String

    let displayName: String

}

// MARK: - Equatable Conformance

extension Sender: Equatable {

    static public func ==(lhs: Sender, rhs: Sender) -> Bool {
        return lhs.id == rhs.id
    }

}
