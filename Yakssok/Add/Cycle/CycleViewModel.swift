//
//  CycleViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import Foundation
import Foundation

final class CycleViewModel {
    
    // input
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputSelectDayOfTheWeek: Observable<String?> = Observable(nil)
    let inputEveryDayOfTheWeek: Observable<[String]?> = Observable(nil)
    let inputDayOfTheWeekList: Observable<[String]?> = Observable(nil)
    
    // output
    let outputEveryDayIsSelected: Observable<Bool> = Observable(true)
    let outputIsSelected: Observable<Bool> = Observable(false)
    var outputSelectDayOfTheWeekList: Observable<[String]> = Observable([])
    let outputDayOfTheWeekList: Observable<[String]?> = Observable(nil)
    
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            
            // 아무것도 누르지 않았는지 확인
            if self.outputSelectDayOfTheWeekList.value == [] {
                self.outputIsSelected.value = false
            } else {
                self.outputIsSelected.value = true
            }
            
            // 모든 요일을 눌렀는지 확인
            if self.outputSelectDayOfTheWeekList.value.count != DayOfTheWeek.allCases.count {
                self.outputEveryDayIsSelected.value = false
            } else {
                self.outputEveryDayIsSelected.value = true
            }
        }
        
        inputSelectDayOfTheWeek.bind { value in
            guard let value = value else { return }
            // 이미 눌려 있던 항목이면 삭제, 아니면 추가하고 정렬
            if self.outputSelectDayOfTheWeekList.value.contains(where: {$0 == value}) {
                self.outputSelectDayOfTheWeekList.value.removeAll(where: {$0 == value})
            } else {
                self.outputSelectDayOfTheWeekList.value.append(value)
                self.outputSelectDayOfTheWeekList.value.sort { (day1, day2) -> Bool in
                    guard let index1 = DayOfTheWeek.allCases.firstIndex(of: DayOfTheWeek(rawValue: day1) ?? .sunday),
                          let index2 = DayOfTheWeek.allCases.firstIndex(of: DayOfTheWeek(rawValue: day2) ?? .sunday) else {
                        return false
                    }
                    return index1 < index2
                }
            }
            
            // 아무것도 누르지 않았는지 확인
            if self.outputSelectDayOfTheWeekList.value == [] {
                self.outputIsSelected.value = false
            } else {
                self.outputIsSelected.value = true
            }
            
            // 모든 요일을 눌렀는지 확인
            if self.outputSelectDayOfTheWeekList.value.count != DayOfTheWeek.allCases.count {
                self.outputEveryDayIsSelected.value = false
            } else {
                self.outputEveryDayIsSelected.value = true
            }
        }
        
        // 매일 복용을 눌렀을 때
        inputEveryDayOfTheWeek.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            // 이미 눌려 있던 상태면 전체 요일을 누르지 않은 상태로 변경, 아니라면 전체를 누른 상태로 변경
            if self.outputSelectDayOfTheWeekList.value == value {
                self.outputSelectDayOfTheWeekList.value.removeAll()
            } else {
                self.outputSelectDayOfTheWeekList.value = value
            }
            
            // 아무것도 누르지 않았는지 확인
            if self.outputSelectDayOfTheWeekList.value == [] {
                self.outputIsSelected.value = false
            } else {
                self.outputIsSelected.value = true
            }
            
            // 모든 요일을 눌렀는지 확인
            if self.outputSelectDayOfTheWeekList.value.count != DayOfTheWeek.allCases.count {
                self.outputEveryDayIsSelected.value = false
            } else {
                self.outputEveryDayIsSelected.value = true
            }
        }
        
        // 등록할 요일 전달
        inputDayOfTheWeekList.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputDayOfTheWeekList.value = value
        }
    }
}
