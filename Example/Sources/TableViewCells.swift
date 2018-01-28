/*
 MIT License
 
 Copyright (c) 2017 MessageKit
 
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

protocol UITableViewCellIdentifier {
    static var identifier: String { get }
}

// MARK: - TextFieldTableViewCell

class TextFieldTableViewCell: UITableViewCell, UITableViewCellIdentifier {

    // MARK: - Properties

    static var identifier = "TextFieldTableViewCellIdentifier"
    
    var mainLabel = UILabel()
    var textField = UITextField()
    
    // MARK: - View lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainLabel)
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainLabel.widthAnchor.constraint(equalToConstant: 200),
            mainLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textField.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        textField.textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LabelSwitchTableViewCell

protocol LabelSwitchTableViewDelegate: class {
    func labelSwitchTableViewCell(_ cell: LabelSwitchTableViewCell, onSwitchValueChanged isOn: Bool)
}

class LabelSwitchTableViewCell: UITableViewCell, UITableViewCellIdentifier {

    // MARK: - Properties

    static let identifier = "LabelSwitchTableViewCellIdentifier"

    weak var delegate: LabelSwitchTableViewDelegate?

    var mainLabel = UILabel()
    var cellSwitch = UISwitch()

    // MARK: - View lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        cellSwitch.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainLabel)
        contentView.addSubview(cellSwitch)

        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainLabel.widthAnchor.constraint(equalToConstant: 200),
            mainLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            cellSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            cellSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellSwitch.widthAnchor.constraint(equalToConstant: 50)
        ])

        cellSwitch.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func onSwitchValueChanged() {
        let isOn = cellSwitch.isOn
        delegate?.labelSwitchTableViewCell(self, onSwitchValueChanged: isOn)
    }
}