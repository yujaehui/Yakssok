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
    let inputAmount: Observable<Int> = Observable(1)
    let inputStartDay: Observable<Date> = Observable(Date())
    let inputCycle: Observable<[String]> = Observable(["월"])
    let inputTimeList: Observable<[Date]> = Observable([DateFormatterManager.shared.extractTime(date: Date())])
    
    // output
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    let outputName: Observable<String> = Observable("")
    
    let outputAmount: Observable<Int> = Observable(0)
    let outputAmountString: Observable<String> = Observable("")
    
    let outputStartDay: Observable<Date> = Observable(Date())
    let outputStartDayString: Observable<String> = Observable("")
    
    let outputCycle: Observable<[String]> = Observable([])
    let outputCycleString: Observable<String> = Observable("")
    
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
        
        inputAmount.bind { value in
            self.outputAmount.value = value
            self.outputAmountString.value = String(value)
        }
        
        inputStartDay.bind { [weak self] value in
            self?.outputStartDay.value = value
            self?.outputStartDayString.value =  DateFormatterManager.shared.convertformatDateToString(date: value)
        }
        
        inputCycle.bind { [weak self] value in
            self?.outputCycle.value = value
            self?.outputCycleString.value = value.joined(separator: ", ")
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
            self?.outputTimeListString.value = DateFormatterManager.shared.convertDateArrayToStringArray(dates: value)
        }
    }
}
