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
    let nameLabel = UILabel()
    let amountLabel = UILabel()
    let takeSwitch = UISwitch()
    let startDayLabel = UILabel()
    let cycleLabel = UILabel()
    let timeLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(amountLabel)
        contentView.addSubview(takeSwitch)
        contentView.addSubview(startDayLabel)
        contentView.addSubview(cycleLabel)
        contentView.addSubview(timeLabel)
    }
    
    override func configureView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 12
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 8
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(80)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        
        takeSwitch.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(8)
            make.centerY.equalTo(imageView.snp.centerY)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        startDayLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(20)
        }
        
        cycleLabel.snp.makeConstraints { make in
            make.top.equalTo(startDayLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(cycleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(20)
        }
    }
    
    func configureCell(_ itemIdentifier: MySupplement) {
        if let image = Helpers.shared.loadImageToDocument(fileName: "\(itemIdentifier.pk)") {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "pill")
        }
        nameLabel.text = itemIdentifier.name
        amountLabel.text = "1회 복용량 : \(itemIdentifier.amout)개"
        startDayLabel.text = "시작일 : " + DateFormatterManager.shared.convertformatDateToString(date: itemIdentifier.startDay)
        cycleLabel.text = "매주 " + itemIdentifier.cycleArray.joined(separator: ", ") + "마다"
        timeLabel.text = DateFormatterManager.shared.convertDateArrayToStringArray(dates: itemIdentifier.timeArray).joined(separator: " | ")
    }
}

