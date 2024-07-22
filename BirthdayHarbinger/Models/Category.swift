//
//  Category.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import Foundation

enum Category: String, CaseIterable {
    case All = "All"
    case Family = "Family"
    case Friend = "Friend"
    case Other = "Other"
    
    func localizedString(language: Language) -> String {
        NSLocalizedString(self.rawValue.localized(language), comment: "")
    }
}

extension Category {
    static var selectableCategories: [Category] {
        return Category.allCases.filter { $0 != .All }
    }
}
