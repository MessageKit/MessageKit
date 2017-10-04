//
//  AvatarTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/2/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class AvatarTests: XCTestCase {

    func testDefaultInit() {
        let avatar = Avatar()
        XCTAssertNil(avatar.image)
        XCTAssertEqual(avatar.initals, "?")
    }
    
}
