//
//  ImageCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            //make.center.equalTo(contentView)
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.centerX.equalTo(contentView)
            make.size.equalTo(100)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        imageView.image = itemIdentifier.image
    }
}
