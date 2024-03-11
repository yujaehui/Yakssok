//
//  TimeSettingViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation

class TimeSettingViewModel {
    
    //input
    let inputSelectTime: Observable<String?> = Observable(nil)
    let inputTimeList: Observable<[String]?> = Observable(nil)
    
    //output
    let outputSelectTimeList: Observable<[String]> = Observable([])
    let outputTimeList: Observable<[String]?> = Observable(nil)
    
    let addTimeButtonClicked: Observable<Void?> = Observable(nil)
    
    init() {
        inputSelectTime.bind { value in
            guard let value = value else { return }
            if self.outputSelectTimeList.value.contains(where: {$0 == value}) {
                return
            } else {
                self.outputSelectTimeList.value.append(value)
                self.outputSelectTimeList.value = DateFormatterManager.shared.sortTimeStrings(self.outputSelectTimeList.value)
            }
        }
        
        inputTimeList.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputTimeList.value = value
        }
    }
}
