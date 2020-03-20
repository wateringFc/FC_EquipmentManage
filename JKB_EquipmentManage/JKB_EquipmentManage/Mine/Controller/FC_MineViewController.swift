//
//  FC_MineViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_MineViewController: UIViewController {

    fileprivate let imgs:[String] = ["mine_icn_outin", "mine_inc_matain", "mine_inc_pre", "mine_icn_check", "mine_icn_bor", "mine_icn_recomand", "mine_icn_idea", "mine_icn_set"]
    fileprivate let texts:[String] = ["我的出入库", "我的维修", "我的保养", "我的巡检", "我的借调", "推荐给好友", "意见反馈", "设置"]
    
    fileprivate lazy var headView: FC_MineHeadView = {
        let headView = FC_MineHeadView.loadViewFromNib()
        headView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 135)
        return headView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 135, width: kScreenW, height: kScreenH - 135 - kTabBarHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Bg_f5f5f5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mineCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}

extension FC_MineViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = Bg_f5f5f5
        view.addSubview(headView)
        headView.pushInfoBut = {
            let vc = FC_InfoViewController()
            vc.title = "个人信息"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(tableView)
        navigationController?.delegate = self
    }
}

// MARK: - tableViewDelegate、DataSource
extension FC_MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
            view.backgroundColor = Bg_f5f5f5
            return view
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 10 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mineCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = Normal_000000_Color
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named: imgs[indexPath.row])
            cell.textLabel?.text = texts[indexPath.row]
        }else {
            cell.imageView?.image = UIImage(named: imgs[indexPath.row+5])
            cell.textLabel?.text = texts[indexPath.row+5]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DLog("点击了\(indexPath.row)")
        
        if indexPath.section == 0 {
        
            
        }else {
            if indexPath.row == 0 {
                
            }else if indexPath.row == 1 {
                
            }else {
                let setupVc = FC_SetupViewController()
                setupVc.title = "设置"
                navigationController?.pushViewController(setupVc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UINavigationControllerDelegate
extension FC_MineViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isShowNav: Bool = viewController.isKind(of: FC_MineViewController.self)
        navigationController.setNavigationBarHidden(isShowNav, animated: true)
    }
}
