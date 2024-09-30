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
    
    func scheduleLocalNotifications(for schedule: [(Int, [Date])]) {
        let center = UNUserNotificationCenter.current()
        
        for (weekday, times) in schedule {
            for time in times {
                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                dateComponents.weekday = weekday
                
                let content = UNMutableNotificationContent()
                content.title = "영양제 드시기로 약쏙한 시간입니다💜"
                content.body = "영양제 챙겨 드시고, 약쏙에서 기록하세요!"
                content.sound = UNNotificationSound.default
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("알림 등록 실패: \(error)")
                    } else {
                        print("알림 등록 성공")
                    }
                }
            }
        }
    }
    
    func sendLowStockNotification(for supplement: MySupplement, stockCount: Int) {
        let content = UNMutableNotificationContent()
        content.title = "\(stockCount)개 밖에 남지 않은 \(supplement.name)😭"
        content.body = "잊기 전에 미리 챙겨 두고\n약쏙에도 기록해두는 것이 어떨까요?"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
}
