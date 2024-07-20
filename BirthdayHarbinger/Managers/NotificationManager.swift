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
            content.title = "\(person.name)" + NSLocalizedString("faNotTitle", comment: "")
            content.body = NSLocalizedString("faNotMessage", comment: "")
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
            let request = UNNotificationRequest(identifier: firstAlertIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [firstAlertIdentifier])
        }
    }
    
    func scheduleSecondAlertNotification(for person: Personn, hour: Int, minute: Int) {
        let secondAlertIdentifier = "secondAlert-" + person.id.uuidString
        
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
        let request = UNNotificationRequest(identifier: secondAlertIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotifications(for person: Personn) {
        let firstAlertIdentifier = "firstAlert-" + person.id.uuidString
        let secondAlertIdentifier = "secondAlert-" + person.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [firstAlertIdentifier, secondAlertIdentifier])
    }
    
    func updateFirstAlertNotifications(for people: [Personn], reminder: Reminder, hour: Int, minute: Int) {
        for person in people {
            scheduleFirstAlertNotification(for: person, reminder: reminder, hour: hour, minute: minute)
        }
    }
    
    func updateSecondAlertNotifications(for people: [Personn], hour: Int, minute: Int) {
        for person in people {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["secondAlert-" + person.id.uuidString])
            scheduleSecondAlertNotification(for: person, hour: hour, minute: minute)
        }
    }
}
