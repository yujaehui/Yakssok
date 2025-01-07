//
//  TimeViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation

final class TimeViewModel {
    
    //input
    let inputSelectTime: Observable<Date?> = Observable(nil)
    let inputSelectTimeList: Observable<[Date]?> = Observable(nil)
    let inputTimeList: Observable<[Date]?> = Observable(nil)
    
    //output
    let outputSelectTimeList: Observable<[Date]> = Observable([])
    let outputSelectTimeStringList: Observable<[String]> = Observable([])
    let outputTimeList: Observable<[Date]?> = Observable(nil)
    
    // transition
    let addTimeButtonClicked: Observable<Void?> = Observable(nil)
    let didSelectRowAt: Observable<Int?> = Observable(nil)
    
    init() {
        inputSelectTime.bind { value in
            guard let value = value else { return }
            if self.outputSelectTimeList.value.contains(where: {$0 == DateFormatterManager.shared.extractTime(date: value)}) {
                return
            } else {
                self.outputSelectTimeList.value.append(DateFormatterManager.shared.extractTime(date: value))
                self.outputSelectTimeList.value.sort()
            }
        }
        
        inputSelectTimeList.bind { value in
            guard let value = value else { return }
            self.outputSelectTimeStringList.value = DateFormatterManager.shared.convertDateArrayToStringArray(dates: value)
        }
        
        inputTimeList.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputTimeList.value = value
        }
    }
}
