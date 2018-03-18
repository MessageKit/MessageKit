/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
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

enum SettingsSection: Int {
    case messageCount = 0
    case allowedMessageTypes = 1
    
    static var sectionsCount = 2
}

final class SettingsViewController: UITableViewController {
    
    // MARK: - Picker
    
    var messagesPicker = UIPickerView()
    
    @objc func onDoneWithPickerView() {
        let selectedMessagesCount = messagesPicker.selectedRow(inComponent: 0)
        UserDefaults.standard.setMockMessages(count: selectedMessagesCount)
        view.endEditing(false)
        tableView.reloadData()
    }
    
    @objc func dismissPickerView() {
        view.endEditing(false)
    }
    
    private func configurePickerView() {
        messagesPicker.dataSource = self
        messagesPicker.delegate = self
        messagesPicker.backgroundColor = .white
    }
    
    // MARK: - Toolbar
    
    var messagesToolbar = UIToolbar()
    
    private func configureToolbar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDoneWithPickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissPickerView))
        messagesToolbar.items = [cancelButton, spaceButton, doneButton]
        messagesToolbar.sizeToFit()
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        
        configurePickerView()
        configureToolbar()
    }
    
    // MARK: - TableViewDelegate & TableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SettingsSection(rawValue: section)! {
        case .messageCount:
            return 3
        case .allowedMessageTypes:
            return MockMessageType.allTypes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch SettingsSection(rawValue: section)! {
        case .messageCount:
            return "Conversation"
        case .allowedMessageTypes:
            return "Allow Message Types"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SettingsSection(rawValue: indexPath.section)! {
        case .messageCount:
            switch indexPath.row {
            case 0:
                return configureTextFieldTableViewCell(at: indexPath)
            case 1:
                let title = "Show sender avatar"
                let isEnable = UserDefaults.standard.needShowSenderAvatar()
                return configureSliderTableViewCell(title, enable: isEnable, indexPath: indexPath)
            case 2:
                let title = "Show receiver avatar"
                let isEnable = UserDefaults.standard.needShowReceiverAvatar()
                return configureSliderTableViewCell(title, enable: isEnable, indexPath: indexPath)
            default:
                return UITableViewCell()
            }
        case .allowedMessageTypes:
            let type = MockMessageType.allTypes[indexPath.item]
            let title = type.rawValue.capitalized
            let isEnable = UserDefaults.standard.isAllowedMessageType(type)
            return configureSliderTableViewCell(title, enable: isEnable, indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch SettingsSection(rawValue: indexPath.section)! {
        case .messageCount:
            switch indexPath.row {
            case 0:
                let cell = tableView.cellForRow(at: indexPath)
                
                cell?.contentView.subviews.forEach {
                    if $0 is UITextField {
                        $0.becomeFirstResponder()
                    }
                }
            case 1:
                guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else { return }
                let newState = !cell.isEnable
                UserDefaults.standard.showSenderAvatar(newState)
                cell.isEnable = newState
            case 2:
                guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else { return }
                let newState = !cell.isEnable
                UserDefaults.standard.showReceiverAvatar(newState)
                cell.isEnable = newState
            default:
                return
            }
        case .allowedMessageTypes:
            guard let cell = tableView.cellForRow(at: indexPath) as? SwitchTableViewCell else { return }
            let selectedType = MockMessageType.allTypes[indexPath.item]
            let newState = !cell.isEnable
            if !newState, UserDefaults.standard.allowedMessageTypes().count <= 1 {
                return
            }
            UserDefaults.standard.messageType(selectedType, allow: newState)
            cell.isEnable = newState
        }
    }
    
    // MARK: - Helper
    
    private func configureTextFieldTableViewCell(at indexPath: IndexPath) -> TextFieldTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        cell.mainLabel.text = "Mock messages count:"
        
        let messagesCount = UserDefaults.standard.mockMessagesCount()
        cell.textField.text = "\(messagesCount)"
        
        cell.textField.inputView = messagesPicker
        cell.textField.inputAccessoryView = messagesToolbar
        
        return cell
    }
    
    private func configureSliderTableViewCell(_ title: String, enable: Bool, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
        cell.title = title
        cell.isEnable = enable
        return cell
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.setMockMessages(count: row)
    }
}
