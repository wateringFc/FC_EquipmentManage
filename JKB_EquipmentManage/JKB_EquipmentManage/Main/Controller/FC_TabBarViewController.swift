//
//  FC_TabBarViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/5.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = UITabBar.appearance()
        tabBar.tintColor = Theme_4B77F6_Blue
        addChildViewControllers()
    }
    
    /// 添加子控制器
    private func addChildViewControllers() {
        addChildViewController(childController: FC_HomeViewController(), title: "首页", imageName: "home_icn_tab_home_unselect", selectedImage: "home_icn_tab_home_select")
        addChildViewController(childController: FC_ContactViewController(), title: "联系人", imageName: "home_icn_tab_chat_unselect", selectedImage: "home_icn_tab_chat_select")
        addChildViewController(childController: FC_DataAnalysisViewController(), title: "数据", imageName: "home_icn_tab_data_unselect", selectedImage: "home_icn_tab_data_select")
        addChildViewController(childController: FC_MineViewController(), title: "我的", imageName: "home_icn_tab_me_unselect", selectedImage: "home_icn_tab_me_select")
    }
    
    private func addChildViewController(childController: UIViewController, title: String, imageName: String, selectedImage: String) {
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        childController.title = title
        let navC = FC_NavgationViewController(rootViewController: childController)
        addChildViewController(navC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
