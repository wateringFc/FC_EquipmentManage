//
//  FC_ListingViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/12.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FC_ListingViewController: UIViewController {

    /// 处理包
    private lazy var disposeBag = DisposeBag()
    /// 指示器
    fileprivate var lineView: UIView?
    /// 选中的按钮
    fileprivate var selectBut: UIButton?
    
    fileprivate lazy var searchView: FC_TitleView = {
        let searchView = FC_TitleView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenW, height: 55))
        searchView.placeholder = "搜索设备名称或编码"
        return searchView
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavBarHeight + 55 + 40, width: kScreenW, height: kScreenH - kNavBarHeight - 95 - kSafeBottomAreaH), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        navTitleView()
    }
}

extension FC_ListingViewController {
    
    /// 基础设置
    fileprivate func setupUI(){
        view.backgroundColor = UIColor.white
        let right = UIBarButtonItem().initWithImage(image: "home_add", highImage: "home_add", target: self, action: #selector(addNewAssets))
        navigationItem.rightBarButtonItem = right
        
        view.addSubview(tableView)
        view.addSubview(searchView)
        
        let menu = FC_DownMenu.init(frame: CGRect(x: 0, y: kNavBarHeight + 55, width: kScreenW, height: 40), titleArr: ["所属科室"])
        let deptArr = ["不限", "0~10", "11~50", "51~100", "101~500", "501~800", "801~1000", "1001~2000", "20001~5000", ">5000"];
        menu.menuDataArray.add(deptArr)
        view.addSubview(menu)
        
        // 闭包回调选中内容
        menu.handleSelectDataBlock = { (contenStr , indexRow , butTag) in
            print("当前选择 = \(contenStr),  第 \(indexRow) 行,  按钮的tag = \(butTag)")
        }
    }
    
    /// 头部视图
    fileprivate func navTitleView() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 230, height: 30))
        navigationItem.titleView = titleView
        let titles = ["非易耗品", "易耗品"]
        for index in 0..<titles.count {
            let but = UIButton(type: .custom)
            but.frame = CGRect(x: 105*index + 20*index, y: 0, width: 105, height: 30)
            but.setTitle(titles[index], for: .normal)
            but.setTitleColor(Main_222222_Color, for: .normal)
            but.setTitleColor(Theme_4B77F6_Blue, for: .disabled)
            but.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            but.tag = index + 100
            but.addTarget(self, action: #selector(titleButs(but:)), for: .touchUpInside)
            if index == 0 {
                but.isEnabled = false
                selectBut = but
            }
            titleView.addSubview(but)
        }
        lineView = UIView(frame: CGRect(x: 0, y: 28, width: 100, height: 2))
        lineView!.backgroundColor = Theme_4B77F6_Blue
        titleView.addSubview(lineView!)
    }
    
}

// MARK: - 事件响应
extension FC_ListingViewController {
    
    /// 新增
    @objc func addNewAssets(){
        let vc = FC_AddNewAssetsViewController()
        vc.title = "新增资产"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击顶部视图
    @objc func titleButs(but: UIButton) {
        selectBut?.isEnabled = true
        but.isEnabled = false
        selectBut = but
        UIView.animate(withDuration: 0.25, animations: {
            self.lineView!.centerX = self.selectBut!.centerX
        })
        if but.tag == 100 {
            selectBut?.setTitle("非易耗品(896)", for: .normal)
        }else {
            selectBut?.setTitle("易耗品(89)", for: .normal)
        }
    }
}

extension FC_ListingViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DLog("\(indexPath.row)")
    }
    
    
}
