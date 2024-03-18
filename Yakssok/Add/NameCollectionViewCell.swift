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
        backgroundColor = .systemGray6
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 12
        nameTextField.font = .boldSystemFont(ofSize: 18)
        nameTextField.placeholder = "영양제 이름을 입력해주세요."
        nameTextField.addLeftPadding()
        //nameTextField.addRightStatus(true)
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
    }
    
    @objc func nameTextFieldChanged() {
        passName?(nameTextField.text)
    }
    
    override func configureConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(contentView)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        nameTextField.text = itemIdentifier.item
    }
}
