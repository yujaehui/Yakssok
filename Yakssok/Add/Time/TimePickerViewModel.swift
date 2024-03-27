//
//  TimePickerViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import Foundation

enum TimeAccessType: String {
    case add = "추가"
    case modify = "수정"
}

final class TimePickerViewModel {
    let inputType: Observable<TimeAccessType?> = Observable(nil)
    let inputAddTime: Observable<Date?> = Observable(nil)
    
    let outputType: Observable<TimeAccessType> = Observable(.add)
    let outputAddTime: Observable<Date?> = Observable(nil)
    
    init() {
        inputType.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            self.outputType.value = value
        }
        
        inputAddTime.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputAddTime.value = value
        }
    }
}
