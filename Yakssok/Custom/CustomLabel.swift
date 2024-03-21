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
        case titlePoint
        case titleBold
        case titleBoldPoint
        
        case content
        case contentPoint
        case contentGray
        case contentBold
        case contentBoldPoint
        case contentBoldGray
        
        case description
        case descriptionPoint
        case descriptionGray
        case descriptionBold
        case descriptionBoldPoint
        case descriptionBoldGray
        
        var font: UIFont {
            switch self {
            case .title, .titlePoint: FontStyle.title
            case .titleBold, .titleBoldPoint: FontStyle.titleBold
            case .content, .contentPoint, .contentGray: FontStyle.content
            case .contentBold, .contentBoldPoint, .contentBoldGray: FontStyle.contentBold
            case .description, .descriptionPoint, .descriptionGray: FontStyle.description
            case .descriptionBold, .descriptionBoldPoint, .descriptionBoldGray: FontStyle.descriptionBold
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .title, .titleBold: ColorStyle.text
            case .titlePoint, .titleBoldPoint: ColorStyle.point
            case .content, .contentBold: ColorStyle.text
            case .contentPoint, .contentBoldPoint: ColorStyle.point
            case .contentGray, .contentBoldGray: ColorStyle.grayText
            case .description, .descriptionBold: ColorStyle.text
            case .descriptionPoint, .descriptionBoldPoint: ColorStyle.point
            case .descriptionGray, .descriptionBoldGray: ColorStyle.grayText
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
