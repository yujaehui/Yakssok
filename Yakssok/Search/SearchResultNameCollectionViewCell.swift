//
//  SearchResultNameCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit

class SearchResultNameCollectionViewCell: BaseCollectionViewCell {
    let nameView = UIView()
    let resultLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(nameView)
        nameView.addSubview(resultLabel)
    }
    
    override func configureView() {
        nameView.backgroundColor = .lightGray
        nameView.layer.cornerRadius = 12
        resultLabel.text = "result"
        resultLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        nameView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(nameView)
        }
    }
}
