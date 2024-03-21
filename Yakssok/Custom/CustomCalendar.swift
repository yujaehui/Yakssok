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
        
        appearance.headerTitleFont = .boldSystemFont(ofSize: 18)
        appearance.headerTitleColor = .orange
        
        appearance.todayColor = .clear
        appearance.titleTodayColor = .black
        
        appearance.weekdayTextColor = .systemOrange
        appearance.selectionColor = .systemOrange
    }
}
