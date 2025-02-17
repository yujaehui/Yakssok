//
//  TimeViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import SnapKit
import Toast

final class TimeViewController: BaseViewController {
    var selectTimeList: (([Date]) -> Void)?
    
    let viewModel = TimeViewModel()
    
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
    
    private let noticeLabel: UILabel = {
        let label = CustomLabel(type: .descriptionGray)
        label.text = "영양제별 권장 용법을 참고하여 복용시간을 설정해주세요."
        return label
    }()
    
    private lazy var timeTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeTableViewCell.self, forCellReuseIdentifier: TimeTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var registrationButton: UIButton = {
       let button = UIButton()
        button.configuration = .registration(title: "등록")
        button.addTarget(self, action: #selector(registrationButtonClicked), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("TimeViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimeViewController viewDidLoad")
        bindData()
        setNav()
    }
    
    private func bindData() {
        viewModel.addTimeButtonClicked.bind { [weak self] value in
            guard value != nil else { return }
            let vc = TimePickerViewController()
            vc.selectTime = { [weak self] value in
                self?.viewModel.inputSelectTime.value =  value
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.didSelectRowAt.bind { [weak self] row in
            guard let self = self else { return }
            guard let row = row else { return }
            let vc = TimePickerViewController()
            vc.viewModel.inputType.value = .modify
            vc.timePicker.date = self.viewModel.outputSelectTimeList.value[row]
            vc.selectTime = { [weak self] value in
                guard let self = self else { return }
                self.viewModel.inputSelectTime.value =  value
            }
            vc.passUpdateMoment = { [weak self] value in
                guard let self = self else { return }
                guard let (value, date) = value else { return }
                if value && !self.viewModel.outputSelectTimeList.value.contains(where: { $0 == date }) {
                    self.viewModel.outputSelectTimeList.value.remove(at: row)
                } else {
                    return
                }
            }
            navigationController?.pushViewController(vc, animated: true)
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
        view.addSubview(registrationButton)
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
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(registrationButton.snp.top)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc private func addTimeButtonClicked() {
        viewModel.addTimeButtonClicked.value = ()
    }
    
    @objc private func editButtonClicked() {
        let shouldBeEdited = !timeTableView.isEditing
        timeTableView.setEditing(shouldBeEdited, animated: true)
        editButton.isSelected = shouldBeEdited
    }
    
    @objc private func registrationButtonClicked() {
        viewModel.inputTimeList.value = viewModel.outputSelectTimeList.value
        dismiss(animated: true)
    }
}

extension TimeViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc private func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
}

extension TimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSelectTimeStringList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.identifier, for: indexPath) as! TimeTableViewCell
        let data = viewModel.outputSelectTimeStringList.value[indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        self.viewModel.didSelectRowAt.value = row
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if viewModel.outputSelectTimeStringList.value.count > 1 {
            viewModel.outputSelectTimeStringList.value.remove(at: indexPath.row)
            viewModel.outputSelectTimeList.value.remove(at: indexPath.row)
        } else {
            var style = ToastStyle()
            style.backgroundColor = ColorStyle.point
            style.messageAlignment = .center
            style.messageFont = FontStyle.titleBold
            self.view.makeToast("최소한 하나의 항목은 있어야 합니다.", duration: 2, position: .bottom, style: style)
            return
        }
    }
}
