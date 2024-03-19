//
//  CommonCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit

class CommonCollectionViewCell: BaseCollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(textLabel)
    }
    
    override func configureConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(44)
        }
    }
    
    func configureCell(_ itemIdentifier: SectionItem) {
        textLabel.text = itemIdentifier.item
    }
}
