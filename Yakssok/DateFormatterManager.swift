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
    
    func formatTimeToString(time: Date) -> String {
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        return formatter.string(from: time)
    }
    
    func formatDateToString(date: Date) -> String {
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
    
    
    func sortTimeStrings(_ timeStrings: [String]) -> [String] {
        formatter.dateFormat = "a hh:mm"
        
        let times = timeStrings.map { timeString -> Date in
            guard let time = formatter.date(from: timeString) else {
                fatalError("Invalid time string format: \(timeString)")
            }
            return time
        }
        
        let sortedTimes = times.sorted()
        
        let sortedTimeStrings = sortedTimes.map { time -> String in
            return formatter.string(from: time)
        }
        
        return sortedTimeStrings
    }
    
    func makeHeaderDateFormatter(date: Date) -> String {
        formatter.dateFormat = "YYYY년 MM월"
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter.string(from: date)
    }
}


//func sortTimeStrings(_ timeStrings: [Times]) -> [Times] {
//    formatter.dateFormat = "a hh:mm"
//    
//    let times = timeStrings.map { timeString -> Date in
//        guard let time = formatter.date(from: timeString.time) else {
//            fatalError("Invalid time string format: \(timeString)")
//        }
//        return time
//    }
//    
//    let sortedTimes = times.sorted()
//    
//    let sortedTimeStrings = sortedTimes.map { time -> Times in
//        let time = formatter.string(from: time)
//        return Times(time: time)
//    }
//    
//    return sortedTimeStrings
//}
