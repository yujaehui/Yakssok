//
//  ViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit
import Lottie
import SnapKit

class ViewController: UITabBarController {
    
    let viewModel = ViewModel()
    
    let splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.background
        tabBar.tintColor = ColorStyle.point
        
        setSplash()
        addVC()
    }
    
    private func setSplash() {
        view.addSubview(splashView)
        splashView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        splashView.animationCompletionHandler = {
            self.splashView.isHidden = true
        }
    }
    
    private func addVC() {
        let calenderVC = UINavigationController(rootViewController: CalendarViewController())
        calenderVC.tabBarItem = UITabBarItem(title: "복용 달력", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar"))
        
        let myVC = UINavigationController(rootViewController: MyViewController())
        myVC.tabBarItem = UITabBarItem(title: "내 영양제", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        self.viewControllers = [calenderVC, myVC]
    }
}

