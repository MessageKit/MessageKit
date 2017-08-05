//
//  AvatarTests.swift
//  MessageKit
//
//  Created by Dan Leonard on 8/4/17.
//  Copyright © 2017 Hexed Bits. All rights reserved.
//

import XCTest
@testable import MessageKit

class AvatarTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNoParams() {
        let avatar = AvatarView()
        XCTAssertEqual(avatar.initals, "?")
        XCTAssertEqual(avatar.initalsLabel.text, "?")
        XCTAssertEqual(avatar.layer.cornerRadius, 15.0)
        XCTAssertNil(avatar.imageView.image)
        XCTAssertTrue(avatar.imageView.isHidden)
        XCTAssertEqual(avatar.initalsLabel.textColor, UIColor.white)
    }

    func testWithImage() {
        let avatar = AvatarView(image: UIImage())
        XCTAssertEqual(avatar.initals, "?")
        XCTAssertEqual(avatar.initalsLabel.text, "?")
        XCTAssertEqual(avatar.layer.cornerRadius, 15.0)
        XCTAssertFalse(avatar.imageView.isHidden)
        XCTAssertEqual(avatar.initalsLabel.textColor, UIColor.white)
        XCTAssertEqual(avatar.backgroundColor, UIColor.gray)
    }

    func testCustom() {
        let avatar = AvatarView(size: 50, image: UIImage(), highlightedImage: nil, initals: "lol", cornerRounding: 6)
        XCTAssertEqual(avatar.initals, "lol")
        XCTAssertEqual(avatar.initalsLabel.text, "lol")
        XCTAssertEqual(avatar.layer.cornerRadius, 6.0)
        XCTAssertFalse(avatar.imageView.isHidden)
        XCTAssertEqual(avatar.initalsLabel.textColor, UIColor.white)
        XCTAssertEqual(avatar.backgroundColor, UIColor.gray)
    }

    func testSetBackground() {
        let avatar = AvatarView(image: UIImage())
        XCTAssertEqual(avatar.backgroundColor, UIColor.gray)
        avatar.setBackground(color: UIColor.red)
        XCTAssertEqual(avatar.backgroundColor, UIColor.red)
    }

    func testGetImage() {
        let image = UIImage()
        let avatar = AvatarView(image: image)
        XCTAssertEqual(avatar.getImage(), image)
    }

    func testRoundedCorners() {
        let avatar = AvatarView(image: UIImage())
        XCTAssertEqual(avatar.layer.cornerRadius, 15.0)
        avatar.roundCorners(by: 2)
        XCTAssertEqual(avatar.layer.cornerRadius, 2.0)
    }

    func testInitalsFont() {
        let avatar = AvatarView(image: UIImage())
        XCTAssertEqual(avatar.initalsLabel.textColor, UIColor.white)
        XCTAssertEqual(avatar.initalsLabel.font.pointSize, 16)
        avatar.setInitalsFont(size: 20, color: UIColor.blue)
        XCTAssertEqual(avatar.initalsLabel.textColor, UIColor.blue)
        XCTAssertEqual(avatar.initalsLabel.font.pointSize, 20)
    }
}
