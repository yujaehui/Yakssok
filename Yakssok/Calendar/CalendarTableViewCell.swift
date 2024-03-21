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
    
    private lazy var calendar: FSCalendar = {
        let calendar = CustomCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.backgroundColor = .systemGray6
        calendar.select(Date())
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        return calendar
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: Date())
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.configuration = .toggle(image: "chevron.up")
        button.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
        return button
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(calendar)
        contentView.addSubview(headerLabel)
        contentView.addSubview(toggleButton)
    }
    
    override func configureConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(300)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.leading.equalTo(contentView).inset(32)
            make.height.equalTo(32)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView).inset(32)
            make.height.equalTo(32)
        }
    }
    
    @objc private func tapToggleButton() {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
            self.toggleButton.configuration = .toggle(image: "chevron.down")
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.selectedDate ?? calendar.currentPage)
        } else {
            self.calendar.setScope(.month, animated: true)
            self.toggleButton.configuration = .toggle(image: "chevron.up")
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
