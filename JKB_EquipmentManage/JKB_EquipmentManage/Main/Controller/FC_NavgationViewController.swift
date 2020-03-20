//
//  FC_NavgationViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/5.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_NavgationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initGlobalPan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0  {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon_titleBar"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
    @objc fileprivate func navigationBack() {
        popViewController(animated: true)
    }
}

extension FC_NavgationViewController: UIGestureRecognizerDelegate {
    
    /// 基础设置
    fileprivate func setupUI() {
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = .white
        navBar.tintColor = HexColor(0xf1f1f1)
        navBar.titleTextAttributes = [.font: TextStyleFont("PingFang SC", 17)]
    }
    
    /// 创建全局手势
    fileprivate func initGlobalPan() {
        // 添加手势
        let target = interactivePopGestureRecognizer?.delegate
        let globaPan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        globaPan.delegate = self
        self.view.addGestureRecognizer(globaPan)
        // 禁用系统手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    /// 何时支持全屏手势（如果不写此方法，会存在卡死问题，因为在首页的时候没有禁用手势，就会导致系统不知道往哪返回）
    fileprivate func handleNavigationTransition(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count != 1;
    }
}
