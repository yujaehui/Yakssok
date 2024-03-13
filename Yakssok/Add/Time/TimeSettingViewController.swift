//
//  TimeSettingViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit

class TimeSettingViewController: BaseViewController {
    var selectTimeList: (([Date]) -> Void)?
    
    let viewModel = TimeSettingViewModel()
    
    let titleLabel = UILabel()
    let addTimeButton = UIButton()
    let editButton = UIButton()
    let noticeLabel = UILabel()
    let timeTableView = UITableView()
    
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
        viewModel.addTimeButtonClicked.bind { [weak self] value in
            guard value != nil else { return }
            let vc = TimePickerViewController()
            vc.selectTime = { [weak self] value in
                self?.viewModel.inputSelectTime.value =  value
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.outputSelectTimeList.bind { [weak self] value in
            self?.viewModel.inputSelectTimeList.value = value
        }
        
        viewModel.outputSelectTimeStringList.bind { [weak self] value in
            self?.timeTableView.reloadData()
        }
        
        viewModel.outputTimeList.bind { [weak self] value in
            guard let value = value else { return }
            self?.selectTimeList?(value)
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
        viewModel.inputTimeList.value = viewModel.outputSelectTimeList.value
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
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        noticeLabel.text = "영양제별 권장 용법을 참고하여 복용시간을 설정해주세요."
        timeTableView.delegate = self
        timeTableView.dataSource = self
        timeTableView.register(TimeSettingTableViewCell.self, forCellReuseIdentifier: TimeSettingTableViewCell.identifier)
        timeTableView.rowHeight = UITableView.automaticDimension
        timeTableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    @objc func addTimeButtonClicked() {
        viewModel.addTimeButtonClicked.value = ()
    }
    
    @objc func editButtonClicked() {
        let shouldBeEdited = !timeTableView.isEditing
        timeTableView.setEditing(shouldBeEdited, animated: true)
        editButton.isSelected = shouldBeEdited
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
        return viewModel.outputSelectTimeStringList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeSettingTableViewCell.identifier, for: indexPath) as! TimeSettingTableViewCell
        cell.timeLabel.text = viewModel.outputSelectTimeStringList.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if viewModel.outputSelectTimeStringList.value.count > 1 {
            viewModel.outputSelectTimeStringList.value.remove(at: indexPath.row)
        } else {
           return // 나중에 알럿? 토스트? 처리 할 예정
        }
    }
}
