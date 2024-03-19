//
//  PeriodViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/18/24.
//

import UIKit
import SnapKit

class PeriodViewController: BaseViewController {
    var selectPeriod: ((Int) -> Void)?
    
    let viewModel = PeriodViewModel()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setToolBar()
        bindData()
    }
    
    func bindData() {
        viewModel.outputPeriod.bind { [weak self] value in
            guard let value = value else { return }
            self?.selectPeriod?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(pickerView)
    }
    
    override func configureConstraints() {
        pickerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension PeriodViewController {
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
        print(pickerView.selectedRow(inComponent: 0) + 1)
        viewModel.inputPeriod.value = pickerView.selectedRow(inComponent: 0) + 1
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
