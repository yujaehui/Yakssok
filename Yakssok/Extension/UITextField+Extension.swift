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
    
    func addRightStatus(_ status: Bool) {
        let statusView: UIView = {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let statusImageView = UIImageView()
            view.addSubview(statusImageView)
            statusImageView.image = UIImage(systemName: "checkmark.circle")
            statusImageView.tintColor = status ? .systemGreen : .systemRed
            statusImageView.snp.makeConstraints { make in
                make.leading.verticalEdges.equalTo(view)
                make.trailing.equalTo(view).inset(10)
            }
            return view
        }()
        self.rightView = statusView
        self.rightViewMode = .always
    }
}
