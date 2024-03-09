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
    
    func formatTimeToString(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        return formatter.string(from: time)
    }
    
    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
}
