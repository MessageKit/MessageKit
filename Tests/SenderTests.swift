//
//  SenderTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/2/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class SenderTests: XCTestCase {
    
    var senderBob: Sender!
    
    override func setUp() {
        super.setUp()
        senderBob = Sender(id: "id1", displayName: "Bob")
    }
    
    override func tearDown() {
        super.tearDown()
        senderBob = nil
    }
    
    func testEquatableWithSameID() {
        let alsoSenderBob = Sender(id: "id1", displayName: "Bob")
        XCTAssertEqual(senderBob, alsoSenderBob)
    }
    
    func testEquatableWithDifferentID() {
        let anotherSenderBob = Sender(id: "id2", displayName: "Bob")
        XCTAssertNotEqual(senderBob, anotherSenderBob)
    }
}
