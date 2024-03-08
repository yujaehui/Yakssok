//
//  ButtonCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class ButtonCollectionViewCell: BaseCollectionViewCell {
    let buttonView = UIView()
    let titleLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(buttonView)
        buttonView.addSubview(titleLabel)
    }
    
    override func configureView() {
        buttonView.backgroundColor = .darkGray
        buttonView.layer.cornerRadius = 12
        titleLabel.text = "add"
    }
    
    override func configureConstraints() {
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }
    }
    
}
