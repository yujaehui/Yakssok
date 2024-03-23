//
//  PeriodViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/18/24.
//

import UIKit
import SnapKit

final class PeriodViewController: BaseViewController {
    var selectPeriod: ((Int) -> Void)?
    
    let viewModel = PeriodViewModel()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var registrationButton: UIButton = {
       let button = UIButton()
        button.configuration = .registration(title: "등록")
        button.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
    }
    
    func bindData() {
        viewModel.outputPeriod.bind { [weak self] value in
            guard let value = value else { return }
            print("@@@", value)
            self?.pickerView.selectRow(value-1, inComponent: 0, animated: true)
            self?.selectPeriod?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(pickerView)
        view.addSubview(registrationButton)
    }
    
    override func configureConstraints() {
        pickerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(registrationButton.snp.top)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func registrationButtonClicked() {
        print(pickerView.selectedRow(inComponent: 0) + 1)
        viewModel.inputPeriod.value = pickerView.selectedRow(inComponent: 0) + 1
        dismiss(animated: true)
    }
}

extension PeriodViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
}

extension PeriodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Array(1...12)[row])"
    }
}
