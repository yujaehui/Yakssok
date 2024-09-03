//
//  StockViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 9/1/24.
//

import Foundation

final class StockViewModel {
    
    // input
    let inputStock: Observable<String?> = Observable(nil)
    
    // output
    let outputStock: Observable<String?> = Observable(nil)
    
    init() {
        inputStock.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputStock.value = value
        }
    }
}
