//
//  PeriodViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/18/24.
//

import Foundation

class PeriodViewModel {
    
    // input
    let inputPeriod: Observable<Int?> = Observable(nil)
    
    // output
    let outputPeriod: Observable<Int?> = Observable(nil)
    
    init() {
        inputPeriod.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputPeriod.value = value
        }
    }
}
