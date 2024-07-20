//
//  NotificationManager.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 17.07.2024.
//

import SwiftUI
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in }
    }
    
    func scheduleFirstAlertNotification(for person: Personn, reminder: Reminder, hour: Int, minute: Int) {
        let firstAlertIdentifier = "firstAlert-" + person.id.uuidString
        
        if reminder != .none {
            let content = UNMutableNotificationContent()
            content.title = "\(person.name)'s birthday is coming..."
            content.body = "Don't forget to prepare"
            content.sound = .default
            
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: person.birthday)
            
            var dayOffset = 0
            switch reminder {
            case .one:
                dayOffset = -1
            case .two:
                dayOffset = -2
            case .three:
                dayOffset = -3
            case .four:
                dayOffset = -4
            case .five:
                dayOffset = -5
            case .six:
                dayOffset = -6
            case .week:
                dayOffset = -7
            default:
                break
            }
            
            if let newDate = calendar.date(byAdding: .day, value: dayOffset, to: person.birthday) {
                dateComponents = calendar.dateComponents([.month, .day], from: newDate)
            }
            
            var triggerDateComponents = DateComponents()
            triggerDateComponents.month = dateComponents.month
            triggerDateComponents.day = dateComponents.day
            triggerDateComponents.hour = hour
            triggerDateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: person.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("fa Error adding notification: \(error)")
                }
            }
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [firstAlertIdentifier])
        }
    }
    
    func scheduleSecondAlertNotification(for person: Personn, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("today", comment: "") + "\(person.name)" + NSLocalizedString("notificationTitle", comment: "")
        content.body = NSLocalizedString("notificationMessage", comment: "")
        content.sound = .default
        content.badge = 1
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: person.birthday)
        
        var triggerDateComponents = DateComponents()
        triggerDateComponents.month = dateComponents.month
        triggerDateComponents.day = dateComponents.day
        triggerDateComponents.hour = hour
        triggerDateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: person.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("sa Error adding notification: \(error)")
            }
        }
    }
    
    func removeNotifications(for person: Personn) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [person.id.uuidString])
    }
    
    func updateFirstAlertNotifications(for people: [Personn], reminder: Reminder, hour: Int, minute: Int) {
        for person in people {
            scheduleFirstAlertNotification(for: person, reminder: reminder, hour: hour, minute: minute)
        }
    }
    
    func updateSecondAlertNotifications(for people: [Personn], hour: Int, minute: Int) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for person in people {
            scheduleSecondAlertNotification(for: person, hour: hour, minute: minute)
        }
    }
}
