// MIT License
//
// Copyright (c) 2017-2019 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import MessageKit
import UIKit

// MARK: - SettingsViewController

final internal class SettingsViewController: UITableViewController {
  // MARK: Lifecycle

  // MARK: - View lifecycle

  init() {
    super.init(style: .insetGrouped)
  }

  required init?(coder _: NSCoder) { nil }

  // MARK: Internal

  // MARK: - Properties

  let cells = [
    "Mock messages count",
    "Text Messages",
    "AttributedText Messages",
    "Photo Messages",
    "Photo from URL Messages",
    "Video Messages",
    "Audio Messages",
    "Emoji Messages",
    "Location Messages",
    "Url Messages",
    "Phone Messages",
    "ShareContact Messages",
  ]

  var messagesPicker = UIPickerView()

  // MARK: - Toolbar

  var messagesToolbar = UIToolbar()

  @objc
  func onDoneWithPickerView() {
    let selectedMessagesCount = messagesPicker.selectedRow(inComponent: 0)
    UserDefaults.standard.setMockMessages(count: selectedMessagesCount)
    view.endEditing(false)
    tableView.reloadData()
  }

  @objc
  func dismissPickerView() {
    view.endEditing(false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Settings"
    tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
    tableView.tableFooterView = UIView()
    configurePickerView()
    configureToolbar()
  }

  // MARK: - TableViewDelegate & TableViewDataSource

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    cells.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellValue = cells[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
    cell.textLabel?.text = cells[indexPath.row]

    switch cellValue {
    case "Mock messages count":
      return configureTextFieldTableViewCell(at: indexPath)
    default:
      let switchView = UISwitch(frame: .zero)
      switchView.isOn = UserDefaults.standard.bool(forKey: cellValue)
      switchView.tag = indexPath.row
      switchView.onTintColor = .primaryColor
      switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
      cell.accessoryView = switchView
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let cell = tableView.cellForRow(at: indexPath)

    cell?.contentView.subviews.forEach {
      if $0 is UITextField {
        $0.becomeFirstResponder()
      }
    }
  }

  @objc
  func switchChanged(_ sender: UISwitch!) {
    let cell = cells[sender.tag]

    UserDefaults.standard.set(sender.isOn, forKey: cell)
    UserDefaults.standard.synchronize()
  }

  // MARK: Private

  private func configurePickerView() {
    messagesPicker.dataSource = self
    messagesPicker.delegate = self
    messagesPicker.backgroundColor = .white

    messagesPicker.selectRow(UserDefaults.standard.mockMessagesCount(), inComponent: 0, animated: false)
  }

  private func configureToolbar() {
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDoneWithPickerView))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissPickerView))
    messagesToolbar.items = [cancelButton, spaceButton, doneButton]
    messagesToolbar.sizeToFit()
  }

  // MARK: - Helper

  private func configureTextFieldTableViewCell(at indexPath: IndexPath) -> TextFieldTableViewCell {
    if
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TextFieldTableViewCell.identifier,
        for: indexPath) as? TextFieldTableViewCell
    {
      cell.mainLabel.text = "Mock messages count:"

      let messagesCount = UserDefaults.standard.mockMessagesCount()
      cell.textField.text = "\(messagesCount)"

      cell.textField.inputView = messagesPicker
      cell.textField.inputAccessoryView = messagesToolbar

      return cell
    }
    return TextFieldTableViewCell()
  }
}

// MARK: UIPickerViewDelegate, UIPickerViewDataSource

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in _: UIPickerView) -> Int {
    1
  }

  func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
    100
  }

  func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
    "\(row)"
  }
}
