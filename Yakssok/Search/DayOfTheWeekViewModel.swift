//
//  DayOfTheWeekViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation

class DayOfTheWeekViewModel {
    
    // input
    let inputDay: Observable<String?> = Observable(nil)
    
    // output
    let outputDayList: Observable<[String]> = Observable([])
    
    init() {
        inputDay.bind { value in
            guard let value = value else { return }
            if self.outputDayList.value.contains(where: { $0 == value}) {
                self.outputDayList.value.removeAll(where: { $0 == value })
            } else {
                self.outputDayList.value.append(value)
            }
        }
    }
}
