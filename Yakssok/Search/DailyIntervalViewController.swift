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
        case .interval: return ["일 간격", "주 간격", "개월 간격"]
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
    let registrationButton = UIButton()
    
    var selectDailyInterval: (([Int]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(dailyIntervalPickerView)
        view.addSubview(registrationButton)
    }
    
    override func configureView() {
        dailyIntervalPickerView.delegate = self
        dailyIntervalPickerView.dataSource = self
        
        registrationButton.setTitle("등록", for: .normal)
        registrationButton.backgroundColor = .lightGray
        registrationButton.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
    }
    
    @objc private func registrationButtonClicked() {
        selectDailyInterval?([dailyIntervalPickerView.selectedRow(inComponent: 0), dailyIntervalPickerView.selectedRow(inComponent: 1)])
        dismiss(animated: true)
    }
    
    override func configureConstraints() {
        dailyIntervalPickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(dailyIntervalPickerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(32)
        }
    }
}

extension DailyIntervalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PickerType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch PickerType.allCases[component] {
        case .interval: return PickerType.interval.intervals.count
        case .number: return PickerType.number.numbers[pickerView.selectedRow(inComponent: 0)].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch PickerType.allCases[component] {
        case .interval: return PickerType.interval.intervals[row]
        case .number: return PickerType.number.numbers[pickerView.selectedRow(inComponent: 0)][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch PickerType.allCases[component] {
        case .interval: pickerView.reloadComponent(1)
        case .number: return
        }
    }
}
