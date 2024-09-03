//
//  MyCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/16/24.
//

import UIKit
import SnapKit

final class MyCollectionViewCell: BaseCollectionViewCell {
    private let imageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        return imageView
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let cycleLabel: CustomLabel = {
        let label = CustomLabel(type: .descriptionGray)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        label.numberOfLines = 1
        return label
    }()
    
    private let countStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let countImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = ImageStyle.clock
        imageView.tintColor = ColorStyle.point
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = CustomLabel(type: .content)
        label.numberOfLines = 2
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(cycleLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countStackView)
        countStackView.addArrangedSubview(countImageView)
        countStackView.addArrangedSubview(countLabel)
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
        if let image = ImageDocumentManager.shared.loadImageToDocument(fileName: "\(itemIdentifier.pk)") {
            imageView.image = image
        } else {
            imageView.image = ImageStyle.supplement
        }
        
        if itemIdentifier.cycleArray.count == DayOfTheWeek.allCases.count {
            cycleLabel.text = "매일"
        } else {
            cycleLabel.text = itemIdentifier.cycleArray.joined(separator: ", ")
        }
        
        nameLabel.text = itemIdentifier.name
        
        if itemIdentifier.stock != "설정 안함" {
            countLabel.text = "하루 \(itemIdentifier.timeArray.count)번, \(itemIdentifier.amount)개씩 복용\n남은 영양제 수: \(itemIdentifier.stock)개"
        } else {
            countLabel.text = "하루 \(itemIdentifier.timeArray.count)번, \(itemIdentifier.amount)개씩 복용"
        }
    }
}

