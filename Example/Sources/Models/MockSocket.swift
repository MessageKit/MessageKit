//
//  MockSocket.swift
//  Messenger
//
//  Created by Nathan Tannar on 2018-07-11.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import MessageKit

final class MockSocket {
    
    static var shared = MockSocket()
    
    private var timer: Timer?
    
    private var queuedMessage: MockMessage?
    
    private var onNewMessageCode: ((MockMessage) -> Void)?
    
    private var onTypingStatusCode: (() -> Void)?
    
    private var connectedUsers: [Sender] = []
    
    private init() {}
    
    @discardableResult
    func connect(with senders: [Sender]) -> Self {
        disconnect()
        connectedUsers = senders
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        timer?.invalidate()
        timer = nil
        onTypingStatusCode = nil
        onNewMessageCode = nil
        return self
    }
    
    @discardableResult
    func onNewMessage(code: @escaping (MockMessage) -> Void) -> Self {
        onNewMessageCode = code
        return self
    }
    
    @discardableResult
    func onTypingStatus(code: @escaping () -> Void) -> Self {
        onTypingStatusCode = code
        return self
    }
    
    @objc
    private func handleTimer() {
        if let message = queuedMessage {
            onNewMessageCode?(message)
            queuedMessage = nil
        } else {
            let sender = Bool.random() ? connectedUsers.first! : connectedUsers.last!
            queuedMessage = MockMessage(text: Lorem.sentence(), sender: sender, messageId: UUID().uuidString, date: Date())
            onTypingStatusCode?()
        }
    }
    
}
