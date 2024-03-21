//
//  DateFormatterManager.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    
    let formatter = DateFormatter()
    
    func generateNineAM() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }
    
    func convertformatDateToString(date: Date) -> String {
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
    
    func convertformatDateToString2(date: Date) -> String {
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
    
    func extractTime(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return calendar.date(from: components)!
    }
    
    func convertDateArrayToStringArray(dates: [Date]) -> [String] {
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        var stringArray = [String]()
        
        for date in dates {
            let dateString = formatter.string(from: date)
            stringArray.append(dateString)
        }
        
        return stringArray
    }
    
    func makeHeaderDateFormatter(date: Date) -> String {
        formatter.dateFormat = "YYYY년 MM월"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
    }
    
    func makeHeaderDateFormatter2(date: Date) -> String {
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
    }
    
    func dayOfWeek(from date: Date) -> String {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        let dayOfWeekString = formatter.string(from: date)
        return dayOfWeekString
    }
    
    func dayOfWeekToNumber(_ dayOfWeek: String) -> Int {
        let daysOfWeek: [String: Int] = [
            "일": 1,
            "월": 2,
            "화": 3,
            "수": 4,
            "목": 5,
            "금": 6,
            "토": 7
        ]
        
        return daysOfWeek[dayOfWeek] ?? 0
    }
}
