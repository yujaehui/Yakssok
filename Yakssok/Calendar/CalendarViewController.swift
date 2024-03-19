//
//  CalendarViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

enum SectionType: CaseIterable {
    case calendar
    case chart
    case schedule
}

final class CalendarViewController: BaseViewController {
    
    let viewModel = CalendarViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: ChartTableViewCell.identifier)
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    func bindData() {
        viewModel.outputGroupedDataDict.bind { value in
            self.tableView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.outputGroupedDataDict.value.count + 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch SectionType.allCases[section] {
        case .calendar: return nil
        case .chart: return nil
        case .schedule:
            let view = ScheduleHeaderView()
            let date = viewModel.outputGroupedDataDict.value[section - 2].0
            view.timeLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter2(date: date)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .calendar: return 1
        case .chart: return 1
        case .schedule: return viewModel.outputGroupedDataDict.value[section - 2].1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionType.allCases[indexPath.section] {
        case .calendar:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
            cell.passDate = { value in
                self.viewModel.inputDidSelectTrigger.value = value
            }
            cell.passMoment = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        case .chart:
            if self.viewModel.outputGroupedDataDict.value.flatMap({ $0.1 }).count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as! ChartTableViewCell
                let data = self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }
                cell.configureCell(data)
                return cell
            }
        case .schedule:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
            let data = viewModel.outputGroupedDataDict.value[indexPath.section - 2].1[indexPath.row]
            cell.configureCell(data)
            cell.buttonAction = {
                self.viewModel.repository.updateIsCompleted(pk: self.viewModel.outputGroupedDataDict.value[indexPath.section - 2].1[indexPath.row].pk)
                self.tableView.reloadData()
            }
            return cell
        }
    }
}


