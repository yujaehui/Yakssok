//
//  AddViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation
import UIKit
import RealmSwift

enum AccessType: String {
    case create
    case update
}

final class AddViewModel {
    let repository = SupplementRepository()
    
    // input
    let inputType: Observable<AccessType> = Observable(.create)
    
    let inputMySupplement: Observable<MySupplement?> = Observable(nil)
    let inputMySupplements: Observable<[MySupplements]> = Observable([])
    
    let inputSupplement: Observable<Row?> = Observable(nil)
    
    let inputImage: Observable<UIImage?> = Observable(nil)
    let inputName: Observable<String?> = Observable(nil)
    let inputAmount: Observable<Int> = Observable(1)
    let inputStartDay: Observable<Date> = Observable(Date())
    let inputCycle: Observable<[String]> = Observable(["월"])
    let inputTimeList: Observable<[Date]> = Observable([DateFormatterManager.shared.extractTime(date: Date())])
    
    let inputCreateTrigger: Observable<Void?> = Observable(nil)
    let inputUpdateTrigger: Observable<Void?> = Observable(nil)
    let inputDeleteTrigger: Observable<Void?> = Observable(nil)
    
    // output
    let outputType: Observable<AccessType> = Observable(.create)
    
    let outputSupplement: Observable<Row> = Observable(Row(prdtShapCDNm: "", lastUpdtDtm: "", prdlstNm: "", bsshNm: "", pogDaycnt: "", ntkMthd: ""))
    
    let outputImage: Observable<UIImage> = Observable(UIImage(systemName: "pill")!)
    
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
        inputCreateTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            for i in repository.fetchAllItem() {
                if i.name == outputName.value {
                    print("같은 이름이 이미 존재함. 저장 ㄴㄴ") // 토스트
                    return
                }
            }
            
            if outputName.value.isEmpty {
                print("빈 이름. 저장 ㄴㄴ") // 토스트
                return
            }
            
            let data = MySupplement(name: outputName.value, amout: outputAmount.value, startDay: outputStartDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
            
            repository.createItem(data)
            Helpers.shared.saveImageToDocument(image: outputImage.value, fileName: "\(data.pk)")
            
            var startDay = outputStartDay.value
            let cycle = outputCycle.value
            let timeList = outputTimeList.value
            
            let endDate = Calendar.current.date(byAdding: .month, value: 3, to: startDay)!
            
            while startDay <= endDate {
                for dayOfWeek in cycle {
                    let dayComponents = DateComponents(weekday: DateFormatterManager.shared.dayOfWeekToNumber(dayOfWeek))
                    if let nextDay = Calendar.current.nextDate(after: startDay, matching: dayComponents, matchingPolicy: .nextTime) {
                        for time in timeList {
                            let scheduledSupplement = MySupplements(date: nextDay, time: time, name: outputName.value, amount: outputAmount.value, isChecked: false)
                            self.repository.createItems(scheduledSupplement)
                        }
                        startDay = Calendar.current.date(byAdding: .day, value: 0, to: nextDay)!
                    } else {
                        break
                    }
                }
            }
        }
        
        inputUpdateTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            guard let mySupplement = inputMySupplement.value else { return }
            
            for i in repository.fetchAllItem() {
                if i.name !=  mySupplement.name && i.name == outputName.value {
                    print("같은 이름이 이미 존재함. 변경 ㄴㄴ") // 토스트
                    return
                }
            }
            
            if outputName.value.isEmpty {
                print("빈 이름. 변경 ㄴㄴ") // 토스트
                return
            }
            
            repository.updateItem(data: mySupplement, name: outputName.value, amount: outputAmount.value)
            repository.updateItems(data: inputMySupplements.value, name: outputName.value, amount: outputAmount.value)
        }
        
        inputDeleteTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            guard let mySupplement = inputMySupplement.value else { return }
            Helpers.shared.removeImageFromDocument(fileName: "\(mySupplement.pk)")
            repository.deleteItem(mySupplement)
            repository.deleteItems(inputMySupplements.value)
        }
        
        inputType.bind { [weak self] value in
            guard let self = self else { return }
            outputType.value = value
        }
        
        inputMySupplement.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            inputName.value = value.name
            inputAmount.value = value.amout
            inputStartDay.value = value.startDay
            inputCycle.value = value.cycleArray
            inputTimeList.value = value.timeArray
        }
        
        inputSupplement.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputSupplement.value = value
        }
        
        inputImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputImage.value = value
        }
        
        inputName.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputName.value = value
        }
        
        inputAmount.bind { [weak self] value in
            self?.outputAmount.value = value
            self?.outputAmountString.value = String(value)
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
