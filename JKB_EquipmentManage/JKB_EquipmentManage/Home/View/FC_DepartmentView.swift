//
//  FC_DepartmentView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/20.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import SnapKit

class FC_DepartmentView: UIView {

    /// 点击叉叉时 闭包回调点击行的下标及文字
    var didDepartmentViewCloseBlock: ((Int, String) -> ())?
    /// 闭包回调 添加 事件
    var didAddBlock: (() -> ())?
    /// 闭包回调 行点击 事件
    var didSelectRowBlock: ((Int, String) -> ())?
    
    /// 数据源
    var datas = [AllDeptModel](){
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var topView: UIView = {
        let topVoew = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        topVoew.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        topVoew.fc_addTarget(target: self, action: #selector(dismis))
        return topVoew
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 65, y: 10, width: self.width - 65*2, height: self.height - 10*2), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(FC_DepartmentCell.self, forCellReuseIdentifier: NSStringFromClass(FC_DepartmentCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topView)
        addSubview(tableView)
    }
    
    @objc func dismis() {
        removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FC_DepartmentView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FC_DepartmentCell.self), for: indexPath) as! FC_DepartmentCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.allDeptModel = datas[indexPath.row] // 模型赋值
        if indexPath.row == datas.count - 1 || indexPath.row == 0 {
            cell.closeImg.isHidden = true
            
        }else {
            cell.closeImg.isHidden = false
            // 点击了叉叉按钮
            cell.didCloseBut = {
                // 回调 下标 及 文字
                if self.didDepartmentViewCloseBlock != nil {
                    self.didDepartmentViewCloseBlock?(indexPath.row, cell.titleLb.text!)
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 点击添加按钮
        if indexPath.row == datas.count - 1 {
            if self.didAddBlock != nil {
                self.didAddBlock?()
            }
        }else {
            // 点击其它行
            let cell = tableView.cellForRow(at: indexPath) as! FC_DepartmentCell
            if self.didSelectRowBlock != nil {
                self.didSelectRowBlock?(indexPath.row, cell.titleLb.text!)
            }
            removeFromSuperview()
        }
    }
}


// MARK: - Cell--------------------------------------------
class FC_DepartmentCell: UITableViewCell {
    
    /// 回调点击了叉叉
    var didCloseBut: (() -> ())?
    
    /// 科室模型，赋值
    var allDeptModel = AllDeptModel(){
        didSet{
            titleLb.text = allDeptModel.name
        }
    }
    
    
    lazy var titleLb: UILabel = {
        let titleLb = FC_CreateView.createLabel(rect: CGRect.zero, title: "仓库", textColor: .white, bgColor:Theme_4B77F6_Blue, font: UIFont.systemFont(ofSize: 14), alignment: .center)
        return titleLb
    }()
    
    lazy var closeImg: UIImageView = {
        let closeImg = UIImageView()
        closeImg.image = UIImage(named: "home_close_white")
        return closeImg
    }()
    
    fileprivate lazy var button: UIButton = {
        let button  = UIButton(type: .custom)
        button.addTarget(self, action: #selector(FC_DepartmentCell.closeBut), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.clear
        return bottomLineView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLb.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - 5)
        closeImg.y = (contentView.height - 5 - 10)/2
        closeImg.size = CGSize(width: 10, height: 10)
        closeImg.x = contentView.width - 10 - 10
        button.frame = CGRect(x: contentView.width - 35, y: 0, width: 35, height: contentView.height)
        bottomLineView.frame = CGRect(x: 0, y: contentView.height - 5, width: contentView.width, height: 5)
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(titleLb)
        contentView.addSubview(closeImg)
        contentView.addSubview(button)
        contentView.addSubview(bottomLineView)
    }
    
    @objc func closeBut() {
        if didCloseBut != nil {
            didCloseBut?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
