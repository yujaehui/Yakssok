//
//  CycleViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation
import Foundation

final class CycleViewModel {
    
    // input
    let inputSelectDayOfTheWeek: Observable<String?> = Observable(nil)
    let inputDayOfTheWeekList: Observable<[String]?> = Observable(nil)
    
    // output
    let outputIsSelected: Observable<Bool> = Observable(false)
    var outputSelectDayOfTheWeekList: Observable<[String]> = Observable([])
    let outputDayOfTheWeekList: Observable<[String]?> = Observable(nil)
    
    
    init() {
        inputSelectDayOfTheWeek.bind { value in
            guard let value = value else { return }
            if self.outputSelectDayOfTheWeekList.value.contains(where: {$0 == value}) {
                self.outputSelectDayOfTheWeekList.value.removeAll(where: {$0 == value})
            } else {
                self.outputSelectDayOfTheWeekList.value.append(value)
                self.outputSelectDayOfTheWeekList.value.sort { (day1, day2) -> Bool in
                    guard let index1 = DayOfTheWeek.allCases.firstIndex(of: DayOfTheWeek(rawValue: day1) ?? .sunday),
                          let index2 = DayOfTheWeek.allCases.firstIndex(of: DayOfTheWeek(rawValue: day2) ?? .sunday) else {
                        return false
                    }
                    return index1 < index2
                }
            }
            
            if self.outputSelectDayOfTheWeekList.value == [] {
                self.outputIsSelected.value = false
            } else {
                self.outputIsSelected.value = true

            }
        }
        
        inputDayOfTheWeekList.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputDayOfTheWeekList.value = value
        }
    }
}
