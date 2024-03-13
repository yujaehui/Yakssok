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
    let outputMySupplement: Observable<[MySupplement]> = Observable([])
    
    init() {
        inputDidSelectTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            self.outputMySupplement.value = self.repository.fetchBySelectedDate(date: value)
        }
    }
}
