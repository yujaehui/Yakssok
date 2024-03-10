//
//  DayOfTheWeekCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import UIKit
import SnapKit

class DayOfTheWeekCollectionViewCell: BaseCollectionViewCell {
    let dayLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(dayLabel)
    }
    
    override func configureView() {
        dayLabel.backgroundColor = .brown
        dayLabel.textAlignment = .center
    }
    
    override func configureConstraints() {
        dayLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
}
