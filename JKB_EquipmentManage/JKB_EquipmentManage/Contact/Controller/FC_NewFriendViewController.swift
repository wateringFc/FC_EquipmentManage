//
//  FC_NewFriendViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/16.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import MJRefresh

class FC_NewFriendViewController: UITableViewController {

    fileprivate lazy var dataArr = NSMutableArray()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部加载
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setRefresh()
    }
}

extension FC_NewFriendViewController {
    
    private func setupUI() {
        title = "新的朋友"
        tableView.backgroundColor = Bg_f5f5f5
        tableView.separatorStyle = .none
        tableView.fc_registerCell(cell: FC_NewFriendCell.self)
    }
    
    private func setRefresh() {
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(loadNweDatas))
        tableView!.mj_header = header
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_header.beginRefreshing()
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreDatas))
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
    }
    
    @objc func loadNweDatas() {
        FC_DispatchAfter(after: 0.5) {
            self.tableView!.mj_header.endRefreshing()
        }
    }
    
    @objc func loadMoreDatas() {
        FC_DispatchAfter(after: 0.5) {
            self.tableView!.mj_footer.endRefreshing()
        }
    }
    
}

extension FC_NewFriendViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.mj_footer.isHidden = (dataArr.count == 0)
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fc_dequeueReusableCell(indexPath: indexPath) as FC_NewFriendCell
        cell.selectionStyle = .none
        
        cell.didCheckBut = {
            FC_DispatchAfter(after: 2.0) {
                DLog("查看")
                self.navigationController?.pushViewController(FC_FriendDetailsViewController(), animated: true)
            }
        }
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(FC_FriendDetailsViewController(), animated: true)
    }
}
