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

    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
//        if let topVC = UIApplication.getTopMostViewController() {
//            alert.popoverPresentationController?.sourceView = topVC.view
//            alert.popoverPresentationController?.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
//            alert.popoverPresentationController?.permittedArrowDirections = []
//            topVC.present(alert, animated: true, completion: completion)
//        }
        
        if let current = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController {
            
            current.present(alert, animated: true, completion: completion)
        }
    }
    
    
}



extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}



