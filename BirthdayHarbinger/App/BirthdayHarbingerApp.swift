//
//  BirthdayHarbingerApp.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import SwiftUI
import SwiftData

@main
struct BirthdayHarbingerApp: App {
    var body: some Scene {
        WindowGroup {
            ListScreen()
        }
        .modelContainer(for: _Person.self)
    }
}
