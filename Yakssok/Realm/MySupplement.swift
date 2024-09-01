//
//  MySupplement.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/12/24.
//

import Foundation
import RealmSwift

final class MySupplement: Object {
    @Persisted(primaryKey: true) var pk: ObjectId
    @Persisted var name: String
    @Persisted var amount: Int
    @Persisted var startDay: Date
    @Persisted var period: Int
    @Persisted var endDay: Date
    @Persisted var cycle: List<String>
    @Persisted var time: List<Date>
    var cycleArray: [String] {
        get {
            return cycle.map{$0}
        } set {
            cycle.removeAll()
            cycle.append(objectsIn: newValue)
        }
    }
    var timeArray: [Date] {
        get {
            return time.map{$0}
        }
        set {
            time.removeAll()
            time.append(objectsIn: newValue)
        }
    }
    
    convenience init(name: String, amount: Int, startDay: Date, period: Int, endDay: Date, cycleArray: [String], timeArray: [Date]) {
        self.init()
        self.name = name
        self.amount = amount
        self.startDay = startDay
        self.period = period
        self.endDay = endDay
        self.cycleArray = cycleArray
        self.timeArray = timeArray
    }
}

// MARK: 새롭게 추가 된 Realm 객체
final class CheckSupplement: Object {
    @Persisted(primaryKey: true) var pk: ObjectId
    @Persisted var date: Date
    @Persisted var time: Date
    @Persisted var fk: ObjectId
    
    convenience init(date: Date, time: Date, fk: ObjectId) {
        self.init()
        self.date = date
        self.time = time
        self.fk = fk
    }
}
