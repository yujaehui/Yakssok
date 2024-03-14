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
    
    let inputGroupData: Observable<[MySupplement]?> = Observable(nil)
    
    //output
    let outputMySupplement: Observable<[MySupplement]> = Observable([])
    
    let outputGroupedDate: Observable<[String]> = Observable([])
    let outputGroupedMySupplement: Observable<[[MySupplement]]> = Observable([[]])
    init() {
        inputDidSelectTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            self.outputMySupplement.value = self.repository.fetchBySelectedDate(date: value)
        }
        
        inputGroupData.bind { supplements in
            guard let supplements = supplements else { return }
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
            self.outputGroupedDate.value = DateFormatterManager.shared.convertDateArrayToStringArray(dates: groupedDataDict.sorted{ $0.key < $1.key}.map { $0.key })
            self.outputGroupedMySupplement.value = groupedDataDict.sorted{ $0.key < $1.key }.map { $0.value }
        }
    }
}
