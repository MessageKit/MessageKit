//
//  MessageSubviewContainerViewController.swift
//  ChatExample
//
//  Created by Ng, Ashley on 3/10/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import UIKit

final class MessageSubviewContainerViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let messageSubviewViewController = MessageSubviewViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        messageSubviewViewController.willMove(toParent: self)
        addChild(messageSubviewViewController)
        view.addSubview(messageSubviewViewController.view)
        messageSubviewViewController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .primaryColor
    }

}
