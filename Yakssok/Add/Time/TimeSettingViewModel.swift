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
        inputSelectTime.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSelectTimeList.value.append(value)
            self?.outputSelectTimeList.value.sort()
        }
        
        inputTimeList.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputTimeList.value = value
        }
    }
}
