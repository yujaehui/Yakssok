//
//  StartDaySettingViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import FSCalendar

class StartDaySettingViewController: BaseViewController {
    let startDayPicker = FSCalendar()
    
    var selectDate: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setToolBar()
    }
    
    func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc func registrationButtonClicked() {
        guard let date = startDayPicker.selectedDate else { return }
        selectDate?(date)
        dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(startDayPicker)
    }
    
    override func configureView() {
        startDayPicker.locale = Locale(identifier: "ko_KR")
        startDayPicker.appearance.headerDateFormat = "yyyy년 M월"
    }
    
    override func configureConstraints() {
        startDayPicker.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
