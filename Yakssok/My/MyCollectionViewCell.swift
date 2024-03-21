//
//  MyCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

class MyCollectionViewCell: BaseCollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let dateInfoLabel: UILabel = {
        let label = CustomLabel(type: .description)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        label.numberOfLines = 1
        return label
    }()
    
    
    let countStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let countImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.badge.checkmark")
        imageView.tintColor = .black
        return imageView
    }()
    
    let countInfoLabel: UILabel = {
        let label = CustomLabel(type: .description)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dateInfoLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countStackView)
        countStackView.addArrangedSubview(countImageView)
        countStackView.addArrangedSubview(countInfoLabel)
    }
    
    override func configureView() {
        layer.cornerRadius = 12
        layer.shadowColor = ColorStyle.grayImage.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(80)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.centerY)
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).inset(16)
        }
    }
    
    func configureCell(_ itemIdentifier: MySupplement) {
        if let image = Helpers.shared.loadImageToDocument(fileName: "\(itemIdentifier.pk)") {
            imageView.image = image
        } else {
            imageView.image = ImageStyle.supplement
        }
        if itemIdentifier.cycleArray.count == DayOfTheWeek.allCases.count {
            dateInfoLabel.text = DateFormatterManager.shared.convertformatDateToString2(date: itemIdentifier.startDay) + " | " + "\(itemIdentifier.period)개월" + " | " + "매일"
        } else {
            dateInfoLabel.text = DateFormatterManager.shared.convertformatDateToString2(date: itemIdentifier.startDay) + " | " + "\(itemIdentifier.period)개월" + " | " + itemIdentifier.cycleArray.joined(separator: ", ")
        }
        
        nameLabel.text = itemIdentifier.name
        countInfoLabel.text = "하루 \(itemIdentifier.timeArray.count)번, \(itemIdentifier.amount)개씩 복용"
    }
}

