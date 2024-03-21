//
//  ScheduleTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

class ScheduleTableViewCell: BaseTableViewCell {
    let backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = CustomLabel(type: .description)
        return label
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var buttonAction: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonAction = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(backView)
        backView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(amountLabel)
        backView.addSubview(checkButton)
    }
    
    override func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(backView).inset(16)
            make.trailing.equalTo(checkButton.snp.leading).offset(-16)
            make.centerY.equalTo(backView)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(backView).inset(8)
            make.bottom.lessThanOrEqualTo(backView).inset(8)
            make.trailing.equalTo(backView).inset(16)
            make.size.equalTo(60)
        }
    }
    
    @objc func checkButtonClicked() {
        buttonAction?()
    }
    
    func configureCell(_ data: MySupplements) {
        nameLabel.text = data.name
        amountLabel.text = "\(data.amount)개"
        backView.backgroundColor = data.isChecked ? ColorStyle.point.withAlphaComponent(0.8) : ColorStyle.grayBackground
        checkButton.configuration = data.isChecked ? .check(color: ColorStyle.point) : .check(color: .lightGray)
    }
}
