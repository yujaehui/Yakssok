//
//  CycleSettingViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/9/24.
//

import UIKit
import Tabman
import Pageboy

class CycleSettingViewController: TabmanViewController {
    
    let viewModel = CycleSettingViewModel()
    
    let dayOfTheWeekVC = DayOfTheWeekViewController()
    let dailyIntervalVC = DailyIntervalViewController()
    lazy var viewControllers = [dayOfTheWeekVC, dailyIntervalVC]
    var selectCycle: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNav()
        setButtonBar()
        
        dayOfTheWeekVC.selectDayOfTheWeek = { value in
            self.viewModel.inputDayOfTheWeekVC.value = value
        }
        
        dailyIntervalVC.selectDailyInterval = { value in
            self.viewModel.inputDailyIntervalVC.value = value
        }
        
        bindData()
    }
    
    func bindData() {
        viewModel.outputDayOfTheWeekVC.bind { value in
            guard let value = value else { return }
            self.selectCycle?(value)
        }
        
        viewModel.outputDailyIntervalVC.bind { value in
            guard let value = value else { return }
            self.selectCycle?(value)
        }
    }
    
    func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarButtonItemClikced))
    }
    
    @objc func rightBarButtonItemClikced() {
        dismiss(animated: true)
    }
    
    private func setButtonBar() {
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        addBar(bar, dataSource: self, at: .top)
    }
}

extension CycleSettingViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = "Page \(index)"
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
