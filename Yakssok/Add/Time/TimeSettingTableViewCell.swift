//
//  TimeSettingTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class TimeSettingTableViewCell: BaseTableViewCell {
    var passMoment: (() -> Void)?
    
    private let timeLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(timeLabel)
    }
    
    override func configureConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
    }
    
    func configureCell(_ data: String) {
        timeLabel.text = data
    }
}
