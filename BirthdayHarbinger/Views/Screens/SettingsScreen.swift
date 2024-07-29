//
//  SettingsScreen.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 18.07.2024.
//

import SwiftUI
import WidgetKit

struct SettingsScreen: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @AppStorage("reminder") private var reminder: Reminder = .none
    @AppStorage("firstAlertHour") private var faHour: Int = 0
    @AppStorage("firstAlertMinute") private var faMinute: Int = 0
    
    @AppStorage("secondAlertHour") private var saHour: Int = 0
    @AppStorage("secondAlertMinute") private var saMinute: Int = 0
    
    @AppStorage("appLanguage") private var appLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    @AppStorage("language") private var language = LocaleManager.shared.language
    
    var people: [Personn]
    private let notificationManager = NotificationManager.shared
    
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
                    Section("Theme".localized(language)) {
                        Toggle(isOn: $isDarkMode, label: {
                            Text("Dark Mode".localized(language))
                        })
                    }
                    
                    Section("Language".localized(language)) {
                        HStack {
                            Text("Language".localized(language))
                            Spacer()
                            Picker("Language", selection: $appLanguage) {
                                Text("en").tag("en")
                                Text("tr").tag("tr")
                            }
                            .pickerStyle(.segmented)
                            .frame(width: .dWidth / 4, alignment: .trailing)
                            .onChange(of: appLanguage) {
                                if appLanguage == "tr" {
                                    LocaleManager.shared.language = .turkish
                                } else {
                                    LocaleManager.shared.language = .english
                                }
                                language = LocaleManager.shared.language
                                notificationManager.updateFirstAlertNotifications(for: people, reminder: reminder, hour: faHour, minute: faMinute)
                                notificationManager.updateSecondAlertNotifications(for: people, hour: saHour, minute: saMinute)
                                WidgetCenter.shared.reloadTimelines(ofKind: "BirthdayWidget")
                            }
                        }
                    }
                    
                    Section("Reminder".localized(language)) {
                        HStack {
                            Text(NSLocalizedString("firstAlert".localized(language), comment: ""))
                            
                            Spacer()
                            
                            Picker("", selection: $reminder) {
                                ForEach(Reminder.allCases, id: \.self) { reminder in
                                    Text(reminder.localizedString(language: language)).tag(reminder)
                                }
                            }
                            .onChange(of: reminder) {
                                notificationManager.updateFirstAlertNotifications(for: people, reminder: reminder, hour: faHour, minute: faMinute)
                            }
                            
                            if reminder.rawValue != "None", reminder.rawValue != "Hiçbiri" {
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
                            DatePicker(NSLocalizedString("secondAlert".localized(language), comment: ""), selection: $saSelectedTime, displayedComponents: .hourAndMinute)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showingToast = false
                                }
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .navigationTitle("Settings".localized(language))
                .preferredColorScheme(isDarkMode ? .dark : .light)
            }
            
            Spacer()
            if showingToast {
                Label("toastMessage".localized(language), systemImage: "info.circle")
                    .font(.subheadline)
                    .foregroundColor(.blue.opacity(0.9))
                    .padding(10)
                    .background(Color.blue.opacity(0.1))
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
