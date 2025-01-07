//
//  AppDelegate.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit
import FirebaseCore
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        
        // UNUserNotificationCenterDelegate 설정
        UNUserNotificationCenter.current().delegate = self
        
        // Migration
        configureRealm()
        
        return true
    }
    
    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2, // 버전 2: MySupplements -> CheckSupplement 마이그레이션
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // v1 -> v2 변경 사항:
                    // - MySupplements 제거
                    // - CheckSupplement로 데이터 이전
                    // - MySupplement에 stock 추가
                    
                    // 1. MySupplements의 isChecked가 true인 항목, CheckSupplement로 데이터 변환
                    migration.enumerateObjects(ofType: "MySupplements") { oldObject, _ in
                        if let oldObject = oldObject, oldObject["isChecked"] as? Bool == true {
                            // MySupplement와 매핑할 fk 찾기
                            let name = oldObject["name"] as? String
                            let amount = oldObject["amount"] as? Int
                            
                            var fk: ObjectId? = nil
                            
                            // MySupplement에서 해당 pk를 찾아 설정
                            migration.enumerateObjects(ofType: "MySupplement") { supplementObject, _ in
                                if let supplementObject = supplementObject,
                                   supplementObject["name"] as? String == name,
                                   supplementObject["amount"] as? Int == amount {
                                    fk = supplementObject["pk"] as? ObjectId
                                }
                            }
                            
                            // CheckSupplement 생성
                            if let fk = fk {
                                migration.create("CheckSupplement", value: [
                                    "pk": ObjectId.generate(),
                                    "date": oldObject["date"] ?? Date(),
                                    "time": oldObject["time"] ?? Date(),
                                    "fk": fk
                                ])
                            } else {
                                print("Warning: MySupplement not found for \(String(describing: name)), \(String(describing: amount))")
                            }
                        }
                    }
                    
                    // MySupplements 테이블 삭제
                    migration.deleteData(forType: "MySupplements")
                    
                    // MySupplement에 stock 추가
                    migration.enumerateObjects(ofType: "MySupplement") { _, newObject in
                        // 새 속성 추가: stock
                        newObject?["stock"] = "설정 안함" // 기본값 설정
                    }
                }
            }
        )
        
        // 새로운 Realm 설정 적용
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // 포그라운드에서 알림을 받기 위한 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 포그라운드에서도 알림을 띄우기 위해 .banner 또는 .alert 옵션을 사용
        completionHandler([.banner, .sound, .list])
    }
}


