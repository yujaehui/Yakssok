//
//  TimeSettingTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class TimeSettingTableViewCell: BaseTableViewCell {
    let timeLabel = UILabel()
    let editButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(editButton)
    }
    
    override func configureView() {
        editButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
    }
    
    @objc func editButtonClicked() {
    }
    
    override func configureConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(20)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(20)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
    }
}
