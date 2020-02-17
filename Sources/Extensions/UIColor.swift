//
//  UIColor.swift
//  MessageKit
//
//  Created by Vlada Radchenko on 9/30/19.
//  Copyright © 2019 MessageKit. All rights reserved.
//

import Foundation

extension UIColor {

    static var backgroundColor: UIColor {
        if #available(iOS 13, *) {
            return systemBackground
        } else {
            return white
        }
    }

    static var labelColor: UIColor {
        if #available(iOS 13, *) {
            return label
        } else {
            return black
        }
    }

    static var placeholderTextColor: UIColor {
        if #available(iOS 13, *) {
            return placeholderText
        } else {
            return .darkGray
        }
    }

    static var grayColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        } else {
            return gray
        }
    }

    static var darkTextColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray
        } else {
            return darkText
        }
    }

    static var lightGrayColor: UIColor {
        if #available(iOS 13, *) {
            return .systemGray5
        } else {
            return .lightGray
        }
    }
}
