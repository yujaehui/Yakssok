//
//  NotificationManager.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/27/24.
//

import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func scheduleNotificationsFromSchedule(_ schedule: [(Date, [Date])]) {
        for (date, times) in schedule {
            for time in times {
                scheduleLocalNotification(date: date, time: timeComponents(from: time))
            }
        }
    }
    
    func timeComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return components
    }
    
    func scheduleLocalNotification(date: Date, time: DateComponents) {
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponents.calendar?.locale = Locale(identifier: "ko_KR")
        dateComponents.hour = time.hour
        dateComponents.minute = time.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "영양제 드시기로 약쏙한 시간입니다💜"
        content.body = "영양제 챙겨 드시고, 약쏙에서 기록하세요!"
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(dateComponents)")
            }
        }
    }
}
