//
//  NumberFormatterManager.swift
//  Yakssok
//
//  Created by Jaehui Yu on 9/1/24.
//

import Foundation

final class NumberFormatterManager {
    static let shared = NumberFormatterManager()
    private init() {}
    
    // 숫자 포맷터 생성
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 천 단위 구분자를 지원하는 포맷
        formatter.groupingSeparator = "," // 천 단위 구분자 설정
        return formatter
    }()
    
    func formatNumber(_ number: Int) -> String {
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func stringToNumber(_ string: String) -> Int? {
        if let number = numberFormatter.number(from: string) {
            return number.intValue
        } else {
            return nil
        }
    }
}
