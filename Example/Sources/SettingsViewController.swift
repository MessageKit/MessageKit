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

final class SettingsViewController: UITableViewController {

    // MARK: - Properties
    
    var selectedMockMessagesCount: Int = 20

    let cells = ["Mock messages count:", "Hide text messages", "Hide attributedText messages", "Hide photo messages", "Hide video messages"]
    
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
        tableView.register(LabelSwitchTableViewCell.self, forCellReuseIdentifier: LabelSwitchTableViewCell.identifier)

        configurePickerView()
        configureToolbar()

        title = "Settings"
    }
    
    // MARK: - TableViewDelegate & TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            case 0:
                return configureTextFieldTableViewCell(at: indexPath)

            case 1...4:
                return configureLabelSwitchTableViewCell(at: indexPath)

            default:
                return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.contentView.subviews.forEach {
            if $0 is UITextField {
                $0.becomeFirstResponder()
            }
        }
    }
    
    // MARK: - Helper
    
    private func configureTextFieldTableViewCell(at indexPath: IndexPath) -> TextFieldTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
        cell.mainLabel.text = cells[indexPath.row]
        
        let messagesCount = UserDefaults.standard.mockMessagesCount()
        cell.textField.text = "\(messagesCount)"
        
        cell.textField.inputView = messagesPicker
        cell.textField.inputAccessoryView = messagesToolbar
        
        return cell
    }

    private func configureLabelSwitchTableViewCell(at indexPath: IndexPath) -> LabelSwitchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelSwitchTableViewCell.identifier, for: indexPath) as! LabelSwitchTableViewCell
        cell.mainLabel.text = cells[indexPath.row]
        cell.delegate = self

        var isOn = false
        switch indexPath.row {
        case 1:
            isOn = UserDefaults.standard.shouldHideTextMessages()
        case 2:
            isOn = UserDefaults.standard.shouldHideAttributedTextMessages()
        case 3:
            isOn = UserDefaults.standard.shouldHidePhotoMessages()
        case 4:
            isOn = UserDefaults.standard.shouldHideVideoMessages()
        default: break
        }

        cell.cellSwitch.setOn(isOn, animated: true)
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
        selectedMockMessagesCount = row
    }
}

// MARK: - LabelSwitchTableViewDelegate

extension SettingsViewController: LabelSwitchTableViewDelegate {

    func labelSwitchTableViewCell(_ cell: LabelSwitchTableViewCell, onSwitchValueChanged isOn: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            switch indexPath.row {
            case 1:
                UserDefaults.standard.setShouldHideTextMessages(value: isOn)
            case 2:
                UserDefaults.standard.setShouldHideAttributedTextMessages(value: isOn)
            case 3:
                UserDefaults.standard.setShouldHidePhotoMessages(value: isOn)
            case 4:
                UserDefaults.standard.setShouldHideVideoMessages(value: isOn)
            default: break
            }
            SampleData.shared.updateMessageTypes()
        }
    }
}