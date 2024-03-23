//
//  CommonCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit

final class CommonCollectionViewCell: BaseCollectionViewCell {
    private let textLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
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
