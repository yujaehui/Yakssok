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
    
//    func scheduleNotificationsFromSchedule(_ schedule: [(Date, [Date])]) {
//        let maxNotifications = 64 // 최대 예약 가능한 알림 수
//        var scheduledNotifications = 0 // 예약된 알림 수
//        
//        for (date, times) in schedule {
//            for time in times {
//                guard scheduledNotifications < maxNotifications else {
//                    print("Maximum notification limit reached.")
//                    return
//                }
//                
//                scheduleLocalNotification(date: date, time: timeComponents(from: time))
//                scheduledNotifications += 1
//            }
//        }
//    }
//    
//    func timeComponents(from date: Date) -> DateComponents {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute], from: date)
//        return components
//    }
//    
//    func scheduleLocalNotification(date: Date, time: DateComponents) {
//        
//        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
//        dateComponents.calendar?.locale = Locale(identifier: "ko_KR")
//        dateComponents.hour = time.hour
//        dateComponents.minute = time.minute
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        
//        let content = UNMutableNotificationContent()
//        content.title = "영양제 드시기로 약쏙한 시간입니다💜"
//        content.body = "영양제 챙겨 드시고, 약쏙에서 기록하세요!"
//        
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled successfully for \(dateComponents)")
//            }
//        }
//    }
    
    func registerLocalNotification(for supplement: MySupplement) {
        // UNUserNotificationCenter 인스턴스 생성
        let center = UNUserNotificationCenter.current()
        
        // 알림 컨텐츠 설정
        let content = UNMutableNotificationContent()
        content.title = "영양제 드시기로 약쏙한 시간입니다💜"
        content.body = "💊 \(supplement.name)챙겨 드시고, 약쏙에서 기록하세요!"
        content.sound = UNNotificationSound.default
        
        // 알림 발송 시간 설정
        let calendar = Calendar.current
        
        // 종료일까지만 알림 등록
        let endDate = supplement.endDay
        let currentDate = Date()
        if currentDate <= endDate {
            // 필터링된 요일을 기반으로 알림 등록
            for weekdayString in supplement.cycle {
                if let weekdayIndex = dayOfWeekToNumber(weekdayString) {
                    for time in supplement.time {
                        var dateComponents = calendar.dateComponents([.hour, .minute], from: time)
                        dateComponents.weekday = weekdayIndex
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        
                        // 알림 요청 생성
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        // 알림 등록
                        center.add(request) { (error) in
                            if let error = error {
                                print("Error adding notification: \(error.localizedDescription)")
                            } else {
                                print("Notification added successfully!")
                            }
                        }
                    }
                }
            }
        }
    }

    func dayOfWeekToNumber(_ dayOfWeek: String) -> Int? {
        let daysOfWeek: [String: Int] = [
            "일": 1,
            "월": 2,
            "화": 3,
            "수": 4,
            "목": 5,
            "금": 6,
            "토": 7
        ]
        
        return daysOfWeek[dayOfWeek]
    }
}
