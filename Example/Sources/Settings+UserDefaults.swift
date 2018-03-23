/*
 MIT License
 
 Copyright (c) 2017 MessageKit
 
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

extension UserDefaults {
    
    private static let messagesKey = "mockMessages"
    private static let allowedMessageTypesKey = "allowedMessageTypes"
    
    private static let showSenderAvatarKey = "showSenderAvatarKey"
    private static let showReceiverAvatarKey = "showReceiverAvatarKey"
  
    // MARK: - Mock Messages
    
    func setMockMessages(count: Int) {
        set(count, forKey: UserDefaults.messagesKey)
        synchronize()
    }
    
    func mockMessagesCount() -> Int {
        if let value = object(forKey: UserDefaults.messagesKey) as? Int {
            return value
        }
        return 20
    }
    
    // MARK: - Avatar Settings
    
    func showSenderAvatar(_ show: Bool) {
        set(show, forKey: UserDefaults.showSenderAvatarKey)
        synchronize()
    }
    
    func needShowSenderAvatar() -> Bool {
        guard let needShow = object(forKey: UserDefaults.showSenderAvatarKey) as? Bool else {
            return true
        }
        return needShow
    }
    
    func showReceiverAvatar(_ show: Bool) {
        set(show, forKey: UserDefaults.showReceiverAvatarKey)
        synchronize()
    }
    
    func needShowReceiverAvatar() -> Bool {
        guard let needShow = object(forKey: UserDefaults.showReceiverAvatarKey) as? Bool else {
            return true
        }
        return needShow
    }
    
    // MARK: - Allowed Message Types
    
    func setAllowedMessagesTypes(_ types: [MockMessageType]) {
        let typesRawValue = types.map { return $0.rawValue }
        set(typesRawValue, forKey: UserDefaults.allowedMessageTypesKey)
        synchronize()
    }
    
    func messageType(_ type: MockMessageType, allow: Bool) {
        var allowedType = allowedMessageTypes()
        if allow, !allowedType.contains(type) {
            allowedType.append(type)
            setAllowedMessagesTypes(allowedType)
        }
        if !allow, allowedType.contains(type) {
            guard let typeIndex = allowedType.index(of: type) else { return }
            allowedType.remove(at: typeIndex)
            setAllowedMessagesTypes(allowedType)
        }
    }
    
    func allowedMessageTypes() -> [MockMessageType] {
        guard let typesRawValue = object(forKey: UserDefaults.allowedMessageTypesKey) as? [String] else {
            return MockMessageType.allTypes
        }
        let allowedTypes = typesRawValue.map { return MockMessageType(rawValue: $0) }.flatMap { $0 }
        return allowedTypes
    }
    
    func isAllowedMessageType(_ type: MockMessageType) -> Bool {
        return allowedMessageTypes().contains(type)
    }
    
}
