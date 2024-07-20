//
//  ToastManager.swift
//  Yakssok
//
//  Created by Jaehui Yu on 7/20/24.
//

import UIKit
import Toast

// 사용 예정
class ToastManager {
    static let shared = ToastManager()
    private init() {}
    
    func showToast(title: String, in view: UIView) {
        var style = ToastStyle()
        style.backgroundColor = ColorStyle.point
        style.messageAlignment = .center
        style.messageFont = FontStyle.titleBold
        view.makeToast(title, duration: 2, position: .bottom, style: style)
    }
}
