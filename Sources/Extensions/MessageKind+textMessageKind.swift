//
//  MessageKind+textMessageKind.swift
//  MessageKit
//
//  Created by Kino Roy on 2020-09-19.
//

import Foundation

extension MessageKind {
    var textMessageKind: MessageKind {
        switch self {
        case .linkPreview(let linkItem):
            return linkItem.textKind
        case .text, .emoji, .attributedText:
            return self
        default:
            fatalError("textMessageKind not supported for messageKind: \(self)")
        }
    }
}
