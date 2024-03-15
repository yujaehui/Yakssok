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
        imageView.image = UIImage(systemName: "star.fill")
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(100)
        }
    }
    
}
