//
//  SearchResultTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit

final class SearchResultTableViewCell: BaseTableViewCell {
    private let resultNameLabel: UILabel = {
        let label = CustomLabel(type: .titleBold)
        return label
    }()
    
    private let resultBrandLabel: UILabel = {
        let label = CustomLabel(type: .description)
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(resultNameLabel)
        contentView.addSubview(resultBrandLabel)
    }
    
    override func configureConstraints() {
        resultNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
        }
        
        resultBrandLabel.snp.makeConstraints { make in
            make.top.equalTo(resultNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(16)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }
    }
    
    func configureCell(_ data: Row, searchText: String) {
        resultNameLabel.attributedText = SearchManger.shared.changeSearchResultText(data.prdlstNm, changeText: searchText)
        resultBrandLabel.text = data.bsshNm
    }
}
