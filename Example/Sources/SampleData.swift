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
        let msg7 = MockMessage(text: "Remembering that I'll be dead soon is the most important tool I've ever encountered to help me make the big choices in life. Because almost everything - all external expectations, all pride, all fear of embarrassment or failure - these things just fall away in the face of death, leaving only what is truly important.", sender: Jobs, messageId: UUID().uuidString)
        let msg8 = MockMessage(text: "Price is rarely the most important thing. A cheap product might sell some units. Somebody gets it home and they feel great when they pay the money, but then they get it home and use it and the joy is gone.", sender: Cook, messageId: UUID().uuidString)

        let msg9Text = NSString(string: "Use .attributedText() to add bold, italic, colored text and more...")
        let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))

        if #available(iOS 9.0, *) {
            msg9AttributedText.addAttributes([NSFontAttributeName: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFontWeightBold)], range: msg9Text.range(of: ".attributedText()"))
        } else {
            msg9AttributedText.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle], range: msg9Text.range(of: ".attributedText()"))
        }

        msg9AttributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)],
                                         range: msg9Text.range(of: "bold"))

        msg9AttributedText.addAttributes([NSFontAttributeName: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)],
                                         range: msg9Text.range(of: "italic"))

        msg9AttributedText.addAttributes([NSForegroundColorAttributeName: UIColor.red],
                                         range: msg9Text.range(of: "colored"))

        let msg9 = MockMessage(text: msg9AttributedText, sender: Jobs, messageId: UUID().uuidString)
        
        return [msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8, msg9]
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
