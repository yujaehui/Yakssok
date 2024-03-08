//
//  TimeCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit

class TimeCollectionViewCell: BaseCollectionViewCell {
    let timeView = UIView()
    let resultLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(timeView)
        timeView.addSubview(resultLabel)
    }
    
    override func configureView() {
        timeView.backgroundColor = .lightGray
        timeView.layer.cornerRadius = 12
        resultLabel.text = "result"
        resultLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        timeView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(timeView)
        }
    }
}
