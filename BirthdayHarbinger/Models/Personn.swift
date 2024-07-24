//
//  Personn.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 11.07.2024.
//

import SwiftUI
import SwiftData

@Model
final class Personn: Identifiable {
    var id = UUID()
    var imageData: Data?
    var name: String
    var birthday: Date
    var category: String
    var isPinned: Bool = false
    
    init(name: String, birthday: Date, category: String) {
        self.name = name
        self.birthday = birthday
        self.category = category
    }
}

extension Personn {
    
    /// calculates the age
    func calculateTurnsAge() -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year ?? 0
        
        return age + 1
    }
    
    /// calculates how many days between today and birthday
    func calculateLeftDays() -> String? {

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
        var components = calendar.dateComponents([.month, .day], from: birthday)
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

extension Personn {
    
    static var dummy: Personn {
        .init(name: "Özgün Can Beydili", birthday: Date(), category: "Family")
    }
    
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Personn.self)
        
        return container
    }
}

//actor PreviewSampleData {
//    @MainActor
//    static var container: ModelContainer = {
//        return try! inMemoryContainer()
//    }()
//
//    static var inMemoryContainer: () throws -> ModelContainer = {
//        let schema = Schema([Personn.self])
//        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: schema, configurations: [configuration])
//
//        let sampleData: [any PersistentModel] = [
//            Personn.dummy
//        ]
//
//        Task { @MainActor in
//            sampleData.forEach {
//                container.mainContext.insert($0)
//            }
//        }
//
//        return container
//    }
//}
//
//// Preview
//extension Personn {
//    static var preview: ModelContainer {
//        return try! PreviewSampleData.inMemoryContainer()
//    }
//}
//
