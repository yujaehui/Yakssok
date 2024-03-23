//
//  StartDayViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation

final class StartDayViewModel {
    
    // input
    let inputDate: Observable<Date?> = Observable(nil)
    
    // output
    let outputDate: Observable<Date?> = Observable(nil)
    
    init() {
        inputDate.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputDate.value = value
        }
    }
}
