//
//  ChartTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit
import DGCharts

class ChartTableViewCell: BaseTableViewCell {
    let chartView = CustomChartView()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 영양제 섭취 완료율"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(chartView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(subLabel)
    }
    
    override func configureConstraints() {
        chartView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(130)
            make.bottom.lessThanOrEqualTo(contentView)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(chartView.snp.centerY)
            make.leading.equalTo(chartView.snp.trailing).offset(16)
        }
    }
}
