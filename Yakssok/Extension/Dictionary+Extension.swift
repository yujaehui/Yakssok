//
//  Dictionary+Extension.swift
//  Yakssok
//
//  Created by Jaehui Yu on 7/20/24.
//

import Foundation

extension Dictionary where Key == Int, Value == [Date] {
    mutating func append(value: Date, forKey key: Int) {
        if var array = self[key] {
            array.append(value)
            self[key] = Array(Set(array))
        } else {
            self[key] = [value]
        }
    }
}
