//
//  EmptyTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit

class EmptyTableViewCell: BaseTableViewCell {
    let emptyLabel: UILabel = {
       let label = UILabel()
        label.text = "오늘은 복용할 영양제가 없어요!"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(emptyLabel)
    }
    
    override func configureConstraints() {
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.height.equalTo(130)
            make.bottom.lessThanOrEqualTo(contentView)
        }
    }
}
