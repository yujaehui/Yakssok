//
//  CustomTextField.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        clipsToBounds = true
        layer.cornerRadius = 12
        font = FontStyle.titleBold
    }
}
