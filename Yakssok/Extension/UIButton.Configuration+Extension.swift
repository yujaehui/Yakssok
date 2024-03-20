//
//  UIButton.Configuration+Extension.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit

extension UIButton.Configuration {
    static func basic(image: String) -> Self {
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        config.image = UIImage(systemName: image, withConfiguration: imageConfig)
        config.imagePadding = 8
        config.imagePlacement = .all
        config.baseForegroundColor = .orange
        config.baseBackgroundColor = .clear
        return config
    }
    
    static func toggle(image: String) -> Self {
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        config.image = UIImage(systemName: image, withConfiguration: imageConfig)
        config.imagePadding = 8
        config.imagePlacement = .all
        config.baseForegroundColor = .orange
        config.baseBackgroundColor = .clear
        return config
    }
    
    static func check(color: UIColor) -> Self {
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        config.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
        config.imagePadding = 8
        config.imagePlacement = .all
        config.baseForegroundColor = color
        config.baseBackgroundColor = .clear
        return config
    }
    
    static func timeSetting(image: String, title: String) -> Self {
        var config = UIButton.Configuration.filled()
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .boldSystemFont(ofSize: 18)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        config.image = UIImage(systemName: image, withConfiguration: imageConfig)
        config.imagePadding = 8
        config.imagePlacement = .leading
        
        config.baseForegroundColor = .orange
        config.baseBackgroundColor = .clear
        config.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return config
    }
    
    static func registration(title: String) -> Self {
        var config = UIButton.Configuration.filled()
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .boldSystemFont(ofSize: 18)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemOrange
        config.cornerStyle = .large
        return config
    }
}
