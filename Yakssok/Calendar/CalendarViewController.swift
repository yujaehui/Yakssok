//
//  CalendarViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarViewController: BaseViewController {
    let calendar = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureHierarchy() {
        view.addSubview(calendar)
    }
    
    override func configureView() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "yyyy년 M월"
    }
    
    override func configureConstraints() {
        calendar.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}
