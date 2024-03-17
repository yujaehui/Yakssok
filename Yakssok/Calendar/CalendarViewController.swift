//
//  CalendarViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit
import FSCalendar
import DGCharts

final class CalendarViewController: BaseViewController {
    
    let viewModel = CalendarViewModel()
    
    enum Section: CaseIterable {
        case main
    }
    
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
    
    private let chartView = CustomChartView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        return tableView
    }()
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, [MySupplement]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    func bindData() {
        viewModel.outputGroupedDataDict.bind { value in
            self.chartView.configureView(total: value.flatMap { $0.1 }.count,
                                         checked: value.flatMap { $0.1 }.filter { $0.isChecked }.count)
            self.tableView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(headerLabel)
        view.addSubview(toggleButton)
        view.addSubview(calendar)
        view.addSubview(chartView)
        view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(300)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(150)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.outputGroupedDataDict.value.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.outputGroupedDataDict.value[section].0
        return DateFormatterManager.shared.makeHeaderDateFormatter2(date: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputGroupedDataDict.value[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
        cell.supplementLabel.text = viewModel.outputGroupedDataDict.value[indexPath.section].1[indexPath.row].name
        cell.backgroundColor = self.viewModel.outputGroupedDataDict.value[indexPath.section].1[indexPath.row].isChecked ? .green : .clear
        cell.buttonAction = {
            self.viewModel.repository.updateIsCompleted(pk: self.viewModel.outputGroupedDataDict.value[indexPath.section].1[indexPath.row].pk)
            self.chartView.configureView(total: self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }.count,
                                         checked: self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }.filter { $0.isChecked }.count)
            self.tableView.reloadData()
        }
        return cell
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.inputDidSelectTrigger.value = (date)
        if calendar.scope == .week {
            self.headerLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter(date: date)
        } else {
            return
        }
    }
}
