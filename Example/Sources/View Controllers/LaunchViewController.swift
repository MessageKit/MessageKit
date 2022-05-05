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
    private enum Row {
        case basic, advanced, autocomplete, embedded, customLayout, subview, swiftUI
        case settings, sourceCode, contributors

        var title: String {
            switch self {
            case .basic:
                return "Basic Example"
            case .advanced:
                return "Advanced Example"
            case .autocomplete:
                return "Autocomplete Example"
            case .embedded:
                return "Embedded Example"
            case .customLayout:
                return "Custom Layout Example"
            case .subview:
                return "Subview Example"
            case .swiftUI:
                return "SwiftUI Example"
            case .settings:
                return "Settings"
            case .sourceCode:
                return "Source Code"
            case .contributors:
                return "Contributors"
            }
        }
    }

    private struct Section {
        let title: String
        let rows: [Row]
    }

    private let sections: [Section] = [
        .init(title: "Examples", rows: [.basic, .advanced, .autocomplete, .embedded, .customLayout, .subview, .swiftUI]),
        .init(title: "Support", rows: [.settings, .sourceCode, .contributors])
    ]

    // MARK: - View Life Cycle

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MessageKit"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.text = sections[indexPath.section].rows[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // swiftlint:disable cyclomatic_complexity
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = sections[indexPath.section].rows[indexPath.row]
        switch cell {
        case .basic:
            let viewController = BasicExampleViewController()
            let detailViewController = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case .advanced:
            let viewController = AdvancedExampleViewController()
            let detailViewController = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case .autocomplete:
            let viewController = AutocompleteExampleViewController()
            let detailViewController = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case .embedded:
            navigationController?.pushViewController(MessageContainerController(), animated: true)
        case .customLayout:
            navigationController?.pushViewController(CustomLayoutExampleViewController(), animated: true)
        case .swiftUI:
            navigationController?.pushViewController(UIHostingController(rootView: SwiftUIExampleView()), animated: true)
        case .subview:
            let viewController = MessageSubviewContainerViewController()
            let detailViewController = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case .settings:
            let viewController = SettingsViewController()
            let detailViewController = UINavigationController(rootViewController: viewController)
            splitViewController?.showDetailViewController(detailViewController, sender: self)
        case .sourceCode:
            openURL(URL(string: "https://github.com/MessageKit/MessageKit")!)
        case .contributors:
            openURL(URL(string: "https://github.com/MessageKit/MessageKit/graphs/contributors")!)
        }
    }
    
    func openURL(_ url: URL) {
        let webViewController = SFSafariViewController(url: url)
        webViewController.preferredControlTintColor = .primaryColor
        splitViewController?.showDetailViewController(webViewController, sender: self)
    }
}
