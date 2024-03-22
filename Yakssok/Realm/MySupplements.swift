//
//  MySupplements.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/17/24.
//

import Foundation
import RealmSwift

final class MySupplements: Object {
    @Persisted(primaryKey: true) var pk: ObjectId
    @Persisted var date: Date
    @Persisted var time: Date
    @Persisted var name: String
    @Persisted var amount: Int
    @Persisted var isChecked: Bool
    
    convenience init(date: Date, time: Date, name: String, amount: Int, isChecked: Bool) {
        self.init()
        self.date = date
        self.time = time
        self.name = name
        self.amount = amount
        self.isChecked = isChecked
    }
}


