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
                .preferredColorScheme(.light)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
        .modelContainer(for: Personn.self)
    }
}
