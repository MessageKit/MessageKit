//
//  AvatarViewTests.swift
//  MessageKit
//
//  Created by Dan Leonard on 8/5/17.
//  Copyright © 2017 Hexed Bits. All rights reserved.
//

import XCTest
@testable import MessageKit

class AvatarViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNoParams() {
        let avatarView = AvatarView()
        XCTAssertEqual(avatarView.avatar.initals, "?")
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        XCTAssertEqual(avatarView.backgroundColor, UIColor.gray)
    }
    
    func testWithImage() {
        let avatarView = AvatarView()
        let avatar = Avatar(image: UIImage())
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatar.initals, "?")
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        XCTAssertEqual(avatarView.backgroundColor, UIColor.gray)
    }
    
    func testInitalsOnly() {
        let avatarView = AvatarView()
        let avatar = Avatar(initals: "DL")
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatar.initals, "DL")
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        XCTAssertEqual(avatarView.backgroundColor, UIColor.gray)
    }
    
    func testSetBackground() {
        let avatarView = AvatarView()
        XCTAssertEqual(avatarView.backgroundColor, UIColor.gray)
        avatarView.setBackground(color: UIColor.red)
        XCTAssertEqual(avatarView.backgroundColor, UIColor.red)
    }
    
    func testGetImage() {
        let image = UIImage()
        let avatar = Avatar(image: image)
        let avatarView = AvatarView()
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatarView.getImage(), image)
    }
    
    func testRoundedCorners() {
        let avatarView = AvatarView()
        let avatar = Avatar(image: UIImage())
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        avatarView.setCorner(radius: 2)
        XCTAssertEqual(avatarView.layer.cornerRadius, 2.0)
    }
}
