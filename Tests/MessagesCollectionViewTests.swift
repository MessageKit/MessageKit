//
//  MessagesCollectionViewTests.swift
//  MessageKitTests
//
//  Created by Vitaly on 10/3/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import XCTest
@testable import MessageKit

class MessagesCollectionViewTests: XCTestCase {
    
    var messagesCollectionView: MessagesCollectionView!
    let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    let layout = UICollectionViewLayout()
    override func setUp() {
        super.setUp()
        messagesCollectionView = MessagesCollectionView(frame: rect, collectionViewLayout: layout)
    }
    
    override func tearDown() {
        messagesCollectionView = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertEqual(messagesCollectionView.frame, rect)
        XCTAssertEqual(messagesCollectionView.collectionViewLayout, layout)
        XCTAssertEqual(messagesCollectionView.backgroundColor, .white)
    }
    
}
