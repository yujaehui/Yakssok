//
//  AmountCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

class AmountCollectionViewCell: BaseCollectionViewCell {
    let minusButton = UIButton()
    let amountTextField = UITextField()
    let plusButton = UIButton()
    
    var passAmount: ((Int) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(minusButton)
        contentView.addSubview(amountTextField)
        contentView.addSubview(plusButton)
    }
    
    override func configureView() {
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        minusButton.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        
        amountTextField.placeholder = "0"
        amountTextField.textAlignment = .center
        amountTextField.isUserInteractionEnabled = false
        amountTextField.addTarget(self, action: #selector(amountTextFieldChanged), for: .editingChanged)
    }
    
    @objc func amountTextFieldChanged() {
        guard let text = amountTextField.text else { return }
        guard let number = Int(text), number > 1 else { return }
        passAmount?(number)
    }
    
    @objc func minusButtonClicked() {
        guard let text = amountTextField.text else { return }
        guard var number = Int(text), number > 1 else { return }
        number = number - 1
        amountTextField.text = String(number)
    }
    
    @objc func plusButtonClicked() {
        guard let text = amountTextField.text else { return }
        guard var number = Int(text) else { return }
        number = number + 1
        amountTextField.text = String(number)
    }
    
    override func configureConstraints() {
        minusButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.leading.equalTo(contentView).inset(16)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.center.equalTo(contentView)
        }
        
        plusButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        amountTextField.text = itemIdentifier.item
    }
}
