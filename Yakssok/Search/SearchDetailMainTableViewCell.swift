//
//  SearchDetailMainTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

class SearchDetailMainTableViewCell: BaseTableViewCell {
    let photoImageView = UIImageView()
    let rectangleBackgroundView = UIView()
    let nameLabel = UILabel()
    let brandLabel = UILabel()
    let shapeLabel = UILabel()
    let expirationDateLabel = UILabel()
    let infoButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(rectangleBackgroundView)
        rectangleBackgroundView.addSubview(nameLabel)
        rectangleBackgroundView.addSubview(brandLabel)
        rectangleBackgroundView.addSubview(shapeLabel)
        rectangleBackgroundView.addSubview(expirationDateLabel)
        rectangleBackgroundView.addSubview(infoButton)
        contentView.addSubview(photoImageView) // 위로 올라와야 되서 가장 마지막에 작성
    }
    
    override func configureView() {
        photoImageView.image = UIImage(systemName: "photo.circle.fill")
        rectangleBackgroundView.backgroundColor = .lightGray
        rectangleBackgroundView.layer.cornerRadius = 12
        nameLabel.text = "name"
        nameLabel.textAlignment = .center
        brandLabel.text = "brand"
        brandLabel.textAlignment = .center
        shapeLabel.text = "shape"
        shapeLabel.textAlignment = .center
        expirationDateLabel.text = "expirationDate"
        expirationDateLabel.textAlignment = .center
        infoButton.setTitle("info", for: .normal)
        infoButton.contentMode = .center
    }
    
    override func configureConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.centerX.equalTo(contentView)
            make.size.equalTo(150)
        }
        
        rectangleBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.top).offset(75) // 150/2
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(8) // 높이가 없으니까 equalTo
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(rectangleBackgroundView).inset(83) // 75+8
            make.horizontalEdges.equalTo(rectangleBackgroundView).inset(16)
            make.height.equalTo(16)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(rectangleBackgroundView).inset(16)
            make.height.equalTo(16)
        }
        
        shapeLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(rectangleBackgroundView).inset(16)
            make.height.equalTo(16)
        }
        
        expirationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(shapeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(rectangleBackgroundView).inset(16)
            make.height.equalTo(16)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(expirationDateLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(rectangleBackgroundView).inset(16)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualTo(rectangleBackgroundView).inset(8) // 높이가 있으니까 lessThanOrEqualTo
        }
    }
}

