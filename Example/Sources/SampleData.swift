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
        var msg2 = MockMessage(text: "This is insane.", sender: Steven, messageId: UUID().uuidString)
        var msg3 = MockMessage(text: "Companies that get confused, that think their goal is revenue or stock price or something. You have to focus on the things that lead to those.", sender: Cook, messageId: UUID().uuidString)
        var msg4 =  MockMessage(text: "My favorite things in life don’t cost any money. It’s really clear that the most precious resource we all have is time.", sender: Jobs, messageId: UUID().uuidString)
        var msg5 = MockMessage(text: "You know, this iPhone, as a matter of fact, the engine in here is made in America. And not only are the engines in here made in America, but engines are made in America and are exported. The glass on this phone is made in Kentucky. And so we've been working for years on doing more and more in the United States.", sender: Cook, messageId: UUID().uuidString)
        var msg6 =  MockMessage(text: "I think if you do something and it turns out pretty good, then you should go do something else wonderful, not dwell on it for too long. Just figure out what’s next.", sender: Jobs, messageId: UUID().uuidString)
        var msg7 = MockMessage(text: "Remembering that I'll be dead soon is the most important tool I've ever encountered to help me make the big choices in life. Because almost everything - all external expectations, all pride, all fear of embarrassment or failure - these things just fall away in the face of death, leaving only what is truly important.", sender: Jobs, messageId: UUID().uuidString)
        var msg8 = MockMessage(text: "Price is rarely the most important thing. A cheap product might sell some units. Somebody gets it home and they feel great when they pay the money, but then they get it home and use it and the joy is gone.", sender: Cook, messageId: UUID().uuidString)

        let msg9String = "Use .attributedText() to add bold, italic, colored text and more..."
		let msg9Text = NSString(string: msg9String)
		let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))
        msg9AttributedText.addAttribute(NSFontAttributeName, value: UIFont.preferredFont(forTextStyle: .body), range: NSRange(location: 0, length: msg9Text.length))
		
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
		
		var msg9 = MockMessage(attributedText: msg9AttributedText, sender: Jobs, messageId: UUID().uuidString)

        var msg10 = MockMessage(text: "1-800-555-0000", sender: Steven, messageId: UUID().uuidString)
        var msg11 = MockMessage(text: "One Infinite Loop Cupertino, CA 95014 This is some extra text that should not be detected.", sender: Cook, messageId: UUID().uuidString)
        var msg12 = MockMessage(text: "This is an example of the date detector 11/11/2017. April 1st is April Fools Day. Next Friday is not Friday the 13th.", sender: Steven, messageId: UUID().uuidString)
        var msg13 = MockMessage(text: "https//:github.com/SD10", sender: Steven, messageId: UUID().uuidString)

        msg2.sentDate = Calendar.current.date(byAdding: .hour, value: 2, to: msg1.sentDate)!
        msg3.sentDate = Calendar.current.date(byAdding: .hour, value: 1, to: msg2.sentDate)!
        msg4.sentDate = Calendar.current.date(byAdding: .minute, value: 37, to: msg3.sentDate)!
        msg5.sentDate = Calendar.current.date(byAdding: .minute, value: 3, to: msg4.sentDate)!
        msg6.sentDate = Calendar.current.date(byAdding: .hour, value: 2, to: msg5.sentDate)!
        msg7.sentDate = Calendar.current.date(byAdding: .minute, value: 12, to: msg6.sentDate)!
        msg8.sentDate = Calendar.current.date(byAdding: .minute, value: 23, to: msg7.sentDate)!
        msg9.sentDate = Calendar.current.date(byAdding: .hour, value: 300, to: msg8.sentDate)!
        msg10.sentDate = Calendar.current.date(byAdding: .hour, value: 11, to: msg9.sentDate)!
        msg11.sentDate = Calendar.current.date(byAdding: .hour, value: 2, to: msg10.sentDate)!
        msg12.sentDate = Calendar.current.date(byAdding: .minute, value: 59, to: msg11.sentDate)!
        msg13.sentDate = Calendar.current.date(byAdding: .hour, value: 7, to: msg12.sentDate)!
		
        return [msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8, msg9, msg10, msg11, msg12, msg13]
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
