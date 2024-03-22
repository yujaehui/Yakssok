//
//  ChartTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit
import DGCharts

final class ChartTableViewCell: BaseTableViewCell {
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
        let label = CustomLabel(type: .titleBold)
        label.text = "오늘의 영양제 섭취 완료율"
        return label
    }()
    
    let subLabel: UILabel = {
        let label = CustomLabel(type: .contentGray)
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
            make.bottom.lessThanOrEqualTo(contentView)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(130)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(chartView.snp.trailing).offset(16)
            make.centerY.equalTo(chartView.snp.centerY)
        }
    }
    
    func configureCell(_ data: [MySupplements]) {
        subLabel.text = "총 \(data.count)개 중에 \(data.filter { $0.isChecked }.count)개 섭취 완료!"
        chartView.configureView(total: data.count, checked: data.filter { $0.isChecked }.count)
    }
}
