//
//  DayIntervalViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation

class DayIntervalViewModel {
    
    // input
    let inputDayInterval: Observable<String?> = Observable(nil)
    
    // output
    var outputDayIntervalList: Observable<[String]?> = Observable(nil)
    
    init() {
        inputDayInterval.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputDayIntervalList.value = [value]
        }
    }
}
