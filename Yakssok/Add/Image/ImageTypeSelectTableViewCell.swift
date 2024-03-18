//
//  ImageTypeSelectTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit

class ImageTypeSelectTableViewCell: BaseTableViewCell {
    let typeImageView = UIImageView()
    let typeLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(typeImageView)
        contentView.addSubview(typeLabel)
    }
    
    override func configureConstraints() {
        typeImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.centerY.equalTo(contentView)
            make.size.equalTo(25)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(typeImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
            make.bottom.lessThanOrEqualTo(contentView)
        }
    }
    
    func configureCell(_ data: MyImageVersion) {
        typeImageView.image = data.image
        typeLabel.text = data.rawValue
    }
}
