//
//  BaseCollectionReusableView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
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
