//
//  AmountCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

class AmountCollectionViewCell: BaseCollectionViewCell {
    let amountTextField: UITextField = {
        let textField = CustomTextField()
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.configuration = .basic(image: "minus.circle.fill")
        button.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.configuration = .basic(image: "plus.circle.fill")
        button.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var passAmount: ((Int) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(amountTextField)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
    }
    
    override func configureConstraints() {
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(44)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(44)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(44)
        }
    }
    
    @objc func minusButtonClicked() {
        guard let text = amountTextField.text else { return }
        guard var number = Int(text), number > 1 else { return }
        number = number - 1
        amountTextField.text = String(number)
        passAmount?(number)
    }
    
    @objc func plusButtonClicked() {
        guard let text = amountTextField.text else { return }
        guard var number = Int(text) else { return }
        number = number + 1
        amountTextField.text = String(number)
        passAmount?(number)
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        amountTextField.text = itemIdentifier.item
    }
}
