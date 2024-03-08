//
//  SearchDetailViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/8/24.
//

import UIKit
import SnapKit

enum SearchDetailSection: String, CaseIterable {
    case searchDetailMain
    case alarmSetting
}

enum AlarmSettingCell: String, CaseIterable {
    case startDate
    case cycle
}

class SearchDetailViewController: BaseViewController {
    let searchDetailTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(searchDetailTableView)
    }
    
    override func configureView() {
        searchDetailTableView.delegate = self
        searchDetailTableView.dataSource = self
        searchDetailTableView.register(SearchDetailMainTableViewCell.self, forCellReuseIdentifier: SearchDetailMainTableViewCell.identifier)
        searchDetailTableView.register(AlaramSettingTableViewCell.self, forCellReuseIdentifier: AlaramSettingTableViewCell.identifier)
        searchDetailTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        searchDetailTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SearchDetailSection.allCases[section] {
        case .searchDetailMain: return 1
        case .alarmSetting: return AlarmSettingCell.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SearchDetailSection.allCases[indexPath.section] {
        case .searchDetailMain:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailMainTableViewCell.identifier, for: indexPath) as! SearchDetailMainTableViewCell
            return cell
        case .alarmSetting:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlaramSettingTableViewCell.identifier, for: indexPath) as! AlaramSettingTableViewCell
            return cell
        }
    }
}
