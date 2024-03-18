//
//  AmountCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

class AmountCollectionViewCell: BaseCollectionViewCell {
    let amountTextField = UITextField()
    let minusButton = UIButton()
    let plusButton = UIButton()
    
    var passAmount: ((Int) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(amountTextField)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
    }
    
    override func configureView() {
        backgroundColor = .systemGray6
        amountTextField.clipsToBounds = true
        amountTextField.layer.cornerRadius = 12
        amountTextField.font = .boldSystemFont(ofSize: 18)
        amountTextField.textAlignment = .center
        amountTextField.isUserInteractionEnabled = false
        minusButton.configuration = .calculate(image: "minus.circle.fill")
        plusButton.configuration = .calculate(image: "plus.circle.fill")
        minusButton.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
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
    
    override func configureConstraints() {
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(contentView)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.size.equalTo(44)
            make.leading.equalTo(contentView).inset(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.size.equalTo(44)
            make.trailing.equalTo(contentView).inset(16)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        amountTextField.text = itemIdentifier.item
    }
}
