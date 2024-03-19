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
    
    // output
    var outputSupplement: Observable<[Row]> = Observable([])
    var outputName: Observable<String?> = Observable(nil)
    
    init() {
        inputUpdateSearchResults.bind { value in
            guard let value = value else { return }
            let product = Helpers.shared.replaceSpacesWithUnderscore(value)
            self.callRequest(product)
        }
        
        inputName.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputName.value = value
            
        }
    }
    
    private func callRequest(_ product: String) {
        APIService.shared.fetchSupplementAPI(api: SupplementAPI.supplement(startIdx: "1", endIdx: "1000", PRDLST_NM: product)) { success in
            self.outputSupplement.value = success
        }
    }
}
