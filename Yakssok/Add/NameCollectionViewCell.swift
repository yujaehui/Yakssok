//
//  NameCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

class NameCollectionViewCell: BaseCollectionViewCell {
    let nameTextField = UITextField()
    
    var passName: ((String?) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(nameTextField)
    }
    
    override func configureView() {
        nameTextField.placeholder = "영양제 이름을 입력해주세요"
        nameTextField.textAlignment = .center
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
    }
    
    @objc func nameTextFieldChanged() {
        print(nameTextField.text!)
        passName?(nameTextField.text)
    }
    
    override func configureConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(44)
        }
    }
}
