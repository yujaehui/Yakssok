//
//  CycleCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import UIKit
import SnapKit

final class CycleCollectionViewCell: BaseCollectionViewCell {
    private let dayLabel: UILabel = {
        let label = CustomLabel(type: .contentBold)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(dayLabel)
    }
    
    override func configureConstraints() {
        dayLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func configureCell(week: [String], day: String) {
        dayLabel.text = day
        dayLabel.backgroundColor = week.contains(where: {$0 == day}) ? ColorStyle.point : ColorStyle.grayBackground
    }
}
