//
//  BaseSheetViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/18/24.
//

import UIKit

class BaseSheetViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
        }
    }
}
