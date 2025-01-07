//
//  StartDayViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import FSCalendar

final class StartDayViewController: BaseViewController {
    var selectDate: ((Date) -> Void)?
    
    let viewModel = StartDayViewModel()
    
    private lazy var startDayPicker: FSCalendar = {
        let calendar = CustomCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        return calendar
    }()
    
    private lazy var registrationButton: UIButton = {
       let button = UIButton()
        button.configuration = .registration(title: "등록")
        button.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("StartDayViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("StartDayViewController viewDidLoad")
        setNav()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputDate.bind { [weak self] value in
            guard let value = value else { return }
            self?.startDayPicker.select(value)
            self?.selectDate?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(startDayPicker)
        view.addSubview(registrationButton)
    }
    
    override func configureConstraints() {
        startDayPicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(registrationButton.snp.top)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func registrationButtonClicked() {
        viewModel.inputDate.value = startDayPicker.selectedDate
        dismiss(animated: true)
    }
}

extension StartDayViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
}

extension StartDayViewController: FSCalendarDelegate, FSCalendarDataSource {
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
}
