//
//  CalendarTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

class CalendarTableViewCell: BaseTableViewCell {
    let supplementLabel = UILabel()
    let checkButton = UIButton()
    
    var buttonAction: (() -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(supplementLabel)
        contentView.addSubview(checkButton)
    }
    
    override func configureView() {
        checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
    }
    
    @objc func checkButtonClicked() {
        buttonAction?()
    }
    
    override func configureConstraints() {
        supplementLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(44)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(44)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
    }
}
