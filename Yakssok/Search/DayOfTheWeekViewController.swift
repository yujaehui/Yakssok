//
//  DayOfTheWeekViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

import UIKit
import SnapKit

enum DayOfTheWeek: String, CaseIterable {
    case sunday = "일"
    case monday = "월"
    case tuesday = "화"
    case wednesday = "수"
    case thursday = "목"
    case friday = "금"
    case saturday = "토"
}

class DayOfTheWeekViewController: BaseViewController {
    let viewModel = DayOfTheWeekViewModel()
    
    let stackView = UIStackView()
    let sundayButton = UIButton()
    let mondayButton = UIButton()
    let tuesdayButton = UIButton()
    let wednesdayButton = UIButton()
    let thursdayButton = UIButton()
    let fridayButton = UIButton()
    let saturdayButton = UIButton()
    var dayButtons: [UIButton] {
        return [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton]
    }
    let registrationButton = UIButton()
        
    var selectDayOfTheWeek: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    func bindData() {
        viewModel.outputDayList.bind { [weak self] value in
            for button in self!.dayButtons {
                if value.contains(where: {$0 == button.title(for: .normal)}) {
                    button.setTitleColor(.systemRed, for: .normal)
                } else {
                    button.setTitleColor(.systemBlue, for: .normal)
                }
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(stackView)
        for button in dayButtons {
            stackView.addArrangedSubview(button)
        }
        view.addSubview(registrationButton)
    }
    
    override func configureView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        for (index, button) in dayButtons.enumerated() {
            button.setTitle(DayOfTheWeek.allCases[index].rawValue, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        }
        
        registrationButton.setTitle("등록", for: .normal)
        registrationButton.backgroundColor = .lightGray
        registrationButton.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        viewModel.inputDay.value = sender.title(for: .normal)
    }
    
    @objc private func registrationButtonClicked() {
        selectDayOfTheWeek?(viewModel.outputDayList.value)
        dismiss(animated: true)
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(32)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(32)
        }
    }
}

