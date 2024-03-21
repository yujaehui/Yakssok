//
//  CustomLabel.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/21/24.
//

import UIKit

class CustomLabel: UILabel {
    enum labelType {
        case title
        case titleColor
        case titleBold
        case titleBoldColor
        case content
        case contentColor
        case contentBold
        case contentBoldColor
        case description
        case descriptionColor
        case descriptionBold
        case descriptionBoldColor
        
        var font: UIFont {
            switch self {
            case .title, .titleColor: FontStyle.title
            case .titleBold, .titleBoldColor: FontStyle.titleBold
            case .content, .contentColor: FontStyle.content
            case .contentBold, .contentBoldColor: FontStyle.contentBold
            case .description, .descriptionColor: FontStyle.description
            case .descriptionBold, .descriptionBoldColor: FontStyle.descriptionBold
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .title, .titleBold: ColorStyle.text
            case .titleColor, .titleBoldColor: ColorStyle.point
            case .content, .contentBold: ColorStyle.text
            case .contentColor, .contentBoldColor: ColorStyle.point
            case .description, .descriptionBold: ColorStyle.grayText
            case .descriptionColor, .descriptionBoldColor: ColorStyle.point
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: labelType) {
        self.init(frame: .zero)
        configureView(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ type: labelType) {
        textColor = type.textColor
        font = type.font
    }
}
