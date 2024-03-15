//
//  SupplementRepository.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/12/24.
//

import Foundation
import RealmSwift

class SupplementRepository {
    let realm = try! Realm()
    
    func createItem(_ data: MySupplement) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchItem() -> [MySupplement] {
        let result = realm.objects(MySupplement.self)
        return Array(result)
    }
    
    func fetchBySelectedDate(date: Date) -> [MySupplement] {
        print(realm.configuration.fileURL)

        let result = realm.objects(MySupplement.self).filter { $0.startDay < date && $0.cycleArray.contains(where: { $0 == DateFormatterManager.shared.dayOfWeek(from: date) }) }
        return Array(result)
    }
}
