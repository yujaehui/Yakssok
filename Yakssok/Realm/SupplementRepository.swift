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
    
    func createCheckItem(_ data: CheckSupplement) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Fetch
    func fetchItem() -> [MySupplement] {
        let results = realm.objects(MySupplement.self)
        return Array(results)
    }
    
    func fetchItemBySelectedDate(selectedDate: Date) -> [MySupplement] {
        let results = realm.objects(MySupplement.self).filter { supplement in
            supplement.startDay <= selectedDate && supplement.cycleArray.contains(DateFormatterManager.shared.dayOfWeek(from: selectedDate))
        }
        return Array(results)
    }

    func fetchItemByPk(pk: ObjectId) -> MySupplement? {
        let result = realm.objects(MySupplement.self).first { supplement in
            supplement.pk == pk
        }
        return result
    }
    
    func fetchCheckItemBySelectedDate(selectedDate: Date) -> [CheckSupplement] {
        let result = realm.objects(CheckSupplement.self).filter { checkSupplement in
            checkSupplement.date == selectedDate
        }
        return Array(result)
    }
    
    // 수정 전 코드
//    func fetchAllItem() -> [MySupplement] {
//        let result = realm.objects(MySupplement.self)
//        return Array(result)
//    }
//    
//    func fetchAllItems() -> [MySupplements] {
//        let result = realm.objects(MySupplements.self).where { $0.date >= FSCalendar().today! }
//        return Array(result)
//    }
//    
//    func fetchByName(name: String) -> [MySupplements] {
//        let result = realm.objects(MySupplements.self).where { $0.name == name }
//        return Array(result)
//    }
//    
//    func fetchByDate(date: Date) -> [MySupplements] {
//        let result = realm.objects(MySupplements.self).where { $0.date == date }
//        return Array(result)
//    }
    
    // MARK: - Update
    func updateItem(data: MySupplement, name: String, amount: Int, stock: String, cycleArray: [String], timeArray: [Date]) {
        do {
            try realm.write {
                data.name = name
                data.amount = amount
                data.stock = stock
                data.cycleArray = cycleArray
                data.timeArray = timeArray
                
                let checkSupplements = realm.objects(CheckSupplement.self).filter("fk == %@", data.pk)
                
                for checkSupplement in checkSupplements {
                    if !cycleArray.contains(DateFormatterManager.shared.dayOfWeek(from: checkSupplement.date)) ||
                        !timeArray.contains(where: { Calendar.current.isDate($0, equalTo: checkSupplement.date, toGranularity: .minute) }) {
                        realm.delete(checkSupplement)
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    func updateStock(data: MySupplement?, checkStatus: CheckStatus) {
        do {
            try realm.write {
                if let data = data, let stock = NumberFormatterManager.shared.stringToNumber(data.stock), stock > 0 {
                    var newStock: Int
                    
                    switch checkStatus {
                    case .checked:
                        newStock = stock + data.amount
                    case .uncheckedAndNotDue, .unchecked:
                        newStock = stock - data.amount
                        if newStock <= 5 {
                            NotificationManager.shared.sendLowStockNotification(for: data)
                        }
                    }

                    data.stock = NumberFormatterManager.shared.formatNumber(newStock)
                }
            }
        } catch {
            print(error)
        }
    }


    
    // 수정 전 코드
//    func updateIsCompleted(pk: ObjectId) {
//        do {
//            try realm.write {
//                realm.objects(MySupplements.self).where{ $0.pk == pk }.first?.isChecked.toggle()
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func updateItem(data: MySupplement, period: Int, endDay: Date, cycleArray: [String], timeArray: [Date], name: String, amount: Int) {
//        do {
//            try realm.write {
//                data.period = period
//                data.endDay = endDay
//                data.cycleArray = cycleArray
//                data.timeArray = timeArray
//                data.name = name
//                data.amount = amount
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func updateItems(data: [MySupplements], name: String, amount: Int) {
//        do {
//            try realm.write {
//                for item in data {
//                    item.name = name
//                    item.amount = amount
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }

    // MARK: - Delete
    func deleteItem(_ data: MySupplement) {
        do {
            try realm.write {
                let supplementsToDelete = realm.objects(MySupplement.self)
                let pksToDelete = Array(supplementsToDelete.map { $0.pk })
                let checkSupplementsToDelete = realm.objects(CheckSupplement.self).filter("fk IN %@", pksToDelete)
                realm.delete(checkSupplementsToDelete)
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }

    func deleteCheckItem(_ data: CheckSupplement) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
    
    // 수정 전 코드
//    func deleteItem(_ data: MySupplement) {
//        do {
//            try realm.write{
//                realm.delete(data)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func deleteItems(_ data: [MySupplements]) {
//        do {
//            try realm.write {
//                realm.delete(data)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func deleteFutureItems(data: [MySupplements], date: Date) {
//        do {
//            try realm.write {
//                realm.delete(data.filter {$0.date >= date})
//            }
//        } catch {
//            print(error)
//        }
//    }
}
