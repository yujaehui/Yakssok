//
//  ChartTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import DGCharts

class ChartTableViewCell: BaseTableViewCell {
    let chartView = CustomChartView()

    override func configureHierarchy() {
        contentView.addSubview(chartView)
    }
    
    override func configureConstraints() {
        chartView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(150)
            make.bottom.lessThanOrEqualTo(contentView)
        }
    }
}
