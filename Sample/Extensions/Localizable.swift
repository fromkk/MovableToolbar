//
//  Localizable.swift
//  Sample
//
//  Created by Kazuya Ueoka on 2020/07/21.
//  Copyright © 2020 fromkk. All rights reserved.
//

import Foundation

protocol Localizable: RawRepresentable {}

extension Localizable where RawValue == String {
    func localized(tableName: String = "Localizable", bundle: Bundle = Bundle(for: AppDelegate.self), value: String = "", comment: String = "") -> String {
        return NSLocalizedString(rawValue, tableName: tableName, bundle: bundle, value: value, comment: value)
    }
}
