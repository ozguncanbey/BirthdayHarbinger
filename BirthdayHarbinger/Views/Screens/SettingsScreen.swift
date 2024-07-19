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
    
    @State private var firstAlert: Reminder = .none
    @State private var selectedTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 0
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var showingPopover = false
    
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
                
                Section("Reminder") {
                    Picker("First Alert", selection: $firstAlert) {
                        ForEach(Reminder.allCases, id: \.self) { reminder in
                            Text(reminder.localizedString).tag(reminder)
                        }
                    }
                    
                    HStack {
                        DatePicker("Second Alert", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                            .environment(\.locale, Locale(identifier: "tr_POSIX"))
                        
                        Button(action: {
                            showingPopover.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .animation(.easeInOut, value: showingPopover)
        }
    }
}

#Preview {
    SettingsScreen()
}
