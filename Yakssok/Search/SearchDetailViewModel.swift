//
//  SearchDetailViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation

class SearchDetailViewModel {
    
    // input
    let inputSupplement: Observable<Row?> = Observable(nil)
    let inputStartDay: Observable<[String]> = Observable([DateFormatterManager.shared.formatDateToString(date: Date())])
    let inputTimeList: Observable<[String]> = Observable(["오전 09:00"])
    
    // output
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    let outputStartDay: Observable<[String]> = Observable([])
    let outputTimeList: Observable<[String]> = Observable([])
    
    init() {
        inputSupplement.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSupplement.value = value
        }
        
        inputStartDay.bind { [weak self] value in
            self?.outputStartDay.value = value
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
        }
    }
}
