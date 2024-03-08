//
//  AmountCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class AmountCollectionViewCell: BaseCollectionViewCell {
    let amountView = UIView()
    let minusButton = UIButton()
    let resultLabel = UILabel()
    let plusButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(amountView)
        amountView.addSubview(minusButton)
        amountView.addSubview(resultLabel)
        amountView.addSubview(plusButton)
    }
    
    override func configureView() {
        amountView.backgroundColor = .lightGray
        amountView.layer.cornerRadius = 12
        minusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        resultLabel.text = "1"
        resultLabel.textAlignment = .center
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.imageView?.contentMode = .scaleAspectFill
    }
    
    override func configureConstraints() {
        amountView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(amountView)
            make.leading.equalTo(amountView).inset(8)
            make.size.equalTo(40)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(amountView)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(amountView)
            make.trailing.equalTo(amountView).inset(8)
            make.size.equalTo(40)
        }
        
    }
}
