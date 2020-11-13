/*
 MIT License

 Copyright (c) 2017-2020 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import XCTest
@testable import MessageKit

final class AvatarViewTests: XCTestCase {

    var avatarView: AvatarView!

    override func setUp() {
        super.setUp()
        avatarView = AvatarView()
        avatarView.frame.size = CGSize(width: 30, height: 30)
    }

    override func tearDown() {
        super.tearDown()
        avatarView = nil
    }

    func testNoParams() {
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        // For certain dynamic colors, need to compare cgColor in XCTest
        // https://stackoverflow.com/questions/58065340/how-to-compare-two-uidynamicprovidercolor
        XCTAssertEqual(avatarView.backgroundColor!.cgColor, UIColor.avatarViewBackground.cgColor)
    }

    func testWithImage() {
        let avatar = Avatar(image: UIImage())
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatar.initials, "?")
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        XCTAssertEqual(avatarView.backgroundColor!.cgColor, UIColor.avatarViewBackground.cgColor)
    }

    func testInitialsOnly() {
        let avatar = Avatar(initials: "DL")
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatarView.initials, avatar.initials)
        XCTAssertEqual(avatar.initials, "DL")
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        XCTAssertEqual(avatarView.backgroundColor!.cgColor, UIColor.avatarViewBackground.cgColor)
    }

    func testSetBackground() {
        XCTAssertEqual(avatarView.backgroundColor!.cgColor, UIColor.avatarViewBackground.cgColor)
        avatarView.backgroundColor = UIColor.red
        XCTAssertEqual(avatarView.backgroundColor!, UIColor.red)
    }

    func testGetImage() {
        let image = UIImage()
        let avatar = Avatar(image: image)
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatarView.image, image)
    }

    func testRoundedCorners() {
        let avatar = Avatar(image: UIImage())
        avatarView.set(avatar: avatar)
        XCTAssertEqual(avatarView.layer.cornerRadius, 15.0)
        avatarView.setCorner(radius: 2)
        XCTAssertEqual(avatarView.layer.cornerRadius, 2.0)
    }
}
