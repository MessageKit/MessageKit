//
//  MessageSubviewViewController.swift
//  ChatExample
//
//  Created by Ng, Ashley on 3/10/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import InputBarAccessoryView

class MessageSubviewViewController: BasicExampleViewController {

    private var keyboardManager = KeyboardManager()

    private let subviewInputBar = InputBarAccessoryView()

    override func viewDidLoad() {
        super.viewDidLoad()
        subviewInputBar.delegate = self
        additionalBottomInset = 88
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        parent?.view.addSubview(subviewInputBar)
        keyboardManager.bind(inputAccessoryView: subviewInputBar)
    }

    override func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(subviewInputBar)
    }
}
