//
//  TimePickerViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import Foundation

final class TimePickerViewModel {
    let inputTime: Observable<Date?> = Observable(nil)
    
    let outputTime: Observable<Date?> = Observable(nil)
    
    init() {
        inputTime.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputTime.value = value
        }
    }
}
