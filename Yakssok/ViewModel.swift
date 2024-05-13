//
//  ViewModel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/29/24.
//

import Foundation
import UserNotifications

class ViewModel {
    
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    init() {
//        inputViewDidLoadTrigger.bind { [weak self] value in
//            guard let self = self else { return }
//            guard let _ = value else { return }
//            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//            NotificationManager.shared.scheduleNotificationsFromSchedule(createGroupDataDict())
//        }
    }
    
//    private func createGroupDataDict() -> [(Date, [Date])] {
//        let supplements = SupplementRepository().fetchAllItems()
//        var groupedDataDict: [Date : [Date]] = [:]
//        for supplement in supplements {
//            if var supplementsForTime = groupedDataDict[supplement.date] {
//                supplementsForTime.append(supplement.time)
//                groupedDataDict[supplement.date] = supplementsForTime
//            } else {
//                groupedDataDict[supplement.date] = [supplement.time]
//            }
//            groupedDataDict[supplement.date] = self.getUniqueTimes(from: groupedDataDict[supplement.date]!)
//        }
//        return groupedDataDict.sorted{$0.key < $1.key}
//    }
//    
//    private func getUniqueTimes(from times: [Date]) -> [Date] {
//        var uniqueTimesSet = Set<Date>()
//        
//        for time in times {
//            uniqueTimesSet.insert(time)
//        }
//        
//        return Array(uniqueTimesSet).sorted()
//    }
}
