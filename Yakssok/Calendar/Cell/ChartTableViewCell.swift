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
    
    func configureCell(allData: [MySupplement], checkData: [CheckSupplement]) {
        let matchedCheckData = checkData.filter { checkItem in
            allData.contains { supplement in
                // updateDay 구간을 기준으로 현재 cycleArray와 timeArray 결정
                let cycleArray: [String]
                let timeArray: [Date]

                if supplement.history.isEmpty {
                    // history가 없는 경우 기본 cycleArray와 timeArray 사용
                    cycleArray = supplement.cycleArray
                    timeArray = supplement.timeArray
                } else {
                    // history가 있는 경우 updateDay 구간 확인
                    var matchedCycleArray: [String]?
                    var matchedTimeArray: [Date]?
                    
                    for (index, history) in supplement.history.enumerated() {
                        let previousUpdateDay = index == 0 ? supplement.startDay : supplement.history[index - 1].updateDay
                        let currentUpdateDay = history.updateDay
                        
                        if previousUpdateDay <= checkItem.date && checkItem.date < currentUpdateDay {
                            matchedCycleArray = history.cycleArray
                            matchedTimeArray = history.timeArray
                            break
                        }
                    }

                    // 마지막 updateDay 이후의 구간 처리
                    if matchedCycleArray == nil, let lastUpdateDay = supplement.history.last?.updateDay, lastUpdateDay <= checkItem.date {
                        matchedCycleArray = supplement.cycleArray
                        matchedTimeArray = supplement.timeArray
                    }

                    cycleArray = matchedCycleArray ?? []
                    timeArray = matchedTimeArray ?? []
                }

                // 필터링 조건
                return cycleArray.contains(DateFormatterManager.shared.dayOfWeek(from: checkItem.date)) &&
                       timeArray.contains(where: { Calendar.current.isDate($0, equalTo: checkItem.time, toGranularity: .minute) }) &&
                       supplement.pk == checkItem.fk
            }
        }
        
        subLabel.text = "총 \(allData.count)개 중에 \(matchedCheckData.count)개 섭취 완료!"
        chartView.configureView(total: allData.count, checked: matchedCheckData.count)
    }

    
    // 수정 전 코드
//    func configureCell(_ data: [MySupplements]) {
//        subLabel.text = "총 \(data.count)개 중에 \(data.filter { $0.isChecked }.count)개 섭취 완료!"
//        chartView.configureView(total: data.count, checked: data.filter { $0.isChecked }.count)
//    }
}
