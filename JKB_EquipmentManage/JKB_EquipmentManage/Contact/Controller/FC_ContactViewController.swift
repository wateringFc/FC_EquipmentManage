//
//  FC_ContactViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FC_ContactViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension FC_ContactViewController {
    
    /// 设置UI
    private func setupUI() {
        
        let headerView = FC_HeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 70))
        // 点击头部视图
        headerView.didNewFriend = {
            let vc = FC_NewFriendViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Bg_f5f5f5
        tableView.separatorStyle = .none
        // 注册nib cell
        tableView.fc_registerCell(cell: FC_ContactCell.self)
    }
}


extension FC_ContactViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.fc_dequeueReusableCell(indexPath: indexPath) as FC_ContactCell
        return cell
    }
}


// MARK: - 头部视图 =====================================
class FC_HeaderView: UIView {
    
    /// 回调事件
    var didNewFriend: (()->())?
    
    private lazy var icon: UIImageView = {
        let icon = UIImageView(frame: CGRect(x: 25, y: 10, width: 40, height: 40))
        icon.image = imageNamed("chat_icn_newfred")
        return icon
    }()
    
    private lazy var title: UILabel = {
        let title = FC_CreateView.createLabel(rect: CGRect(x: 25+40+15, y: 0, width: 150, height: 60), title: "新的朋友", textColor: Normal_000000_Color, font: UIFont.systemFont(ofSize: 14))
        return title
    }()
    
    private lazy var redPoint: UILabel = {
        let redPoint = UILabel(frame: CGRect(x: kScreenW - 20 - 15, y: 20, width: 20, height: 20))
        redPoint.fc_corner(byRoundingCorners: .allCorners, radii: 10)
        redPoint.backgroundColor = .red
        redPoint.text = "5"
        redPoint.textColor = .white
        redPoint.textAlignment = .center
        redPoint.font = UIFont.systemFont(ofSize: 11)
        return redPoint
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 60, width: kScreenW, height: 10))
        lineView.backgroundColor = Bg_f5f5f5
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(title)
        addSubview(redPoint)
        addSubview(lineView)
        backgroundColor = .white
        self.fc_addTarget(target: self, action: #selector(newFriend))
    }
    
    @objc func newFriend() {
        didNewFriend?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
