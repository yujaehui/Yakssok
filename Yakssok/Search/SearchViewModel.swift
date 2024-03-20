//
//  SearchViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import Foundation

class SearchViewModel {
    
    // input
    let inputUpdateSearchResults: Observable<String?> = Observable(nil)
    let inputName: Observable<String?> = Observable(nil)
    let inputStart: Observable<Int> = Observable(1)
    let inputEnd: Observable<Int> = Observable(30)
    
    // output
    var outputRow: Observable<[Row]> = Observable([])
    var outputTotalCount: Observable<String> = Observable("")
    var outputName: Observable<String?> = Observable(nil)
    var outputStart: Observable<Int> = Observable(1)
    var outputStartString: Observable<String> = Observable("1")
    var outputEnd: Observable<Int> = Observable(30)
    var outputEndString: Observable<String> = Observable("5")
    var outputEmpty: Observable<Bool> = Observable(false)
    var outputShowToast: Observable<Bool> = Observable(false)
    var outputError: Observable<String?> = Observable(nil)
    
    init() {
        inputUpdateSearchResults.bind { value in
            guard let value = value else { return }
            print(value)
            let product = Helpers.shared.replaceSpacesWithUnderscore(value)
            self.callRequest(product)
        }
        
        inputName.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputName.value = value
        }
        
        inputStart.bind { [weak self] value in
            self?.outputStart.value = value
            self?.outputStartString.value = String(value)
            self?.outputEnd.value = value + 30
            self?.outputEndString.value = String(value + 30)
        }
    }
    
    private func callRequest(_ product: String) {
        print(outputStartString.value, outputEndString.value)
        outputShowToast.value = true
        APIService.shared.fetchSupplementAPI(api: SupplementAPI.supplement(startIdx: outputStartString.value, endIdx: outputEndString.value, PRDLST_NM: product)) { success, error in
            if error == nil {
                guard let success = success else { return }
                self.outputShowToast.value = false
                if self.outputStart.value == 1 {
                    self.outputRow.value = success.row
                    self.outputTotalCount.value = success.totalCount
                    self.outputEmpty.value = self.outputTotalCount.value == "0" ? true : false
                    print(self.outputTotalCount.value, "#1")
                } else {
                    self.outputRow.value.append(contentsOf: success.row)
                    self.outputTotalCount.value = success.totalCount
                    print(self.outputTotalCount.value, "#2")
                }
            } else {
                self.outputError.value = "현재 네트워크 통신이 원할하지 않습니다.\n잠시후 다시 시도해주세요."
            }
        }
    }
}
