//
//  BaseTabbarController.swift
//  LXMusicApp
//
//  Created by Lance on 2018/4/25.
//  Copyright © 2018年 Lance. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = MainViewController()
        addChildViewController(childController: mainViewController, title: "首页", imageName: "")
        
        
        
    }
    
    func addChildViewController(childController: UIViewController,title:String,imageName:String) {
        
        childController.title = title;
        
        childController.tabBarItem.image = UIImage(named: imageName)
        
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        tabBar.tintColor = UIColor.orange
        
        let nav = BaseNavigationController()
        
        nav.addChildViewController(childController)
        
        addChildViewController(nav)
        
    }
}
