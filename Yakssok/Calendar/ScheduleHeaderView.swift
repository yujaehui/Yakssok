//
//  ScheduleHeaderView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit

class ScheduleHeaderView: BaseView {
    let timeLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(timeLabel)
    }
    
    override func configureConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(4)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
    }
}
