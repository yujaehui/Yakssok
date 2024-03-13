//
//  MySupplement.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/12/24.
//

import Foundation
import RealmSwift

class MySupplement: Object {
    @Persisted(primaryKey: true) var pk: ObjectId
    @Persisted var name: String
    @Persisted var amout: Int
    @Persisted var startDay: Date
    @Persisted var cycle: String
    @Persisted var time: List<Date>
    var timeArray: [Date] {
        get {
            return time.map{$0}
        }
        set {
            time.removeAll()
            time.append(objectsIn: newValue)
        }
    }
    
    convenience init(name: String, amout: Int, startDay: Date, cycle: String, timeArray: [Date]) {
        self.init()
        self.name = name
        self.amout = amout
        self.startDay = startDay
        self.cycle = cycle
        self.timeArray = timeArray
    }
}
