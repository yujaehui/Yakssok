//
//  DayIntervalViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/10/24.
//

import UIKit
import SnapKit

class DayIntervalViewController: BaseViewController {
    var selectDayInterval: (([String]) -> Void)?
    
    let viewModel = DayIntervalViewModel()
    
    let textField = UITextField()
    let registrationButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    func bindData() {
        viewModel.outputDayIntervalList.bind { [weak self] value in
            guard let value = value else { return }
            self?.textField.text = value.count > 0 ? value[0] : nil
            self?.selectDayInterval?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(registrationButton)
    }
    
    override func configureView() {
        textField.placeholder = "원하는 주기를 입력해주세요"
        
        registrationButton.setTitle("등록", for: .normal)
        registrationButton.backgroundColor = .lightGray
        registrationButton.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
    }
    
    @objc func registrationButtonClicked() {
        viewModel.inputDayInterval.value = textField.text
        dismiss(animated: true)
    }
    
    override func configureConstraints() {
        textField.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
    }
}
