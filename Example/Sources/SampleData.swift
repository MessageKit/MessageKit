//
//  SampleData.swift
//  ChatExample
//
//  Created by Dan Leonard on 8/7/17.
//  Copyright © 2017 MessageKit. All rights reserved.
//

import MessageKit

struct SampleData {
    let Dan = Sender(id: "123456", displayName: "Dan Leonard")
    let Steven = Sender(id: "654321", displayName: "Steven")
    let Jobs = Sender(id: "000001", displayName: "Steve Jobs")
    let Cook = Sender(id: "656361", displayName: "Tim Cook")

    func getMessages() -> [MockMessage] {
        let msg1 = MockMessage(text: "Check out this awesome UI library for Chat", sender: Dan, messageId: UUID().uuidString)
        let msg2 = MockMessage(text: "This is insane.", sender: Steven, messageId: UUID().uuidString)
        let msg3 = MockMessage(text: "Companies that get confused, that think their goal is revenue or stock price or something. You have to focus on the things that lead to those.", sender: Cook, messageId: UUID().uuidString)
        let msg4 =  MockMessage(text: "My favorite things in life don’t cost any money. It’s really clear that the most precious resource we all have is time.", sender: Jobs, messageId: UUID().uuidString)
        let msg5 = MockMessage(text: "You know, this iPhone, as a matter of fact, the engine in here is made in America. And not only are the engines in here made in America, but engines are made in America and are exported. The glass on this phone is made in Kentucky. And so we've been working for years on doing more and more in the United States.", sender: Cook, messageId: UUID().uuidString)
        let msg6 =  MockMessage(text: "I think if you do something and it turns out pretty good, then you should go do something else wonderful, not dwell on it for too long. Just figure out what’s next.", sender: Jobs, messageId: UUID().uuidString)

        return [msg1, msg2, msg3, msg4, msg5, msg6]
    }
    
    func getCurrentSender() -> Sender {
        return Dan
    }
    
    func getAvatarFor(sender: Sender) -> Avatar {
        switch sender {
        case Dan:
            return Avatar(image: #imageLiteral(resourceName: "Dan-Leonard"), initals: "DL")
        case Steven:
            return Avatar(initals: "S")
        case Jobs:
            return Avatar(image: #imageLiteral(resourceName: "Steve-Jobs"), initals: "SJ")
        case Cook:
            return Avatar(image: #imageLiteral(resourceName: "Tim-Cook"))
        default:
            return Avatar()
        }
    }
}
