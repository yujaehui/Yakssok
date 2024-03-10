//
//  AddViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation

class AddViewModel {
    
    // input
    let inputSupplement: Observable<Row?> = Observable(nil)
    let inputStartDay: Observable<Date> = Observable(Date())
    let inputCycle: Observable<String> = Observable("매일")
    let inputTimeList: Observable<[String]> = Observable(["오전 09:00"])
    
    // output
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    let outputStartDay: Observable<String> = Observable("")
    let outputCycle: Observable<String> = Observable("")
    let outputTimeList: Observable<[String]> = Observable([])
    
    init() {
        inputSupplement.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSupplement.value = value
        }
        
        inputStartDay.bind { [weak self] value in
            self?.outputStartDay.value = DateFormatterManager.shared.formatDateToString(date: value)
        }
        
        inputCycle.bind { [weak self] value in
            print(value)
            self?.outputCycle.value = value
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
        }
    }
}
