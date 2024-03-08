//
//  AlaramSettingTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

class AlaramSettingTableViewCell: BaseTableViewCell {
    let rectangleBackgroundView = UIView()
    let resultLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(rectangleBackgroundView)
        rectangleBackgroundView.addSubview(resultLabel)
    }
    
    override func configureView() {
        rectangleBackgroundView.backgroundColor = .lightGray
        rectangleBackgroundView.layer.cornerRadius = 12
        resultLabel.text = "resultLabel"
        resultLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        rectangleBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(8)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(rectangleBackgroundView).inset(8)
            make.horizontalEdges.equalTo(rectangleBackgroundView).inset(16)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualTo(rectangleBackgroundView).inset(8)
        }
    }

}
