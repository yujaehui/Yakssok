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
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureView() {
        contentView.backgroundColor = .white
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.size.equalTo(100)
            make.centerX.equalTo(contentView)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        imageView.image = itemIdentifier.image
    }
}
