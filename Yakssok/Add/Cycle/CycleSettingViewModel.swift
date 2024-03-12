//
//  CycleSettingViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/12/24.
//

import Foundation

class CycleSettingViewModel {
    
    let inputIndex: Observable<Int> = Observable(0)
    
    let outputIndex: Observable<Int> = Observable(0)
    
    init() {
        inputIndex.bind { value in
            self.outputIndex.value = value
        }
    }
}
