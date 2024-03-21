//
//  BaseViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.background
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    func configureHierarchy() {}
    func configureView() {}
    func configureConstraints() {}
}
