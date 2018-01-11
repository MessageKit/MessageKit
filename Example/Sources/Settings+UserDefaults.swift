//
//  Settings+UserDefaults.swift
//  ChatExample
//
//  Created by Alessio Arsuffi on 11/01/2018.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let messagesKey = "mockMessages"
    
    // MARK: - Mock Messages
    
    func setMockMessages(count: Int) {
        set(count, forKey: "mockMessages")
        synchronize()
    }
    
    func mockMessagesCount() -> Int {
        if let value = object(forKey: "mockMessages") as? Int {
            return value
        }
        return 20
    }
}
