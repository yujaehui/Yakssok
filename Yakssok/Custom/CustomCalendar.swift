//
//  CustomCalendar.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import FSCalendar

class CustomCalendar: FSCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        clipsToBounds = true
        layer.cornerRadius = 12
        
        locale = Locale(identifier: "ko_KR")
        
        placeholderType = .none
        
        appearance.headerTitleFont = FontStyle.titleBold
        appearance.headerTitleColor = ColorStyle.point
        
        appearance.todayColor = ColorStyle.clear
        appearance.titleTodayColor = ColorStyle.text
        
        appearance.weekdayTextColor = ColorStyle.point
        appearance.selectionColor = ColorStyle.point
    }
}
