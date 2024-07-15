//
//  AlertManager.swift
//  Yakssok
//
//  Created by Jaehui Yu on 5/13/24.
//

import UIKit

final class AlertManager {
    static let shared = AlertManager()
    private init() {}
    
    func showAlert(title: String, message: String, btnTitle: String, hadler: ((UIAlertAction) -> Void)? ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        let defaultButton = UIAlertAction(title: btnTitle, style: .default, handler: hadler)
        alert.addAction(cancelButton)
        alert.addAction(defaultButton)
        return alert
    }
    
    func showDestructiveAlert(title: String, message: String, hadler: ((UIAlertAction) -> Void)? ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive, handler: hadler)
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        return alert
    }
}
