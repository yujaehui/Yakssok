//
//  AddViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation
import RealmSwift

class AddViewModel {
    let repository = SupplementRepository()
    
    // input
    let inputSupplement: Observable<Row?> = Observable(nil)
    let inputMinusAmount: Observable<Int> = Observable(1)
    let inputPlusAmount: Observable<Int> = Observable(1)
    let inputStartDay: Observable<Date> = Observable(Date())
    let inputCycle: Observable<[String]> = Observable(["1"])
    let inputTimeList: Observable<[String]> = Observable(["오전 09:00"])
    
    // output
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    let outputAmount: Observable<Int> = Observable(0)
    let outputStartDay: Observable<String> = Observable("")
    let outputCycle: Observable<String> = Observable("")
    let outputCycleString: Observable<String> = Observable("")
    let outputTimeList: Observable<[String]> = Observable([])
    
    init() {
        inputSupplement.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSupplement.value = value
        }
        
        inputMinusAmount.bind { [weak self] value in
            guard let self = self else { return }
            if self.outputAmount.value <= 1 {
                return
            } else {
                self.outputAmount.value -= 1
            }
        }
        
        inputPlusAmount.bind { [weak self] value in
            guard let self = self else { return }
            self.outputAmount.value += 1
        }
        
        inputStartDay.bind { [weak self] value in
            self?.outputStartDay.value = DateFormatterManager.shared.formatDateToString(date: value)
        }
        
        inputCycle.bind { [weak self] value in
            if value.contains(where: {Int($0) != nil}) {
                self?.outputCycle.value = value.joined(separator: "") + "일 마다"
            } else {
                self?.outputCycle.value = value.joined(separator: ", ") + "요일 마다"
            }
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
        }
    }
}
