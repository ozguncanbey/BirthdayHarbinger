//
//  SettingsScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 18.07.2024.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Theme") {
                    Toggle(isOn: $isDarkMode, label: {
                        Text("Dark Mode")
                    })
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    SettingsScreen()
}
