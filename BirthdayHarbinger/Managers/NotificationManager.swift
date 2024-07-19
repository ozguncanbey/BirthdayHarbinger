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
    
    func scheduleNotification(for person: Personn, hour: Int, minute: Int) {
        
        let content = notificationMessage(for: person)
        
        let triggerDateComponents = notificationTime(for: person, hour: hour, minute: minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: person.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotifications(for person: Personn) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [person.id.uuidString])
    }
    
    func updateNotifications(for people: [Personn], hour: Int, minute: Int) {
        
        removeAllNotifications()
        
        for person in people {
            scheduleNotification(for: person, hour: hour, minute: minute)
        }
    }
    
    private func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    private func notificationMessage(for person: Personn) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("today", comment: "") + "\(person.name)" + NSLocalizedString("notificationTitle", comment: "")
        content.body = NSLocalizedString("notificationMessage", comment: "")
        content.sound = .default
        content.badge = 1
        
        return content
    }
    
    private func notificationTime(for person: Personn, hour: Int, minute: Int) -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: person.birthday)
        
        var triggerDateComponents = DateComponents()
        triggerDateComponents.month = dateComponents.month
        triggerDateComponents.day = dateComponents.day
        triggerDateComponents.hour = hour
        triggerDateComponents.minute = minute
        
        return triggerDateComponents
    }
}
