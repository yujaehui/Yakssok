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
    let outputGroupedDataDict: Observable<[(Date, [MySupplements])]> = Observable([])
    
    init() {
        inputDidSelectTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            let supplements = self.repository.fetchByDate(date: value)
            var groupedDataDict: [Date : [MySupplements]] = [:]
            for supplement in supplements {
                if var supplementsForTime = groupedDataDict[supplement.time] {
                    supplementsForTime.append(supplement)
                    groupedDataDict[supplement.time] = supplementsForTime
                } else {
                    groupedDataDict[supplement.time] = [supplement]
                }
            }
            self.outputGroupedDataDict.value = groupedDataDict.sorted{$0.key < $1.key}
        }
    }
}
