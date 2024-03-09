//
//  TimeSettingViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class TimeSettingViewController: BaseViewController {
    let viewModel = TimeSettingViewModel()
    
    let titleLabel = UILabel()
    let addTimeButton = UIButton()
    let editButton = UIButton()
    let noticeLabel = UILabel()
    let timeTableView = UITableView()
    
    var selectTimeList: (([String]) -> Void)?
    
    deinit {
        print("TimeSettingViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimeSettingViewController viewDidLoad")
        bindData()
        setNav()
        setToolBar()
    }
    
    func bindData() {
        viewModel.outputSelectTime.bind { [weak self] value in
            guard let value = value else { return }
            self?.viewModel.inputTimeList.value.append(value)
            self?.viewModel.inputTimeList.value.sort()
            self?.timeTableView.reloadData()
        }
    }
    
    func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc func registrationButtonClicked() {
        selectTimeList?(viewModel.outputTimeList.value) // ⭐️
        dismiss(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(addTimeButton)
        view.addSubview(editButton)
        view.addSubview(noticeLabel)
        view.addSubview(timeTableView)
    }
    
    override func configureView() {
        titleLabel.text = "복용시간"
        addTimeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTimeButton.setTitle("시간추가", for: .normal)
        addTimeButton.setTitleColor(.systemBlue, for: .normal)
        addTimeButton.addTarget(self, action: #selector(addTimeButtonClicked), for: .touchUpInside)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.setTitle("편집", for: .normal)
        editButton.setTitleColor(.systemBlue, for: .normal)
        noticeLabel.text = "영양제별 권장 용법을 참고하여 복용시간을 설정해주세요."
        timeTableView.delegate = self
        timeTableView.dataSource = self
        timeTableView.register(TimeSettingTableViewCell.self, forCellReuseIdentifier: TimeSettingTableViewCell.identifier)
        timeTableView.rowHeight = UITableView.automaticDimension
        timeTableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    @objc func addTimeButtonClicked() {
        let vc = TimePickerViewController()
        vc.selectTime = { [weak self] value in
            self?.viewModel.inputSelectTime.value = DateFormatterManager.shared.formatTimeToString(time: value)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        addTimeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(addTimeButton.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        timeTableView.snp.makeConstraints { make in
            make.top.equalTo(noticeLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension TimeSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.inputTimeList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeSettingTableViewCell.identifier, for: indexPath) as! TimeSettingTableViewCell
        cell.timeLabel.text = viewModel.inputTimeList.value[indexPath.row]
        return cell
    }
    
    
}
