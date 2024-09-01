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

extension Dictionary where Key == Date, Value == [MySupplement] {
    mutating func append(value: MySupplement, forKey key: Date) {
        if var array = self[key] {
            array.append(value)
            self[key] = Array(Set(array)).sorted { $0.name < $1.name }
        } else {
            self[key] = [value]
        }
    }
}
