//
//  CycleSettingViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation

class CycleSettingViewModel {
    
    // input
    let inputDayOfTheWeekVC: Observable<[String]?> = Observable(nil)
    let inputDailyIntervalVC: Observable<[Int]?> = Observable(nil)
    
    // output
    let outputDayOfTheWeekVC: Observable<String?> = Observable(nil)
    let outputDailyIntervalVC: Observable<String?> = Observable(nil)

    
    init() {
        inputDayOfTheWeekVC.bind { [weak self] value in
            guard var sortedValue = value else { return }
            sortedValue.sort { (day1, day2) -> Bool in
                guard let index1 = DayOfTheWeek.allCases.firstIndex(of: DayOfTheWeek(rawValue: day1) ?? .sunday),
                      let index2 = DayOfTheWeek.allCases.firstIndex(of: DayOfTheWeek(rawValue: day2) ?? .sunday) else {
                    return false
                }
                return index1 < index2
            }
            if sortedValue.count == DayOfTheWeek.allCases.count {
                self?.outputDayOfTheWeekVC.value = "매일"
            } else {
                self?.outputDayOfTheWeekVC.value = sortedValue.joined(separator: ", ")
            }
        }
        
        inputDailyIntervalVC.bind { value in
            guard let value = value else { return }
            let interval = PickerType.interval.intervals[value[0]]
            let number = PickerType.number.numbers[value[0]][value[1]]
            self.outputDailyIntervalVC.value = number + interval
        }
    }
}
