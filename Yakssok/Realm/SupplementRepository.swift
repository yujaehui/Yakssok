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
        print(realm.configuration.fileURL)
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
}
