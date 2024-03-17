//
//  StartDaySettingViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import FSCalendar

final class StartDaySettingViewController: BaseSheetViewController {
    var selectDate: ((Date) -> Void)?
    
    let viewModel = StartDayViewModel()
    
    private let startDayPicker = FSCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("StartDaySettingViewController viewDidLoad")
        setNav()
        setToolBar()
        bindData()
    }
    
    deinit {
        print("StartDaySettingViewController deinit")
    }
    
    private func bindData() {
        viewModel.outputDate.bind { [weak self] value in
            guard let value = value else { return }
            self?.startDayPicker.select(value)
            self?.selectDate?(value)
        }
    }
    
    private func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    private func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc private func registrationButtonClicked() {
        viewModel.inputDate.value = startDayPicker.selectedDate
        dismiss(animated: true)        
    }
    
    override func configureHierarchy() {
        view.addSubview(startDayPicker)
    }
    
    override func configureView() {
        startDayPicker.delegate = self
        startDayPicker.dataSource = self
        startDayPicker.locale = Locale(identifier: "ko_KR")
        startDayPicker.appearance.headerDateFormat = "yyyy년 M월"
    }
    
    override func configureConstraints() {
        startDayPicker.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension StartDaySettingViewController: FSCalendarDelegate, FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
