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
    
    func createItems(_ data: MySupplements) {
        //print(realm.configuration.fileURL)
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
        let result = realm.objects(MySupplement.self).filter { $0.startDay < date && $0.cycleArray.contains(where: { $0 == DateFormatterManager.shared.dayOfWeek(from: date) }) }
        return Array(result)
    }
    
    func updateItem(pk: ObjectId, name: String, amount: Int, startDay: Date, cycle: [String], time: [Date]) {
        do {
            try realm.write {
                if var supplement = realm.objects(MySupplement.self).where({ $0.pk == pk }).first {
                    supplement.name = name
                    supplement.amout = amount
                    supplement.startDay = startDay
                    supplement.cycleArray = cycle
                    supplement.timeArray = time
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ data: MySupplement) {
        do {
            try realm.write{
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
}
