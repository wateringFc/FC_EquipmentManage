//
//  FC_FriendDetailsViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/17.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FC_FriendDetailsViewController: UIViewController {

    /// 头像
    @IBOutlet weak var headerImg: UIImageView!
    /// 性别
    @IBOutlet weak var sexImg: UIImageView!
    /// 名字
    @IBOutlet weak var nameLb: UILabel!
    /// 公司
    @IBOutlet weak var companyLb: UILabel!
    /// 资产
    @IBOutlet weak var assetsBut: UIButton!
    /// 维修
    @IBOutlet weak var repairBut: UIButton!
    /// 保养
    @IBOutlet weak var maintenanceBut: UIButton!
    /// 巡视
    @IBOutlet weak var inspectBut: UIButton!
    /// 通过验证  拨打电话
    @IBOutlet weak var operationBut: UIButton!
    /// 删除联系人
    @IBOutlet weak var deleteBut: UIButton!
    /// 处理包
    private lazy var disposeBag = DisposeBag()
    
    private let seleColor = HexColor(0x55B936)
    private var assets: Int?
    private var repair: Int?
    private var maintenance: Int?
    private var inspect: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
//        butIncidentResponse()
    }
    
    
    fileprivate func setBut(_ sender: UIButton) -> (Int){
        sender.isSelected = !sender.isSelected
        var selValue = 0
        if sender.isSelected {
            selValue = 1
            sender.layer.borderColor = seleColor.cgColor
            sender.setTitleColor(seleColor, for: .normal)
        }else {
            selValue = 0
            sender.layer.borderColor = Sub_666666_Color.cgColor
            sender.setTitleColor(Sub_666666_Color, for: .normal)
        }
        return selValue
    }
    
    @IBAction func zcBut(_ sender: UIButton) {
        assets = setBut(sender)
    }
    
    @IBAction func wxBut(_ sender: UIButton) {
       repair = setBut(sender)
    }
    
    @IBAction func byBut(_ sender: UIButton) {
        maintenance = setBut(sender)
    }
    
    @IBAction func xsBut(_ sender: UIButton) {
        inspect = setBut(sender)
    }
    
}

extension FC_FriendDetailsViewController {
    
    fileprivate func setupUI() {
        title = "姓名"
        headerImg.fc_corner(byRoundingCorners: .allCorners, radii: 5)
        
        addBorder(assetsBut)
        addBorder(repairBut)
        addBorder(maintenanceBut)
        addBorder(inspectBut)
        
        operationBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            DLog(self?.assets)
            DLog(self?.repair)
            DLog(self?.maintenance)
            DLog(self?.inspect)
            if self?.assets ?? 0 <=  0 &&
                self?.repair ?? 0 <= 0 &&
                self?.maintenance ?? 0 <=  0 &&
                self?.inspect ?? 0 <= 0 {
                FC_HUD.fc_showInfo("请设置身份")
            }else {
                DLog("通过")
            }
        }).disposed(by: disposeBag)
        
        deleteBut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            DLog("删除")
        }).disposed(by: disposeBag)
    }
    
    fileprivate func addBorder(_ but: UIButton){
        but.layer.cornerRadius = 14
        but.layer.masksToBounds = true
        but.layer.borderWidth = 1.0
        but.layer.borderColor = Sub_666666_Color.cgColor
    }
}
