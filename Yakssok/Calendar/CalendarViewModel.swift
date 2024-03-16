//
//  CalendarViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/13/24.
//

import Foundation

class CalendarViewModel {
    let repository = SupplementRepository()
    
    //input
    let inputDidSelectTrigger: Observable<Date?> = Observable(nil)
    
    //output
    let outputGroupedDataDict: Observable<[(Date, [MySupplement])]> = Observable([])
    
    init() {
        inputDidSelectTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            let supplements = self.repository.fetchBySelectedDate(date: value)
            var groupedDataDict: [Date: [MySupplement]] = [:]
            for supplement in supplements {
                for time in supplement.timeArray {
                    if var supplementsForTime = groupedDataDict[time] {
                        supplementsForTime.append(supplement)
                        groupedDataDict[time] = supplementsForTime
                    } else {
                        groupedDataDict[time] = [supplement]
                    }
                }
            }
            self.outputGroupedDataDict.value = groupedDataDict.sorted{ $0.key < $1.key}
            
        }
    }
}
