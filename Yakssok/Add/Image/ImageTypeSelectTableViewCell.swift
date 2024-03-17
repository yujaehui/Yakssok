//
//  ImageTypeSelectTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/15/24.
//

import UIKit
import SnapKit

class ImageTypeSelectTableViewCell: BaseTableViewCell {
    let typeLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(typeLabel)
    }
    
    override func configureView() {
        typeLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        typeLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(44)
            make.bottom.lessThanOrEqualTo(contentView)
        }
    }
    
    func configureCell(_ data: ImageType) {
        typeLabel.text = data.rawValue
    }
}
