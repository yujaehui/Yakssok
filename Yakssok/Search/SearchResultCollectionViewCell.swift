//
//  SearchResultCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    let resultProductImageView = UIImageView()
    let resultBrandLabel = UILabel()
    let resultNameLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(resultProductImageView)
        contentView.addSubview(resultBrandLabel)
        contentView.addSubview(resultNameLabel)
    }
    
    override func configureView() {
        layer.cornerRadius = 12
        resultProductImageView.image = UIImage(systemName: "pill.circle.fill")
    }
    
    override func configureConstraints() {
        resultProductImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.centerX.equalTo(contentView)
            make.size.equalTo(100)
        }
        
        resultBrandLabel.snp.makeConstraints { make in
            make.top.equalTo(resultProductImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
        
        resultNameLabel.snp.makeConstraints { make in
            make.top.equalTo(resultBrandLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
    }
}
