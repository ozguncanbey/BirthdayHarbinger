//
//  Person.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import Foundation
import SwiftData

@Model
final class Person: Identifiable {
    var id = UUID()
    var name: String
    var birthday: String
    var category: String
    
    init(name: String, birthday: String, category: String) {
        self.name = name
        self.birthday = birthday
        self.category = category
    }
}

extension Person {
    
    /// converts string to date
    func dateOfBirth() -> Date? {
        return DateFormatter.custom.date(from: birthday)
    }
    
    /// calculates the age
    func calculateTurnsAge() -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth()!, to: now)
        let age = ageComponents.year ?? 0
        
        return age + 1
    }
    
    /// calculates how many days between today and birthday
    func calculateLeftDays() -> String? {
        guard let dateOfBirth = dateOfBirth() else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Zero out the time components of the current date
        var nowComponents = calendar.dateComponents([.year, .month, .day], from: now)
        nowComponents.hour = 0
        nowComponents.minute = 0
        nowComponents.second = 0
        
        guard let today = calendar.date(from: nowComponents) else {
            return nil
        }
        
        // Get components for the dateOfBirth and reset the time components
        var components = calendar.dateComponents([.month, .day], from: dateOfBirth)
        components.year = calendar.component(.year, from: today)
        
        // Calculate the birthday this year
        guard let birthdayThisYear = calendar.date(from: components) else {
            return nil
        }
        
        if today > birthdayThisYear {
            components.year! += 1
        } else if today == birthdayThisYear {
            return "0"
        }
        
        guard let nextBirthday = calendar.date(from: components) else {
            return nil
        }
        
        let daysLeft = calendar.dateComponents([.day], from: today, to: nextBirthday).day
        
        return daysLeft != nil ? String(daysLeft!) : nil
    }
}

extension Person {
    
    static var dummy: Person {
        .init(name: "Özgün Can Beydili", birthday: "02/10/2002", category: "Family")
    }
    
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Person.self)
        
        return container
    }
}
