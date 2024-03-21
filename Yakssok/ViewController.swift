//
//  ViewController.swift
//  Yakssok
//
//  Created by Jaehui Yu on 3/7/24.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.background
        addVC()
    }

    private func addVC() {
        let calenderVC = UINavigationController(rootViewController: CalendarViewController())
        calenderVC.tabBarItem = UITabBarItem(title: "calendar", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar"))
        
        let myVC = UINavigationController(rootViewController: MyViewController())
        myVC.tabBarItem = UITabBarItem(title: "my", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        self.viewControllers = [calenderVC, myVC]
    }
}

