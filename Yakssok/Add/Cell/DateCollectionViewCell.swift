//
//  DateCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

class DateCollectionViewCell: BaseCollectionViewCell {
    let dateView = UIView()
    let resultLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(dateView)
        dateView.addSubview(resultLabel)
    }
    
    override func configureView() {
        dateView.backgroundColor = .lightGray
        dateView.layer.cornerRadius = 12
        resultLabel.text = "result"
        resultLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        dateView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(dateView)
        }
    }
}
