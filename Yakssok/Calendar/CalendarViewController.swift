//
//  CalendarViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/11/24.
//

import UIKit
import SnapKit
import Lottie
import RealmSwift

enum SectionType: CaseIterable {
    case calendar
    case chart
    case schedule
}

final class CalendarViewController: BaseViewController {
    
    let viewModel = CalendarViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = ColorStyle.background
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
    
    private let animationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(name: "congratulation")
        lottieAnimationView.backgroundColor = ColorStyle.background.withAlphaComponent(0.3)
        lottieAnimationView.animationSpeed = 1.5
        lottieAnimationView.contentMode = .scaleAspectFill
        return lottieAnimationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        bindData()
        animationView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputSelectedDate.value = self.viewModel.inputSelectedDate.value
        setTabBar()
    }
    
    private func bindData() {
        viewModel.outputData.bind { value in
            self.tableView.reloadData()
        }
        
        viewModel.outputCheckData.bind { value in
            self.tableView.reloadData()
        }
        
        viewModel.outputCheckStatus.bind { [weak self] (status, data) in
            guard let self = self else { return }
            guard let data = data else { return }
            switch status {
            case .checked:
                self.viewModel.repository.deleteCheckItem(data)
                self.viewModel.inputSelectedDate.value = self.viewModel.inputSelectedDate.value
            case .uncheckedAndNotDue:
                let alert = AlertManager.shared.showAlert(title: "체크하기 전 확인!", message: "아직 오지 않은 날짜의 일정입니다.\n그럼에도 체크하시겠습니까?", btnTitle: "체크") { _ in
                    self.viewModel.repository.createCheckItem(data)
                    self.viewModel.inputSelectedDate.value = self.viewModel.inputSelectedDate.value
                }
                self.present(alert, animated: true)
            case .unchecked:
                self.viewModel.repository.createCheckItem(data)
                self.viewModel.inputSelectedDate.value = self.viewModel.inputSelectedDate.value
                
            }
        }
    }
    
    // 수정 전 코드
//    private func bindData() {
//        viewModel.outputGroupedDataDict.bind { value in
//            self.tableView.reloadData()
//        }
//        
//        viewModel.outputShowAlert.bind { value in
//            guard let (showAlert, supplement) = value else { return }
//            if showAlert {
//                let alert = AlertManager.shared.showAlert(title: "체크하기 전 확인!", message: "아직 오지 않은 날짜의 일정입니다.\n그럼에도 체크하시겠습니까?", btnTitle: "체크") { _ in
//                    self.viewModel.repository.updateIsCompleted(pk: supplement.pk)
//                    self.tableView.reloadData()
//                }
//                self.present(alert, animated: true)
//            } else {
//                self.viewModel.repository.updateIsCompleted(pk: supplement.pk)
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(animationView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        animationView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CalendarViewController {
    private func setNav() {
        navigationController?.navigationBar.tintColor = ColorStyle.point
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: LogoView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
        navigationItem.backButtonTitle = ""
    }
    
    @objc private func rightBarButtonItemClikced() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.outputData.value.count + 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return nil
        case 1: return nil
        default:
            let view = ScheduleHeaderView()
            let date = viewModel.outputData.value[section - 2].0
            view.timeLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter2(date: date)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        default: return viewModel.outputData.value[section - 2].1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
            cell.passDate = { self.viewModel.inputSelectedDate.value = $0 }
            cell.passMoment = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        case 1:
            if self.viewModel.outputData.value.flatMap({ $0.1 }).count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as! ChartTableViewCell
                
                let allData = self.viewModel.outputData.value.flatMap({$0.1})
                let checkData = self.viewModel.outputCheckData.value
                
                cell.configureCell(allData: allData,
                                   checkData: checkData)
                
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
            
            let data = viewModel.outputData.value[indexPath.section - 2].1[indexPath.row]
            let checkData = viewModel.outputCheckData.value
            
            cell.configureCell(data: data,
                               checkData: checkData,
                               checkTime: self.viewModel.outputData.value[indexPath.section - 2].0)
            
            cell.buttonAction = {
                self.viewModel.inputCheck.value = (self.viewModel.outputData.value[indexPath.section - 2].0,
                                                   self.viewModel.outputData.value[indexPath.section - 2].1[indexPath.row].pk)
                self.showAnimation(allData: self.viewModel.outputData.value.flatMap({$0.1}),
                                   checkData: self.viewModel.outputCheckData.value)
            }
            
            return cell
        }
    }
    
    private func showAnimation(allData: [MySupplement], checkData: [CheckSupplement]) {
        if allData.count == checkData.count {
            self.animationView.alpha = 1
            self.animationView.isHidden = false
            self.animationView.play { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.animationView.alpha = 0
                }, completion: { _ in
                    self.animationView.isHidden = true
                })
            }
        } else {
            return
        }
    }
}

// 수정 전 코드
//extension CalendarViewController {
//    private func setNav() {
//        navigationController?.navigationBar.tintColor = ColorStyle.point
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: LogoView())
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
//        navigationItem.backButtonTitle = ""
//    }
//    
//    @objc private func rightBarButtonItemClikced() {
//        let vc = AddViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    private func setTabBar() {
//        tabBarController?.tabBar.isHidden = false
//    }
//}
//
//extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.outputGroupedDataDict.value.count + 2
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0: return nil
//        case 1: return nil
//        default:
//            let view = ScheduleHeaderView()
//            let date = viewModel.outputGroupedDataDict.value[section - 2].0
//            view.timeLabel.text = DateFormatterManager.shared.makeHeaderDateFormatter2(date: date)
//            return view
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 1
//        case 1: return 1
//        default: return viewModel.outputGroupedDataDict.value[section - 2].1.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
//            cell.passDate = { value in
//                self.viewModel.inputDidSelectDate.value = value
//            }
//            cell.passMoment = {
//                tableView.beginUpdates()
//                tableView.endUpdates()
//            }
//            return cell
//        case 1:
//            if self.viewModel.outputGroupedDataDict.value.flatMap({ $0.1 }).count == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as! EmptyTableViewCell
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.identifier, for: indexPath) as! ChartTableViewCell
//                let data = self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }
//                cell.configureCell(data)
//                return cell
//            }
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
//            let allData = self.viewModel.outputGroupedDataDict.value.flatMap { $0.1 }
//            let data = viewModel.outputGroupedDataDict.value[indexPath.section - 2].1[indexPath.row]
//            cell.configureCell(data)
//            cell.buttonAction = {
//                self.viewModel.inputDidCheckTime.value = data
//                self.showAnimation(allData)
//            }
//            return cell
//        }
//    }
//    
//    private func showAnimation(_ allData: [MySupplements]) {
//        if allData.count == allData.filter({ $0.isChecked }).count {
//            self.animationView.alpha = 1
//            self.animationView.isHidden = false
//            self.animationView.play { _ in
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.animationView.alpha = 0
//                }, completion: { _ in
//                    self.animationView.isHidden = true
//                })
//            }
//        }
//    }
//}
