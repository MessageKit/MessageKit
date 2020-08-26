/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
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

import UIKit
import MessageKit
import SafariServices
import SwiftUI

final internal class LaunchViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let cells = ["Basic Example", "Advanced Example", "Autocomplete Example", "Embedded Example", "Subview Example", "SwiftUI Example", "Settings", "Source Code", "Contributors"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MessageKit"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.text = cells[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // swiftlint:disable cyclomatic_complexity
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cells[indexPath.row]
        switch cell {
        case "Basic Example":
            let viewController = BasicExampleViewController()
            let detailViewController = NavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case "Advanced Example":
            let viewController = AdvancedExampleViewController()
            let detailViewController = NavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case "Autocomplete Example":
            let viewController = AutocompleteExampleViewController()
            let detailViewController = NavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case "Embedded Example":
            navigationController?.pushViewController(MessageContainerController(), animated: true)
        case "SwiftUI Example":
            if #available(iOS 13, *) {
                navigationController?.pushViewController(UIHostingController(rootView: SwiftUIExampleView()), animated: true)
            }
        case "Settings":
            let viewController = SettingsViewController()
            let detailViewController = NavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case "Subview Example":
            let viewController = MessageSubviewContainerViewController()
            let detailViewController = NavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case "Source Code":
            guard let url = URL(string: "https://github.com/MessageKit/MessageKit") else { return }
            openURL(url)
        case "Contributors":
            guard let url = URL(string: "https://github.com/orgs/MessageKit/teams/contributors/members") else { return }
            openURL(url)
        default:
            assertionFailure("You need to impliment the action for this cell: \(cell)")
            return
        }
    }
    
    func openURL(_ url: URL) {
        let webViewController = SFSafariViewController(url: url)
        webViewController.preferredControlTintColor = .primaryColor
        splitViewController?.showDetailViewController(webViewController, sender: self)
    }
}
