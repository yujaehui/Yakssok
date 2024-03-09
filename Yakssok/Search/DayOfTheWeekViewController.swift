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

class DayOfTheWeekViewController: BaseViewController {
    private let stackView = UIStackView()
    private var dayButtons = [UIButton]()
    let registrationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(stackView)
        view.addSubview(registrationButton)
    }
    
    override func configureView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for day in daysOfWeek {
            let button = makeButton(withTitle: day)
            stackView.addArrangedSubview(button)
            dayButtons.append(button)
        }
        
        registrationButton.setTitle("등록", for: .normal)
        registrationButton.backgroundColor = .lightGray
        registrationButton.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
    }
    
    private func makeButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            print("Tapped on day: \(title)")
        }
    }
    
    @objc private func registrationButtonClicked() {
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

