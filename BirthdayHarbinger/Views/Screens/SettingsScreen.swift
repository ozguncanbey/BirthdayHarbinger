//
//  SettingsScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 18.07.2024.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @AppStorage("reminder") private var reminder: Reminder = .none
    @AppStorage("firstAlertHour") private var faHour: Int = 0
    @AppStorage("firstAlertMinute") private var faMinute: Int = 0
    
    @AppStorage("secondAlertHour") private var saHour: Int = 0
    @AppStorage("secondAlertMinute") private var saMinute: Int = 0
    
    @State private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    var people: [Personn]
    private let notificationManager = NotificationManager.shared
    
    //    @State private var firstAlert: Reminder = .none
    
    @State private var faSelectedTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 0
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    @State private var saSelectedTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 0
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    @State private var showingToast = false
    
    init(people: [Personn]) {
        self.people = people
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        var dateComponents = DateComponents()
        dateComponents.year = components.year
        dateComponents.month = components.month
        dateComponents.day = components.day
        dateComponents.hour = saHour
        dateComponents.minute = saMinute
        
        _saSelectedTime = State(initialValue: calendar.date(from: dateComponents) ?? now)
        
        dateComponents.hour = faHour
        dateComponents.minute = faMinute
        
        _faSelectedTime = State(initialValue: calendar.date(from: dateComponents) ?? now)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                        HStack {
                            Text(NSLocalizedString("firstAlert", comment: ""))
                            
                            Spacer()
                            
                            Picker("", selection: $reminder) {
                                ForEach(Reminder.allCases, id: \.self) { reminder in
                                    Text(reminder.localizedString).tag(reminder)
                                }
                            }
                            .onChange(of: reminder) {
                                notificationManager.updateFirstAlertNotifications(for: people, reminder: reminder, hour: faHour, minute: faMinute)
                            }
                            
                            if reminder.rawValue != "None" {
                                DatePicker("", selection: $faSelectedTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .environment(\.locale, Locale(identifier: "tr_POSIX"))
                                    .onChange(of: faSelectedTime) {
                                        let calendar = Calendar.current
                                        faHour = calendar.component(.hour, from: faSelectedTime)
                                        faMinute = calendar.component(.minute, from: faSelectedTime)
                                        notificationManager.updateFirstAlertNotifications(for: people, reminder: reminder, hour: faHour, minute: faMinute)
                                    }
                            }
                        }
                        
                        HStack {
                            DatePicker(NSLocalizedString("secondAlert", comment: ""), selection: $saSelectedTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .environment(\.locale, Locale(identifier: "tr_POSIX"))
                                .onChange(of: saSelectedTime) {
                                    let calendar = Calendar.current
                                    saHour = calendar.component(.hour, from: saSelectedTime)
                                    saMinute = calendar.component(.minute, from: saSelectedTime)
                                    notificationManager.updateSecondAlertNotifications(for: people, hour: saHour, minute: saMinute)
                                }
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    showingToast.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    showingToast = false
                                }
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
                .preferredColorScheme(isDarkMode ? .dark : .light)
            }
            
            Spacer()
            if showingToast {
                Text("toastMessage")
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(isDarkMode ? Color.gray.opacity(0.2) : Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    SettingsScreen(people: [])
}
