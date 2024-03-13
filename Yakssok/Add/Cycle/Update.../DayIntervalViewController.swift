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
    let textStateLabel = UILabel()
    let registrationButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DayIntervalViewController viewDidLoad")
        bindData()
    }
    
    deinit {
        print("DayIntervalViewController deinit")
    }
    
    func bindData() {
        viewModel.outputStateText.bind { value in
            self.textStateLabel.text = value
        }
        
        viewModel.outputColor.bind { value in
            self.textStateLabel.textColor = value ? .systemBlue : .systemRed
            self.registrationButton.backgroundColor = value ? .systemBlue : .systemGray
        }
        
        viewModel.outputIsEnabled.bind { value in
            self.registrationButton.isEnabled = value
        }
        
        viewModel.outputDayIntervalList.bind { [weak self] value in
            guard let value = value else { return }
            self?.textField.text = value.count > 0 ? value[0] : nil
            self?.selectDayInterval?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(textStateLabel)
        view.addSubview(registrationButton)
    }
    
    override func configureView() {
        textField.placeholder = "원하는 주기를 입력해주세요"
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.backgroundColor = .lightGray
        
        textStateLabel.backgroundColor = .lightGray
        
        registrationButton.setTitle("등록", for: .normal)
        registrationButton.backgroundColor = .lightGray
        registrationButton.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
    }
    
    @objc func textFieldChanged() {
        viewModel.inputText.value = textField.text
    }
    
    @objc func registrationButtonClicked() {
        viewModel.inputDayInterval.value = textField.text
        dismiss(animated: true)
    }
    
    override func configureConstraints() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        textStateLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
    }
}
