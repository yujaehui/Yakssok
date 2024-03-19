//
//  UITextField+Extension.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/18/24.
//

import UIKit
import SnapKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
