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
    
    func fetchItmes(name: String) -> [MySupplements] {
        let result = realm.objects(MySupplements.self).where { $0.name == name }
        return Array(result)
    }
    
    func fetchByDate(date: Date) -> [MySupplements] {
        let result = realm.objects(MySupplements.self).where { $0.date == date }
        return Array(result)
    }
    
    func updateIsCompleted(pk: ObjectId) {
        do {
            try realm.write {
                realm.objects(MySupplements.self).where{ $0.pk == pk }.first?.isChecked.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(pk: ObjectId, name: String, amount: Int) {
        do {
            try realm.write {
                if let supplement = realm.objects(MySupplement.self).where({ $0.pk == pk }).first {
                    supplement.name = name
                    supplement.amout = amount
                }
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
    
}
