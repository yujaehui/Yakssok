//
//  DayIntervalViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation

enum ValidationError: Error {
    case isEmpty
    case notNumber
    case lessThen0
    case greaterThan100
}

class DayIntervalViewModel {
    
    // input
    let inputText: Observable<String?> = Observable(nil)
    let inputDayInterval: Observable<String?> = Observable(nil)
    
    // output
    
    let outputColor: Observable<Bool> = Observable(false)
    let outputIsEnabled: Observable<Bool> = Observable(false)
    var outputDayIntervalList: Observable<[String]?> = Observable(nil)
    let outputStateText: Observable<String> = Observable("")
    
    init() {
        inputText.bind { [weak self] value in
            guard let value = value else { return }
            do {
                let _ = try validateUserInputError(text: value)
                stateTextField("\(value)일 마다 복용하시겠습니까?", color: true, isEnabled: true)
            } catch {
                switch error {
                case ValidationError.isEmpty: stateTextField("", color: false, isEnabled: false)
                case ValidationError.notNumber: stateTextField("숫자만 입력 가능합니다.", color: false, isEnabled: false)
                case ValidationError.lessThen0: stateTextField("최소 1일부터 가능합니다.", color: false, isEnabled: false)
                case ValidationError.greaterThan100: stateTextField("최대 100일까지 가능합니다.", color: false, isEnabled: false)
                default: print(error)
                }
            }
            
            func validateUserInputError(text: String) throws -> Bool {
                guard !(text.isEmpty) else { throw ValidationError.isEmpty }
                guard let num = Int(text) else { throw ValidationError.notNumber }
                guard num > 0 else { throw ValidationError.lessThen0 }
                guard num <= 100 else { throw ValidationError.greaterThan100 }
                return true
            }
            
            func stateTextField(_ stateText: String, color: Bool, isEnabled: Bool) {
                self?.outputStateText.value = stateText
                self?.outputColor.value = color
                self?.outputIsEnabled.value = isEnabled
            }
        }
        
        
        inputDayInterval.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputDayIntervalList.value = [value]
        }
    }
}





