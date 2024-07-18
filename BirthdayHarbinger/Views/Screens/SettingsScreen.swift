//
//  SettingsScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 18.07.2024.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Theme") {
                    Toggle(isOn: $isDarkMode, label: {
                        Text("Dark Mode")
                    })
                }
                
                Section("Language") {
                    HStack {
                        Text("Language")
                        Spacer()
                        Picker("Language", selection: $selectedLanguage) {
                            Text("en").tag("en")
                            Text("tr").tag("tr")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: .dWidth / 4, alignment: .trailing)
                        .onChange(of: selectedLanguage) {
                            if selectedLanguage == "tr" {
                                LocaleManager.shared.setLanguage(.turkish)
                            } else {
                                LocaleManager.shared.setLanguage(.english)
                            }
                        }
                    }
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
