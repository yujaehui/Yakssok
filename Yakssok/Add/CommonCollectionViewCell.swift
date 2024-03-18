//
//  CommonCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit

class CommonCollectionViewCell: BaseCollectionViewCell {
    let textLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(textLabel)
    }
    
    override func configureView() {
        backgroundColor = .systemGray6
        textLabel.clipsToBounds = true
        textLabel.layer.cornerRadius = 12
        textLabel.font = .boldSystemFont(ofSize: 18)
        textLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(contentView)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        textLabel.text = itemIdentifier.item
    }
}
