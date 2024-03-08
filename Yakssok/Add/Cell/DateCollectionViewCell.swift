//
//  DateCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

class DateCollectionViewCell: BaseCollectionViewCell {
    let resultLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(resultLabel)
    }
    
    override func configureView() {
        backgroundColor = .green
        resultLabel.text = "result"
        resultLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
    }
}
