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
    
    private lazy var addTimeButton: UIButton = {
        let button = UIButton()
        button.configuration = .timeSetting(image: "plus", title: "시간추가")
        button.addTarget(self, action: #selector(addTimeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.configuration = .timeSetting(image: "square.and.pencil", title: "편집")
        button.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeSettingTableViewCell.self, forCellReuseIdentifier: TimeSettingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "영양제별 권장 용법을 참고하여 복용시간을 설정해주세요."
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
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
    
    override func configureHierarchy() {
        view.addSubview(addTimeButton)
        view.addSubview(editButton)
        view.addSubview(noticeLabel)
        view.addSubview(timeTableView)
    }
    
    override func configureConstraints() {
        addTimeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(addTimeButton.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(addTimeButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        timeTableView.snp.makeConstraints { make in
            make.top.equalTo(noticeLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func addTimeButtonClicked() {
        viewModel.addTimeButtonClicked.value = ()
    }
    
    @objc func editButtonClicked() {
        let shouldBeEdited = !timeTableView.isEditing
        timeTableView.setEditing(shouldBeEdited, animated: true)
        editButton.isSelected = shouldBeEdited
    }
}

extension TimeSettingViewController {
    func setNav() {
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .systemOrange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let registrationButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(registrationButtonClicked))
        let barItems = [flexibleSpace, registrationButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc func registrationButtonClicked() {
        viewModel.inputTimeList.value = viewModel.outputSelectTimeList.value
        dismiss(animated: true)
    }
}

extension TimeSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSelectTimeStringList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeSettingTableViewCell.identifier, for: indexPath) as! TimeSettingTableViewCell
        let data = viewModel.outputSelectTimeStringList.value[indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if viewModel.outputSelectTimeStringList.value.count > 1 {
            viewModel.outputSelectTimeStringList.value.remove(at: indexPath.row)
            viewModel.outputSelectTimeList.value.remove(at: indexPath.row)
        } else {
            return // 나중에 알럿? 토스트? 처리 할 예정
        }
    }
}
