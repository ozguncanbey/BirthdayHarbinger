//
//  Date+Ext.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 22.07.2024.
//

import Foundation

extension Date {
    func formatted(using language: Language) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: language.rawValue)
        return dateFormatter.string(from: self)
    }
}
