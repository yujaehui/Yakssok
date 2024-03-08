//
//  TitleCollectionReusableView.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit

class TitleCollectionReusableView: BaseCollectionReusableView {
    let titleLabel = UILabel()
    let addButton = UIButton()
    var buttonAction: (() -> Void)?
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(addButton)
    }
    
    override func configureView() {
        backgroundColor = .yellow
        titleLabel.text = "title"
        addButton.backgroundColor = .orange
        addButton.setTitle("add", for: .normal)
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.titleLabel?.textAlignment = .right
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    @objc func addButtonClicked() {
        print(#function)
        buttonAction?()
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(16)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(16)
        }
        
    }
}
