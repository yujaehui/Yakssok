//
//  ScheduleTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

final class ScheduleTableViewCell: BaseTableViewCell {
    var buttonAction: (() -> Void)?
    
    private let backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = CustomLabel(type: .descriptionGray)
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func checkButtonClicked() {
        buttonAction?()
    }
        
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
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(8)
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
    
    func configureCell(data: MySupplement, checkData: [CheckSupplement], checkTime: Date) {
        nameLabel.text = data.name
        amountLabel.text = "\(data.amount)개"
        
        let isChecked = checkData.contains {
            DateFormatterManager.shared.makeHeaderDateFormatter2(date: $0.time)  == DateFormatterManager.shared.makeHeaderDateFormatter2(date: checkTime)
            && $0.fk == data.pk
        }

        if isChecked {
            backView.backgroundColor = ColorStyle.point.withAlphaComponent(0.4)
            checkButton.configuration = .check(color: ColorStyle.point)
        } else {
            backView.backgroundColor = ColorStyle.grayBackground
            checkButton.configuration = .check(color: ColorStyle.grayImage)
        }
    }
    
    // 수정 전 코드
//    func configureCell(_ data: MySupplements) {
//        nameLabel.text = data.name
//        amountLabel.text = "\(data.amount)개"
//        backView.backgroundColor = data.isChecked ? ColorStyle.point.withAlphaComponent(0.4) : ColorStyle.grayBackground
//        checkButton.configuration = data.isChecked ? .check(color: ColorStyle.point) : .check(color: ColorStyle.grayImage)
//    }

}
