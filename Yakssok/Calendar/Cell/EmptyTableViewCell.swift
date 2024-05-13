//
//  EmptyTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit

final class EmptyTableViewCell: BaseTableViewCell {
    let emptyLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        label.text = "오늘은 복용할 영양제가 없어요!"
        label.textAlignment = .center
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(emptyLabel)
    }
    
    override func configureConstraints() {
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(contentView)
            make.height.equalTo(130)
            make.centerX.equalTo(contentView)
        }
    }
}
