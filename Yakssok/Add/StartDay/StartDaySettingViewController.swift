//
//  StartDaySettingViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import FSCalendar

final class StartDaySettingViewController: BaseViewController {
    var selectDate: ((Date) -> Void)?
    
    let viewModel = StartDayViewModel()
    
    private lazy var startDayPicker: FSCalendar = {
        let calendar = CustomCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        return calendar
    }()
    
    deinit {
        print("StartDaySettingViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("StartDaySettingViewController viewDidLoad")
        setNav()
        setToolBar()
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
    }
    
    override func configureConstraints() {
        startDayPicker.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension StartDaySettingViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    private func setToolBar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .systemOrange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc private func registrationButtonClicked() {
        viewModel.inputDate.value = startDayPicker.selectedDate
        dismiss(animated: true)
    }
}

extension StartDaySettingViewController: FSCalendarDelegate, FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
