//
//  FC_HomeViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FC_HomeViewController: UIViewController {

    private lazy var navigationBar: FC_HomeNavigationView = {
        let navigationBar = FC_HomeNavigationView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 120))
        return navigationBar
    }()
    
    private lazy var headView: FC_HomeHeadView = {
        let w = (kScreenW - 20*2 - 3)/4
        let headView = FC_HomeHeadView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 43+w*3+4+70))
        return headView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 120, width: kScreenW, height: kScreenH - 120 - kTabBarHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FC_HomeViewCell.self, forCellReuseIdentifier: "FC_HomeViewCell")
        return tableView
    }()
    
    /// 主入口
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
        clickAction()
        
    }
}

// MARK: - 私有方法
extension FC_HomeViewController {
    
    /// 基础设置
    fileprivate func setupUI() {
        navigationController?.delegate = self
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        tableView.tableHeaderView = headView
        
        // 头部点击索引值回调
        headView.clickItem = { [weak self] in
            switch $0 {
            case 0:
                let vc = FC_ListingViewController()
                vc.title = "设备清单"
                self?.navigationController?.pushViewController(vc, animated: true)
                
            default:
                let vc = FC_EquipmentListViewController()
                vc.title = $1
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - 事件响应
extension FC_HomeViewController {

    /// 顶部三个按钮事件
    fileprivate func clickAction() {
        navigationBar.didScanBut = {
            let vc = FC_QRCodeViewController()
            vc.pushType = .scan
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        navigationBar.didRepairBut = {
            let vc = FC_QRCodeViewController()
            vc.pushType = .repair
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        navigationBar.didNursingBut = {
//            let vc = FC_QRCodeViewController()
//            vc.pushType = .nursing
//            self.navigationController?.pushViewController(vc, animated: true)
            
            // push到登录（先屏蔽）
            let nav = FC_NavgationViewController.init(rootViewController: FC_LoginViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension FC_HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isShowNav: Bool = viewController.isKind(of: FC_HomeViewController.self)
        navigationController.setNavigationBarHidden(isShowNav, animated: true)
    }
}

// MARK: - tableViewDelegate、DataSource
extension FC_HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier = "FC_HomeViewCell"
        var cell:FC_HomeViewCell! = tableView.dequeueReusableCell(withIdentifier: indentifier) as? FC_HomeViewCell
        if cell == nil {
            cell = FC_HomeViewCell(style: .default, reuseIdentifier: indentifier)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
//            let userInfo:FC_UserInfo = FC_UserInfoTable().selectAll()
//            DLog(userInfo)
//            DLog("token == \(userInfo.token), name == \(userInfo.name)")
            
            let user = FC_SQLiteManager.manager.selectAll()
            DLog(user)
            
        }else if indexPath.row == 1 {
            // 第一次修改
            var user = FC_UserInfo()
            user.token = "changeToken"
            FC_SQLiteManager.manager.update(id: 1, keyWord: "token", newsInfo: user)
            
        }else if indexPath.row == 2 {
            // 第二次修改
            var user = FC_UserInfo()
            user.phone = "18657187525"
            FC_SQLiteManager.manager.update(id: 1, keyWord: "phone", newsInfo: user)
            
        }else if indexPath.row == 3 {
            // 清空
            FC_SQLiteManager.manager.delete(id: 100)
            
        }else {
            // 插入
            var user = FC_UserInfo()
            user.token = "token"
            user.name = "xiaoM"
            FC_SQLiteManager.manager.insert(user)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
