//
//  CalendarTableViewCell.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/19/24.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarTableViewCell: BaseTableViewCell {
    var passDate: ((Date) -> Void)?
    var passMoment: (() -> Void)?
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: Date())
        return label
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        return calendar
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(toggleButton)
        contentView.addSubview(calendar)
    }
    
    override func configureConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(16)
            make.height.equalTo(32)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(32)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(300)
            make.bottom.lessThanOrEqualTo(contentView)
        }
    }
    
    @objc private func tapToggleButton() {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
            self.toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.selectedDate ?? calendar.currentPage)
        } else {
            self.calendar.setScope(.month, animated: true)
            self.toggleButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.currentPage)
        }
        passMoment?()
    }
}

extension CalendarTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(bounds.height)
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        passDate?(date)
        if calendar.scope == .week {
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: date)
        } else {
            return
        }
    }
}
