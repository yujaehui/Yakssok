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
    case create = "등록"
    case update = "수정"
}

enum RegistrationStatus: String {
    case success
    case duplicateName = "같은 이름의 영양제가 이미 존재합니다."
    case noName = "영양제 이름을 입력해주세요."
    case limitExceeded = "영양제를 이미 많은 시간에 등록하셨습니다.\n다른 영양제와 같이 복용하신다면\n복용 시간을 같은 시간으로 설정해보세요."
}

final class AddViewModel {
    let repository = SupplementRepository()
    
    // input
    let inputType: Observable<AccessType> = Observable(.create)
    
    let inputMySupplement: Observable<MySupplement?> = Observable(nil)
    
    let inputImage: Observable<UIImage?> = Observable(nil)
    let inputName: Observable<String?> = Observable(nil)
    let inputAmount: Observable<Int> = Observable(1)
    let inputStock: Observable<String> = Observable("설정 안함")
    let inputStartDay: Observable<Date> = Observable(FSCalendar().today!)
    let inputCycle: Observable<[String]> = Observable(DayOfTheWeek.allCases.map { $0.rawValue })
    let inputTimeList: Observable<[Date]> = Observable([DateFormatterManager.shared.extractTime(date: DateFormatterManager.shared.generateNineAM())])
    
    // output
    let outputType: Observable<AccessType> = Observable(.create)
        
    let outputImage: Observable<UIImage> = Observable(ImageStyle.supplement)
    let outputCurrentImage: Observable<Bool> = Observable(true)
    
    let outputName: Observable<String> = Observable("")
    
    let outputAmount: Observable<Int> = Observable(0)
    let outputAmountString: Observable<String> = Observable("")
    
    let outputStock: Observable<String> = Observable("")
    
    let outputStartDay: Observable<Date> = Observable(FSCalendar().today!)
    
    let outputCycle: Observable<[String]> = Observable([])
    let outputCycleString: Observable<String> = Observable("")
    
    let outputTimeList: Observable<[Date]> = Observable([])
    let outputTimeListString: Observable<[String]> = Observable([])

    let createTrigger: Observable<Void?> = Observable(nil)
    let updateTrigger: Observable<Void?> = Observable(nil)
    let updateButtonClicked: Observable<Void?> = Observable(nil)
    let deleteTrigger: Observable<Void?> = Observable(nil)
    let deleteButtonClicked: Observable<Void?> = Observable(nil)
    
    let outputRegistrationStatus: Observable<RegistrationStatus?> = Observable(nil)
    
    var presentSearchVC: Observable<Void?> = Observable(nil)
    
    init() {
        createTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let _ = value else { return }
            
            // 1. 이미 같은 이름이 있는지 확인
            for i in repository.fetchItem() {
                if i.name == outputName.value {
                    outputRegistrationStatus.value = .duplicateName
                    return
                }
            }
            // 2. 이름이 비었는지 확인
            if outputName.value.isEmpty {
                outputRegistrationStatus.value = .noName
                return
            }
            
            // 3-1. 임시로 데이터를 추가하고 알림 갯수 확인
            let temporaryData = MySupplement(name: outputName.value, amount: outputAmount.value, stock: outputStock.value, startDay: outputStartDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
            
            // 3-2. 기존 데이터에 임시 데이터를 추가하여 알림 갯수를 시뮬레이션
            var allSupplements = repository.fetchItem()
            allSupplements.append(temporaryData)
            
            if totalTimesCount(from: convertToDictionary(supplements: allSupplements)) >= 64 {
                outputRegistrationStatus.value = .limitExceeded
                return
            }
            
            outputRegistrationStatus.value = .success
            
            let data = MySupplement(name: outputName.value, amount: outputAmount.value, stock: outputStock.value, startDay: outputStartDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
            
            if outputImage.value != ImageStyle.supplement {
                ImageDocumentManager.shared.saveImageToDocument(image: outputImage.value, fileName: "\(data.pk)")
            }
            
            repository.createItem(data)
                        
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            NotificationManager.shared.scheduleLocalNotifications(for: convertToDictionary(supplements: repository.fetchItem()))
        }
        
        updateButtonClicked.bind { [weak self] value in
            guard let self = self else { return }
            guard let _ = value else { return }
            guard let mySupplement = inputMySupplement.value else { return }
            
            // 1. 이미 같은 이름이 있는지 확인
            for i in repository.fetchItem() {
                if i.name !=  mySupplement.name && i.name == outputName.value {
                    outputRegistrationStatus.value = .duplicateName
                    return
                }
            }
            // 2. 이름이 비었는지 확인
            if outputName.value.isEmpty {
                outputRegistrationStatus.value = .noName
                return
            }
            
            // 3-1. 임시로 데이터를 업데이트하고 알림 갯수 확인
            let currentSupplements = repository.fetchItem().filter { $0.pk != mySupplement.pk }
            let updatedSupplement = MySupplement(name: outputName.value, amount: outputAmount.value, stock: outputStock.value, startDay: outputStartDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
            
            // 3-2. 기존 데이터에 업데이트된 데이터를 포함하여 알림 갯수를 시뮬레이션
            var allSupplements = currentSupplements
            allSupplements.append(updatedSupplement)
            
            if totalTimesCount(from: convertToDictionary(supplements: allSupplements)) >= 64 {
                outputRegistrationStatus.value = .limitExceeded
                return
            }
            
            outputRegistrationStatus.value = .success
            
            // 1. 이전 이미지가 있다면 제거
            if ImageDocumentManager.shared.loadImageToDocument(fileName: "\(mySupplement.pk)") != nil {
                ImageDocumentManager.shared.removeImageFromDocument(fileName: "\(mySupplement.pk)")
            }
            // 2. 현재 이미지가 기본 이미지가 아니라면 저장
            if outputImage.value != ImageStyle.supplement {
                ImageDocumentManager.shared.saveImageToDocument(image: outputImage.value, fileName: "\(mySupplement.pk)")
            }
            
            repository.updateItem(data: mySupplement, name: outputName.value, amount: outputAmount.value, stock: outputStock.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            NotificationManager.shared.scheduleLocalNotifications(for: convertToDictionary(supplements: repository.fetchItem()))
        }
        
        deleteButtonClicked.bind { [weak self] value in
            guard let self = self else { return }
            guard let _ = value else { return }
            
            guard let mySupplement = inputMySupplement.value else { return }
            ImageDocumentManager.shared.removeImageFromDocument(fileName: "\(mySupplement.pk)")
            repository.deleteItem(mySupplement)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            NotificationManager.shared.scheduleLocalNotifications(for: convertToDictionary(supplements: repository.fetchItem()))
        }
        
        inputType.bind { [weak self] value in
            guard let self = self else { return }
            outputType.value = value
        }
        
        inputMySupplement.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            inputImage.value = ImageDocumentManager.shared.loadImageToDocument(fileName: "\(value.pk)")
            inputName.value = value.name
            inputAmount.value = value.amount
            inputStock.value = value.stock
            inputStartDay.value = value.startDay
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
        
        inputStock.bind { [weak self] value in
            self?.outputStock.value = value
        }
        
        inputStartDay.bind { [weak self] value in
            self?.outputStartDay.value = value
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
    
    private func convertToDictionary(supplements: [MySupplement]) -> [(Int, [Date])] {
        var resultDict: [Int: [Date]] = [:]
        
        for supplement in supplements {
            for day in supplement.cycle {
                let dayNumber = DateFormatterManager.shared.dayOfWeekToNumber(day)
                for time in supplement.time {
                    resultDict.append(value: time, forKey: dayNumber)
                }
            }
        }
        
        let sortedDict = resultDict.sorted { $0.key < $1.key }
        return sortedDict
    }
    
    private func totalTimesCount(from dictionary: [(Int, [Date])]) -> Int {
        return dictionary.reduce(0) { $0 + $1.1.count }
    }
}
