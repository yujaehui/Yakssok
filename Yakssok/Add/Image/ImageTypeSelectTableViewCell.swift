//
//  ImageTypeSelectTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit

class ImageTypeSelectTableViewCell: BaseTableViewCell {
    let typeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(typeImageView)
        contentView.addSubview(typeLabel)
    }
    
    override func configureConstraints() {
        typeImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(25)
            make.centerY.equalTo(contentView)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.leading.equalTo(typeImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
    }
    
    func configureCell(_ data: MyImageVersion) {
        typeImageView.image = data.image
        typeImageView.tintColor = data.color
        typeLabel.text = data.rawValue
        typeLabel.textColor = data.color
    }
}
