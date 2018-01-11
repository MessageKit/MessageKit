//
//  TableViewCells.swift
//  ChatExample
//
//  Created by Alessio Arsuffi on 11/01/2018.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    static let identifier = "TextFieldTableViewCellIdentifier"
    static let height: CGFloat = 40.0
    
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
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    
    
}
