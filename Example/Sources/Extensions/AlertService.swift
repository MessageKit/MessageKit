//
//  AlertService.swift
//  ChatExample
//
//  Created by Mohannad on 12/25/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
  static func showAlert(
    style: UIAlertController.Style,
    title: String?,
    message: String?,
    actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)],
    completion: (() -> Swift.Void)? = nil)
  {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actions {
      alert.addAction(action)
    }

    UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: completion)
  }
}
