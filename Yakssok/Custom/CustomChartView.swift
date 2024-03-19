//
//  CustomChartView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/17/24.
//

import UIKit
import DGCharts

class CustomChartView: PieChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView(total: 0, checked: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(total: Int, checked: Int) {
        let totalItems = total
        let checkedItems = checked
        
        let checkedEntry = PieChartDataEntry(value: Double(checkedItems), label: "")
        let uncheckedEntry = PieChartDataEntry(value: Double(totalItems - checkedItems), label: "")
        
        let dataSet = PieChartDataSet(entries: [uncheckedEntry, checkedEntry], label: "")
        dataSet.entryLabelColor = .clear
        dataSet.valueTextColor = .clear
        
        if checked != 0 {
            dataSet.colors = [UIColor.systemGray6, UIColor.systemOrange]
        } else {
            dataSet.colors = [UIColor.systemGray6]
        }
        
        if totalItems != 0 {
            let totalCheckedPercentage = checkedItems * 100 / totalItems
            centerText = "\(totalCheckedPercentage)%"
        } else {
            centerText = ""
        }
        
        holeRadiusPercent = 0.8
        drawCenterTextEnabled = true
        legend.enabled = false
        isUserInteractionEnabled = false
    
        data = PieChartData(dataSet: dataSet)
        
        animateChartWithCustomAnimation()
        notifyDataSetChanged()
    }
    
    private func animateChartWithCustomAnimation() {
        let duration = 1.0
        animate(xAxisDuration: duration, yAxisDuration: duration, easingOption: .easeInOutQuart)
        spin(duration: duration, fromAngle: 270, toAngle: -90, easingOption: .easeInOutQuart)
    }
    
}
