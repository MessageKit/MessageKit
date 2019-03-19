//
//  MessageKind+KindStructureWrapper.swift
//  ConversationAI
//
//  Created by Gumdal, Raj Pawan on 14/03/19.
//  Copyright © 2019 Gumdal, Raj Pawan. All rights reserved.
//

import Foundation
import MessageKit

extension ChatMessageKind {
    // From: https://stackoverflow.com/a/37877297/260665
    var kind: MessageKind {
        get {
            return .text(self.text ?? "s")
        }
        set {
            // From: https://stackoverflow.com/a/25355800/260665
            switch newValue {
            case .text(let textValue):
                self.text = textValue
            default:
                self.text = ""
            }
        }
    }
}
