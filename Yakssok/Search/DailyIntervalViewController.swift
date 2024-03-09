//
//  DailyIntervalViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

enum PickerType: CaseIterable {
    case interval
    case number
    
    var intervals: [String] {
        switch self {
        case .interval: return ["일 간격", "주 간격", "월 간격"]
        default: return []
        }
    }
    
    var numbers: [[String]] {
        switch self {
        case .number: return [Array(1...365).map { String($0) }, Array(1...52).map { String($0) }, Array(1...12).map { String($0) }]
        default: return []
        }
    }
}

class DailyIntervalViewController: BaseViewController {
    
    let dailyIntervalPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        view.addSubview(dailyIntervalPickerView)
    }
    
    override func configureView() {
        dailyIntervalPickerView.delegate = self
        dailyIntervalPickerView.dataSource = self
    }
    
    override func configureConstraints() {
        dailyIntervalPickerView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DailyIntervalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PickerType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch PickerType.allCases[component] {
        case .interval:
            return PickerType.interval.intervals.count
        case .number:
            return PickerType.number.numbers[pickerView.selectedRow(inComponent: 0)].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch PickerType.allCases[component] {
        case .interval:
            return PickerType.interval.intervals[row]
        case .number:
            return PickerType.number.numbers[pickerView.selectedRow(inComponent: 0)][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch PickerType.allCases[component] {
        case .interval: pickerView.reloadComponent(1)
        case .number: return
        }
    }
}
