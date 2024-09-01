//
//  CalendarViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/13/24.
//

import Foundation
import FSCalendar
import RealmSwift

enum CheckStatus {
    case checked             // 체크된 상태
    case uncheckedAndNotDue  // 체크되지 않고 날짜도 오지 않은 상태
    case unchecked           // 체크되지 않은 상태
}

final class CalendarViewModel {
    let repository = SupplementRepository()
    
    //input
    let inputSelectedDate: Observable<Date> = Observable(FSCalendar().today!)
    let inputCheck: Observable<(Date?, ObjectId?)> = Observable((nil, nil))
    let inputCombinedCheck: Observable<(Date, Date?, ObjectId?)> = Observable((FSCalendar().today!, nil, nil))
    
        
    //output
    let outputData: Observable<[(key: Date, value: [MySupplement])]> = Observable([])
    let outputCheckData: Observable<[CheckSupplement]> = Observable([])
    let outputCheckStatus: Observable<(CheckStatus, CheckSupplement?)> = Observable((.unchecked, nil))
    
    init() {
        inputSelectedDate.bind { [weak self] date in
            guard let self = self else { return }
            
            let supplements = self.repository.fetchItemBySelectedDate(selectedDate: date)
            self.outputData.value = self.convertToDictionary(supplements: supplements)
            let checkSupplements = self.repository.fetchCheckItemBySelectedDate(selectedDate: date)
            self.outputCheckData.value = checkSupplements
        }
        
        inputCheck.bind { [weak self] (time, pk) in
            guard let self = self else { return }
            self.inputCombinedCheck.value = (self.inputSelectedDate.value, time, pk)
        }
        
        inputCombinedCheck.bind { [weak self] (date, time, pk) in
            guard let self = self else { return }
            guard let time = time, let pk = pk else { return }
            print("inputCombinedCheck\ndate: \(date)\ntime: \(time)\npk: \(pk)")
            
            // 기존 데이터를 Realm에서 가져오기
            let existingCheckItems = repository.fetchCheckItemBySelectedDate(selectedDate: date)
            if let existingData = existingCheckItems.first(where: {
                DateFormatterManager.shared.makeHeaderDateFormatter2(date: $0.time) == DateFormatterManager.shared.makeHeaderDateFormatter2(date: time)
                && $0.fk == pk
            }) {
                print("checked")
                outputCheckStatus.value = (.checked, existingData) // fetch된 데이터를 사용
            } else {
                let newData = CheckSupplement(date: date, time: time, fk: pk)
                if date > FSCalendar().today! && !existingCheckItems.contains(where: { $0 == newData })  {
                    print("uncheckedAndNotDue")
                    outputCheckStatus.value = (.uncheckedAndNotDue, newData)
                } else {
                    print("unchecked")
                    outputCheckStatus.value = (.unchecked, newData)
                }
            }
        }
    }
    
    private func convertToDictionary(supplements: [MySupplement]) -> [(key: Date, value: [MySupplement])] {
        var resultDict: [Date: [MySupplement]] = [:]

        for supplement in supplements {
            for time in supplement.timeArray {
                resultDict.append(value: supplement, forKey: time)
            }
        }

        let sortedResult = resultDict.sorted { $0.key < $1.key }
        return sortedResult
    }
}


// 수정 전 코드
//final class CalendarViewModel {
//    let repository = SupplementRepository()
//    
//    //input
//    let inputDidSelectDate: Observable<Date> = Observable(FSCalendar().today!)
//    let inputDidCheckTime: Observable<MySupplements?> = Observable(nil)
//    
//    //output
//    let outputGroupedDataDict: Observable<[(Date, [MySupplements])]> = Observable([])
//    let outputShowAlert: Observable<(Bool, MySupplements)?> = Observable(nil)
//    
//    init() {
//        inputDidSelectDate.bind { [weak self] value in
//            guard let self = self else { return }
//            let supplements = self.repository.fetchByDate(date: value)
//            var groupedDataDict: [Date : [MySupplements]] = [:]
//            for supplement in supplements {
//                if var supplementsForTime = groupedDataDict[supplement.time] {
//                    supplementsForTime.append(supplement)
//                    groupedDataDict[supplement.time] = supplementsForTime
//                } else {
//                    groupedDataDict[supplement.time] = [supplement]
//                }
//            }
//            self.outputGroupedDataDict.value = groupedDataDict.sorted{$0.key < $1.key}
//        }
//        
//        inputDidCheckTime.bind { [weak self] value in
//            guard let self = self else { return }
//            guard let value = value else { return }
//            if value.date > FSCalendar().today! && value.isChecked == false {
//                outputShowAlert.value = (true, value)
//            } else {
//                outputShowAlert.value = (false, value)
//            }
//        }
//    }
//}
