//
//  ImageCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: BaseCollectionViewCell {
    let imageView: UIImageView = {
        let imageView = BasicImageView(frame: .zero)
        return imageView
    }()
    
    let imageAddLabel: UILabel = {
        let label = CustomLabel(type: .descriptionGray)
        label.text = "이미지 변경하기"
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(imageAddLabel)
    }
    
    override func configureView() {
        contentView.backgroundColor = ColorStyle.grayBackground
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.size.equalTo(100)
            make.centerX.equalTo(contentView)
        }
        
        imageAddLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        imageView.image = itemIdentifier.image
    }
}
