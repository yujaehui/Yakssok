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
    let inputName: Observable<String?> = Observable(nil)
    let inputMinusAmount: Observable<Int> = Observable(1)
    let inputPlusAmount: Observable<Int> = Observable(1)
    let inputStartDay: Observable<Date> = Observable(Date())
    let inputCycle: Observable<[String]> = Observable(["1"])
    let inputTimeList: Observable<[Date]> = Observable([DateFormatterManager.shared.extractTime(date: Date())])
    
    // output
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    let outputName: Observable<String> = Observable("")
    
    let outputAmount: Observable<Int> = Observable(0)
    let outputAmountString: Observable<String> = Observable("")
    
    let outputStartDay: Observable<Date> = Observable(Date())
    let outputStartDayString: Observable<String> = Observable("")
    
    let outputCycle: Observable<String> = Observable("")
    
    let outputTimeList: Observable<[Date]> = Observable([])
    let outputTimeListString: Observable<[String]> = Observable([])
    
    init() {
        inputSupplement.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSupplement.value = value
        }
        
        inputName.bind { value in
            guard let value = value else { return }
            self.outputName.value = value
        }
        
        inputMinusAmount.bind { [weak self] value in
            guard let self = self else { return }
            if self.outputAmount.value <= 1 {
                return
            } else {
                self.outputAmount.value -= 1
                self.outputAmountString.value = String(self.outputAmount.value)
            }
        }
        
        inputPlusAmount.bind { [weak self] value in
            guard let self = self else { return }
            self.outputAmount.value += 1
            self.outputAmountString.value = String(self.outputAmount.value)
        }
        
        inputStartDay.bind { [weak self] value in
            self?.outputStartDay.value = value
            self?.outputStartDayString.value =  DateFormatterManager.shared.convertformatDateToString(date: value)
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
            self?.outputTimeListString.value = DateFormatterManager.shared.convertDateArrayToStringArray(dates: value)
        }
    }
}
