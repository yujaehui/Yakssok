//
//  UIButton.Configuration+Extension.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit

extension UIButton.Configuration {
    static func calculate(image: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        config.image = UIImage(systemName: image, withConfiguration: imageConfig)
        config.imagePadding = 8
        config.imagePlacement = .all
        config.baseForegroundColor = .orange
        config.baseBackgroundColor = .clear
        return config
    }
}
