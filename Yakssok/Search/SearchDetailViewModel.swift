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
    let inputTimeList: Observable<[String]> = Observable(["오전 09:00"])
    
    // output
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    let outputTimeList: Observable<[String]> = Observable([])
    
    init() {
        inputSupplement.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSupplement.value = value
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
        }
    }
}
