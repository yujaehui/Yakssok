//
//  TitleCollectionReusableView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

class TitleCollectionReusableView: BaseCollectionReusableView {
    let titleLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(16)
        }
    }
}
