//
//  FC_BaseTableViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/16.
//  Copyright © 2019年 JKB. All rights reserved.
//

//import UIKit
//import MJRefresh
//
//class FC_BaseTableViewController: UIViewController {
//
//    var style: UITableViewStyle!
//
//    // 顶部刷新
//    let header = MJRefreshNormalHeader()
//    // 底部加载
//    let footer = MJRefreshAutoNormalFooter()
//
//    lazy var dataArr = NSMutableArray()
//
//    lazy var tableView: UITableView = {
//        let tabH = iPhoneX() ? kScreenH - kSafeBottomAreaH : kScreenH
//        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: tabH), style: style)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = Bg_f5f5f5
//        tableView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
//        return tableView
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//
//    private func setRefresh() {
//        // 下拉刷新
//        header.setRefreshingTarget(self, refreshingAction: #selector(tableViewLoadNweDatas))
//        tableView.mj_header = header
//        tableView.mj_header.isAutomaticallyChangeAlpha = true
//        tableView.mj_header.beginRefreshing()
//        // 上拉加载
//        footer.setRefreshingTarget(self, refreshingAction: #selector(tableViewloadMoreDatas))
//        tableView.mj_footer = footer
//        tableView.mj_footer.isHidden = true
//    }
//
//    @objc func tableViewLoadNweDatas() {
//        FC_DispatchAfter(after: 2.0) {
//            self.tableView.mj_header.endRefreshing()
//        }
//    }
//
//    @objc func tableViewloadMoreDatas() {
//        FC_DispatchAfter(after: 2.0) {
//            self.tableView.mj_footer.endRefreshing()
//        }
//    }
//
//}


//
//extension FC_BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//}
