//
//  AddViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import Foundation
import UIKit
import RealmSwift
import FSCalendar

enum AccessType: String {
    case create
    case update
}

enum NameStatus: String {
    case possibleName
    case sameName = "같은 이름의 영양제가 이미 존재합니다."
    case emptyName = "영양제 이름을 입력해주세요."
}

final class AddViewModel {
    let repository = SupplementRepository()
    
    // input
    let inputType: Observable<AccessType> = Observable(.create)
    
    let inputMySupplement: Observable<MySupplement?> = Observable(nil)
    let inputMySupplements: Observable<[MySupplements]> = Observable([])
    
    let inputImage: Observable<UIImage?> = Observable(nil)
    let inputName: Observable<String?> = Observable(nil)
    let inputAmount: Observable<Int> = Observable(1)
    let inputStartDay: Observable<Date> = Observable(FSCalendar().today!)
    let inputPeriod: Observable<Int> = Observable(1)
    let inputCycle: Observable<[String]> = Observable(["월"])
    let inputTimeList: Observable<[Date]> = Observable([DateFormatterManager.shared.extractTime(date: DateFormatterManager.shared.generateNineAM())])
    
    // output
    let outputType: Observable<AccessType> = Observable(.create)
        
    let outputImage: Observable<UIImage> = Observable(ImageStyle.supplement)
    let outputCurrentImage: Observable<Bool> = Observable(true)
    
    let outputName: Observable<String> = Observable("")
    
    let outputAmount: Observable<Int> = Observable(0)
    let outputAmountString: Observable<String> = Observable("")
    
    let outputStartDay: Observable<Date> = Observable(Date())
    let outputStartDayString: Observable<String> = Observable("")
    
    let outputPeriod: Observable<Int> = Observable(1)
    let outputPeriodString: Observable<String> = Observable("")
    let outputEndDay: Observable<Date> = Observable(Date())
    
    let outputCycle: Observable<[String]> = Observable([])
    let outputCycleString: Observable<String> = Observable("")
    
    let outputTimeList: Observable<[Date]> = Observable([])
    let outputTimeListString: Observable<[String]> = Observable([])

    let createTrigger: Observable<Void?> = Observable(nil)
    let updateTrigger: Observable<Void?> = Observable(nil)
    let deleteTrigger: Observable<Void?> = Observable(nil)
    
    let outputNameStatus: Observable<NameStatus?> = Observable(nil)
    
    var presentSearchVC: Observable<Void?> = Observable(nil)
    
    init() {
        createTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let _ = value else { return }
            
            // 1. 이미 같은 이름이 있는지 확인
            for i in repository.fetchAllItem() {
                if i.name == outputName.value {
                    outputNameStatus.value = .sameName
                    return
                }
            }
            // 2. 이름이 비었는지 확인
            if outputName.value.isEmpty {
                outputNameStatus.value = .emptyName
                return
            }
            
            outputNameStatus.value = .possibleName
            
            let data = MySupplement(name: outputName.value, amout: outputAmount.value, startDay: outputStartDay.value, period: outputPeriod.value, endDay: outputEndDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
            
            if outputImage.value != ImageStyle.supplement {
                Helpers.shared.saveImageToDocument(image: outputImage.value, fileName: "\(data.pk)")
            }
            
            repository.createItem(data)
            
            generateScheduledSupplements(startDay: outputStartDay.value)
        }
        
        updateTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let _ = value else { return }
            guard let mySupplement = inputMySupplement.value else { return }
            
            // 1. 이미 같은 이름이 있는지 확인
            for i in repository.fetchAllItem() {
                if i.name !=  mySupplement.name && i.name == outputName.value {
                    outputNameStatus.value = .sameName
                    return
                }
            }
            // 2. 이름이 비었는지 확인
            if outputName.value.isEmpty {
                outputNameStatus.value = .emptyName
                return
            }
            
            outputNameStatus.value = .possibleName
            
            // 1. 이전 이미지가 있다면 제거
            if Helpers.shared.loadImageToDocument(fileName: "\(mySupplement.pk)") != nil {
                Helpers.shared.removeImageFromDocument(fileName: "\(mySupplement.pk)")
            }
            // 2. 현재 이미지가 기본 이미지가 아니라면 저장
            if outputImage.value != ImageStyle.supplement {
                Helpers.shared.saveImageToDocument(image: outputImage.value, fileName: "\(mySupplement.pk)")
            }
            
            repository.updateItem(data: mySupplement, period: outputPeriod.value, endDay: outputEndDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value, name: outputName.value, amount: outputAmount.value)
            
            // MARK: important
            // 1. 이름 변경
            repository.updateItems(data: inputMySupplements.value, name: outputName.value, amount: outputAmount.value)
            // 2. 오늘 날짜 이후의 항목 제거
            repository.deleteFutureItems(data: inputMySupplements.value, date: Date())
            // 3. 새롭게 변화된 항목 추가
            generateScheduledSupplements(startDay: Date())
        }
        
        deleteTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let _ = value else { return }
            
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
            inputImage.value = Helpers.shared.loadImageToDocument(fileName: "\(value.pk)")
            inputName.value = value.name
            inputAmount.value = value.amount
            inputStartDay.value = value.startDay
            inputPeriod.value = value.period
            inputCycle.value = value.cycleArray
            inputTimeList.value = value.timeArray
        }
        
        inputImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.outputImage.value = value
            self?.outputCurrentImage.value = value == ImageStyle.supplement ? true : false // 현재 사진 삭제 cell 여부를 확인하기 위함
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
            print(value)
            self?.outputStartDay.value = value
            self?.outputStartDayString.value =  DateFormatterManager.shared.convertformatDateToString(date: value)
            self?.outputEndDay.value = Calendar.current.date(byAdding: .month, value: (self?.outputPeriod.value)!, to: value)! //⭐️
        }
        
        inputPeriod.bind { [weak self] value in
            self?.outputPeriod.value = value
            self?.outputPeriodString.value = String(value) + "개월"
        }
        
        inputCycle.bind { [weak self] value in
            self?.outputCycle.value = value
            self?.outputCycleString.value = value.count == DayOfTheWeek.allCases.count ? "매일" : value.joined(separator: ", ")
        }
        
        inputTimeList.bind { [weak self] value in
            self?.outputTimeList.value = value
            self?.outputTimeListString.value = DateFormatterManager.shared.convertDateArrayToStringArray(dates: value)
        }
    }
    
    func generateScheduledSupplements(startDay: Date) {
        var startDay = startDay
        let endDate = outputEndDay.value
        let cycle = outputCycle.value
        let timeList = outputTimeList.value
                
        while startDay <= endDate {
            for dayOfWeek in cycle {
                let dayComponents = DateComponents(weekday: DateFormatterManager.shared.dayOfWeekToNumber(dayOfWeek))
                if Calendar.current.component(.weekday, from: startDay) == dayComponents.weekday {
                    for time in timeList {
                        let scheduledSupplement = MySupplements(date: startDay, time: time, name: outputName.value, amount: outputAmount.value, isChecked: false)
                        self.repository.createItems(scheduledSupplement)
                    }
                }
            }
            startDay = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
        }
    }

}
