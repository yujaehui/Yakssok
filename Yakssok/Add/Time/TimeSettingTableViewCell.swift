//
//  TimeSettingTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

final class TimeSettingTableViewCell: BaseTableViewCell {
    var passMoment: (() -> Void)?
    
    private let timeLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        return label
    }()
    
    private let modifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = ColorStyle.grayImage
        return imageView
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(modifyImageView)
    }
    
    override func configureConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        
        modifyImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
            make.size.equalTo(25)
        }
    }
    
    func configureCell(_ data: String) {
        timeLabel.text = data
    }
}
