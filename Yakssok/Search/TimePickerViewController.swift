//
//  TimePickerViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class TimePickerViewController: BaseViewController {
    let timePicker = UIDatePicker()
    
    var selectTime: ((Date) -> Void)?
    
    deinit {
        print("TimePickerViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimePickerViewController viewDidLoad")
        setNav()
    }
    
    func setNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItemClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
    }
    
    @objc func leftBarButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItemClicked() {
        selectTime?(timePicker.date)
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
