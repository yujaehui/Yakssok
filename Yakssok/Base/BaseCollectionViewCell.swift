//
//  BaseCollectionViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorStyle.background
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {}
    func configureView() {}
    func configureConstraints() {}
}
