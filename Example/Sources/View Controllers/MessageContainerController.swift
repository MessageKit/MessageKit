//
//  ConversationContainerController.swift
//  Messenger
//
//  Created by Nathan Tannar on 2018-07-14.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import MapKit

final class MessageContainerController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let mapView = MKMapView()
    
    let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        view.alpha = 0.7
        return view
    }()
    
    let conversationViewController = BasicExampleViewController()
    
    /// Required for the `MessageInputBar` to be visible
    override var canBecomeFirstResponder: Bool {
        return conversationViewController.canBecomeFirstResponder
    }
    
    /// Required for the `MessageInputBar` to be visible
    override var inputAccessoryView: UIView? {
        return conversationViewController.inputAccessoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add the `ConversationViewController` as a child view controller
        conversationViewController.willMove(toParentViewController: self)
        self.addChildViewController(conversationViewController)
        view.addSubview(conversationViewController.view)
        conversationViewController.didMove(toParentViewController: self)
        
        view.addSubview(mapView)
        view.addSubview(bannerView)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let headerHeight: CGFloat = 200
        mapView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: headerHeight))
        bannerView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: headerHeight))
        conversationViewController.view.frame = CGRect(x: 0, y: headerHeight, width: view.bounds.width, height: view.bounds.height - headerHeight)
    }
    
}
