//
//  SupplementRepository.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/12/24.
//

import Foundation
import RealmSwift
import FSCalendar

final class SupplementRepository {
    //        print(realm.configuration.fileURL)
    private let realm = try! Realm()
    
    // MARK: - Create
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
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Fetch
    func fetchAllItem() -> [MySupplement] {
        let result = realm.objects(MySupplement.self)
        return Array(result)
    }
    
    func fetchAllItems() -> [MySupplements] {
        let result = realm.objects(MySupplements.self).where { $0.date >= FSCalendar().today! }
        return Array(result)
    }
    
    func fetchByName(name: String) -> [MySupplements] {
        let result = realm.objects(MySupplements.self).where { $0.name == name }
        return Array(result)
    }
    
    func fetchByDate(date: Date) -> [MySupplements] {
        let result = realm.objects(MySupplements.self).where { $0.date == date }
        return Array(result)
    }
    
    // MARK: - Update
    func updateIsCompleted(pk: ObjectId) {
        do {
            try realm.write {
                realm.objects(MySupplements.self).where{ $0.pk == pk }.first?.isChecked.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(data: MySupplement, period: Int, endDay: Date, cycleArray: [String], timeArray: [Date], name: String, amount: Int) {
        do {
            try realm.write {
                data.period = period
                data.endDay = endDay
                data.cycleArray = cycleArray
                data.timeArray = timeArray
                data.name = name
                data.amount = amount
            }
        } catch {
            print(error)
        }
    }
    
    func updateItems(data: [MySupplements], name: String, amount: Int) {
        do {
            try realm.write {
                for item in data {
                    item.name = name
                    item.amount = amount
                }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Delete
    func deleteItem(_ data: MySupplement) {
        do {
            try realm.write{
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItems(_ data: [MySupplements]) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteFutureItems(data: [MySupplements], date: Date) {
        do {
            try realm.write {
                realm.delete(data.filter {$0.date >= date})
            }
        } catch {
            print(error)
        }
    }
}
