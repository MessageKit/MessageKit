//
//  DetectorTypeTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/2/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class DetectorTypeTests: XCTestCase {
    
    func testTextCheckingType() {
        XCTAssertEqual(DetectorType.address.textCheckingType, .address)
        XCTAssertEqual(DetectorType.date.textCheckingType, .date)
        XCTAssertEqual(DetectorType.phoneNumber.textCheckingType, .phoneNumber)
        XCTAssertEqual(DetectorType.url.textCheckingType, .link)
    }
    
}
