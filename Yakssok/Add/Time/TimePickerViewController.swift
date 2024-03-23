//
//  TimePickerViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

final class TimePickerViewController: BaseViewController {
    var selectTime: ((Date) -> Void)?
    
    let viewModel = TimePickerViewModel()
    
    private let timePicker = UIDatePicker()
    
    deinit {
        print("TimePickerViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimePickerViewController viewDidLoad")
        bindData()
        setNav()
    }
    
    private func bindData() {
        viewModel.outputTime.bind { [weak self] value in
            guard let value = value else { return }
            self?.selectTime?(value)
        }
    }
    
    private func setNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
    }
    
    @objc private func leftBarButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBarButtonItemClicked() {
        viewModel.inputTime.value = timePicker.date
        navigationController?.popViewController(animated: true)
    }

    override func configureHierarchy() {
        view.addSubview(timePicker)
    }
    
    override func configureView() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
    }
    
    override func configureConstraints() {
        timePicker.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
