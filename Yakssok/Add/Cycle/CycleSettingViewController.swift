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
    var selectCycle: (([String]) -> Void)?
    
    let enterDayVC = DayIntervalViewController()
    let selectDayVC = DayOfTheWeekViewController()
    lazy var viewControllers = [enterDayVC, selectDayVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNav()
        setButtonBar()
    
        enterDayVC.selectDayInterval = { value in
            self.selectCycle?(value)
        }
        
        selectDayVC.selectDayOfTheWeek = { value in
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
