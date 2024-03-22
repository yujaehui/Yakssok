//
//  NameCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

class NameCollectionViewCell: BaseCollectionViewCell {
    var passName: ((String?) -> Void)?
    var passMoment: (() -> Void)?
    
    lazy var nameTextField: UITextField = {
        let textField = CustomTextField()
        textField.placeholder = "영양제 이름을 입력해주세요."
        textField.addLeftPadding()
        textField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.configuration = .basic(image: "magnifyingglass")
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return button
    }()
        
    override func configureHierarchy() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(searchButton)
    }
    
    override func configureConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(searchButton.snp.leading).offset(-16)
            make.height.equalTo(44)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(44)
        }
        
    }
    
    @objc func searchButtonClicked() {
        passMoment?()
    }
    
    @objc func nameTextFieldChanged() {
        passName?(nameTextField.text)
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        nameTextField.text = itemIdentifier.item
    }
}

extension NameCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
