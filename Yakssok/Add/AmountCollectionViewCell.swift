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
    let amountLabel = UILabel()
    let plusButton = UIButton()
    
    var minusButtonAction: (() -> Void)?
    var plusButtonAction: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func configureHierarchy() {
        contentView.addSubview(minusButton)
        contentView.addSubview(amountLabel)
        contentView.addSubview(plusButton)
    }
    
    override func configureView() {
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        minusButton.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
    }
    
    @objc func minusButtonClicked() {
        print(#function)
        minusButtonAction?()
    }
    
    @objc func plusButtonClicked() {
        print(#function)
        plusButtonAction?()
    }
    
    override func configureConstraints() {
        minusButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(44)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.center.equalTo(contentView)
            make.height.equalTo(44)
        }
        
        plusButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(44)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        amountLabel.text = itemIdentifier.item
    }
}
