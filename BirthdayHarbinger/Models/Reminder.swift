//
//  Reminder.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 19.07.2024.
//

import Foundation

enum Reminder: String, CaseIterable {
    case none = "None"
    case one = "1 day before"
    case two = "2 days before"
    case three = "3 days before"
    case four = "4 days before"
    case five = "5 days before"
    case six = "6 days before"
    case week = "1 week before"
    
    func localizedString(language: Language) -> String {
        self.rawValue.localized(language)
    }
}
