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
    
    // output
    var outputUpdateSearchResults: Observable<[Row]> = Observable([])
    
    init() {
        inputUpdateSearchResults.bind { value in
            guard let value = value else { return }
            self.callRequest(value)
        }
    }
    
    private func callRequest(_ product: String) {
        APIService.shared.fetchSupplementAPI(api: SupplementAPI.supplement(startIdx: "1", endIdx: "1000", PRDLST_NM: product)) { success in
            self.outputUpdateSearchResults.value = success
        }
    }
}
