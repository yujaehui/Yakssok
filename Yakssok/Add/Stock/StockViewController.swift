//
//  StockViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 9/1/24.
//

import UIKit
import SnapKit

class StockViewController: BaseViewController {
    var selectStock: ((String) -> Void)?
    
    let viewModel = StockViewModel()
    
    private let stockLabel: CustomLabel = {
        let label = CustomLabel(type: .descriptionGray)
        label.text = "해당 영양제의 개수가 얼마 남지 않았을 때 알려드립니다."
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var stockTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "해당 영양제의 남은 개수를 입력해주세요."
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(stockTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.configuration = .registration(title: "등록")
        button.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("StockViewController", #function)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setDefaultIfEmpty(stockTextField)
    }
    
    private func bindData() {
        viewModel.outputStock.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            if value != "설정 안함" {
                stockTextField.text = value
            }
            self.selectStock?(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(stockLabel)
        view.addSubview(stockTextField)
        view.addSubview(registrationButton)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.registrationButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight + 8)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.registrationButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func configureConstraints() {
        stockLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        stockTextField.snp.makeConstraints { make in
            make.top.equalTo(stockLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func stockTextFieldChanged() {
        if let text = stockTextField.text?.replacingOccurrences(of: ",", with: ""), let number = Int(text) {
            if number > 50000 {
                stockTextField.text = NumberFormatterManager.shared.formatNumber(50000)
                animateTextField()
            } else {
                stockTextField.text = NumberFormatterManager.shared.formatNumber(number)
            }
        }
    }
    
    @objc private func registrationButtonClicked() {
        let stockValue = stockTextField.text?.isEmpty == true ? "설정 안함" : stockTextField.text
        viewModel.inputStock.value = stockValue
        dismiss(animated: true)
    }
    
    private func animateTextField() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        animation.duration = 0.4
        stockTextField.layer.add(animation, forKey: "shake")
    }
    
    private func setDefaultIfEmpty(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            textField.text = "설정 안함"
        }
    }
}

// MARK: NAV
extension StockViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        setDefaultIfEmpty(stockTextField)
        dismiss(animated: true)
    }
}

