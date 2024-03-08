//
//  DescriptionCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

class DescriptionCollectionViewCell: BaseCollectionViewCell {
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let brandLabel = UILabel()
    let shapeLabel = UILabel()
    let expirationDateLabel = UILabel()
    let infoButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(shapeLabel)
        contentView.addSubview(expirationDateLabel)
        contentView.addSubview(infoButton)
    }
    
    override func configureView() {
        backgroundColor = .blue
        photoImageView.image = UIImage(systemName: "photo.circle.fill")
        nameLabel.text = "name"
        nameLabel.textAlignment = .center
        brandLabel.text = "brand"
        brandLabel.textAlignment = .center
        shapeLabel.text = "shape"
        shapeLabel.textAlignment = .center
        expirationDateLabel.text = "expirationDate"
        expirationDateLabel.textAlignment = .center
        infoButton.setTitle("info", for: .normal)
        infoButton.setTitleColor(.systemBlue, for: .normal)
        infoButton.contentMode = .center
    }
    
    override func configureConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.centerX.equalTo(contentView)
            make.size.equalTo(150)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
        
        shapeLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
        
        expirationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(shapeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(expirationDateLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
    }
}

