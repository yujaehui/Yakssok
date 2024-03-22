//
//  UISheetPresentationController.Detent+Extension.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/22/24.
//

import UIKit

extension UISheetPresentationController.Detent {
    static func customDetent(heightProvider: @escaping () -> CGFloat) -> UISheetPresentationController.Detent {
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            return heightProvider() - safeAreaBottom
        }
        return customDetent
    }
}


