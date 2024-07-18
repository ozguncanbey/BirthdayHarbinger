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
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ListScreen()
                .environment(\.locale, LocaleManager.shared.currentLanguage.locale)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
        .modelContainer(for: Personn.self)
    }
}
