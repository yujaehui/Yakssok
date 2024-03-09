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
    let inputTimeList: Observable<[String]> = Observable([])
    
    //output
    let outputSelectTime: Observable<String?> = Observable(nil)
    let outputTimeList: Observable<[String]> = Observable([])
    
    init() {
        inputSelectTime.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSelectTime.value = value
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
        }
    }
}
