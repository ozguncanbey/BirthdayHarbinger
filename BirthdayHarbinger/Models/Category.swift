//
//  Category.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import Foundation

enum Category: String, CaseIterable {
    case All
    case Family
    case Friend
    case Other
}

extension Category {
    static var selectableCategories: [Category] {
        return Category.allCases.filter { $0 != .All }
    }
}
