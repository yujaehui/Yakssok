//
//  CalendarViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/13/24.
//

import Foundation
import FSCalendar

final class CalendarViewModel {
    let repository = SupplementRepository()
    
    //input
    let inputDidSelectDate: Observable<Date> = Observable(FSCalendar().today!)
    let inputDidCheckTime: Observable<MySupplements?> = Observable(nil)
    
    //output
    let outputGroupedDataDict: Observable<[(Date, [MySupplements])]> = Observable([])
    let outputShowAlert: Observable<(Bool, MySupplements)?> = Observable(nil)
    
    init() {
        inputDidSelectDate.bind { [weak self] value in
            guard let self = self else { return }
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
        
        inputDidCheckTime.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            if value.date > FSCalendar().today! && value.isChecked == false {
                outputShowAlert.value = (true, value)
            } else {
                outputShowAlert.value = (false, value)
            }
        }
    }
}
