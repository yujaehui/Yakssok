//
//  MyCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

class MyCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    let stackView = UIStackView()
    let dateInfoLabel = UILabel()
    let nameLabel = UILabel()
    let countStackView = UIStackView()
    let countImageView = UIImageView()
    let countInfoLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dateInfoLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countStackView)
        countStackView.addArrangedSubview(countImageView)
        countStackView.addArrangedSubview(countInfoLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
    }
    
    override func configureView() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        dateInfoLabel.textColor = .systemGray
        dateInfoLabel.font = .systemFont(ofSize: 14)
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.numberOfLines = 1
        countImageView.image = UIImage(systemName: "clock.badge.checkmark")
        countImageView.tintColor = .black
        countInfoLabel.font = .systemFont(ofSize: 14)
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        
        countStackView.axis = .horizontal
        countStackView.alignment = .center
        countStackView.distribution = .fill
        countStackView.spacing = 8
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
            imageView.image = UIImage(systemName: "pill")
        }
        if itemIdentifier.cycleArray.count == DayOfTheWeek.allCases.count {
            dateInfoLabel.text = DateFormatterManager.shared.convertformatDateToString2(date: itemIdentifier.startDay) + " | " + "\(itemIdentifier.period)개월" + " | " + "매일"
        } else {
            dateInfoLabel.text = DateFormatterManager.shared.convertformatDateToString2(date: itemIdentifier.startDay) + " | " + "\(itemIdentifier.period)개월" + " | " + itemIdentifier.cycleArray.joined(separator: ", ")
        }
        
        nameLabel.text = itemIdentifier.name
        countInfoLabel.text = "하루 \(itemIdentifier.timeArray.count)번, \(itemIdentifier.amout)개씩 복용"
    }
}

