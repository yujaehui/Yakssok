//
//  CalendarViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit

final class CalendarViewController: BaseViewController {
    
    let viewModel = CalendarViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: ChartTableViewCell.identifier)
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "calendar"
        case 1: return "chart"
        default:
            let date = viewModel.outputGroupedDataDict.value[section - 2].0
            return DateFormatterManager.shared.makeHeaderDateFormatter2(date: date)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        default: return viewModel.outputGroupedDataDict.value[section - 2].1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
            cell.passDate = { value in
                self.viewModel.inputDidSelectTrigger.value = value
            }
            cell.passMoment = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as! ChartTableViewCell
            cell.chartView.configureView(total: self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }.count,
                                         checked: self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }.filter { $0.isChecked }.count)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
            cell.supplementLabel.text = viewModel.outputGroupedDataDict.value[indexPath.section - 2].1[indexPath.row].name
            cell.backgroundColor = self.viewModel.outputGroupedDataDict.value[indexPath.section - 2].1[indexPath.row].isChecked ? .green : .clear
            cell.buttonAction = {
                self.viewModel.repository.updateIsCompleted(pk: self.viewModel.outputGroupedDataDict.value[indexPath.section - 2].1[indexPath.row].pk)

                self.tableView.reloadData()
            }
            return cell
        }
    }
}


