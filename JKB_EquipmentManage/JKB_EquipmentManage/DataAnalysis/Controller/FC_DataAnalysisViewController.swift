//
//  FC_DataAnalysisViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/6.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_DataAnalysisViewController: UIViewController {

    
    var totalLb: UILabel?
    var grossLb: UILabel?
    var numberLb: UILabel?
    
    fileprivate lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: 15, y: 78 + kNavBarHeight, width: kScreenW - 30, height: 1))
        lineView.backgroundColor = Line_e0e0e0_Gray
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
}

extension FC_DataAnalysisViewController {
    
    fileprivate func setupUI() {
        
        let num:[String] = ["988565", "65545", "36"]
        let text:[String] = ["资产总数", "资产总值", "部门数量"]
        for i in 0..<3 {
            let w = Int(kScreenW/3)
            let valueLb = FC_CreateView.createLabel(rect: CGRect(x: CGFloat(0 + i * w), y: 20 + kNavBarHeight, width: kScreenW/3, height: CGFloat(15)), title: num[i], textColor: Main_222222_Color, font: UIFont.boldSystemFont(ofSize: 16), alignment: .center)
            if i == 0 {
                totalLb = valueLb
            }else if i == 2 {
                grossLb = valueLb
            }else {
                numberLb = valueLb
            }
            
            let desLb = FC_CreateView.createLabel(rect: CGRect(x: CGFloat(0 + i * w), y: 46 + kNavBarHeight, width: kScreenW/3, height: CGFloat(15)), title: text[i], textColor: Sub_666666_Color, font: UIFont.systemFont(ofSize: 12), alignment: .center)
            view.addSubview(valueLb)
            view.addSubview(desLb)
        }
        
        view.addSubview(lineView)
        
        let titles:[String] = ["全院设备资产统计", "全院设备风险等级统计", "部门维修排行榜", "部门保养排行榜", "部门巡检排行榜", "设备故障数量top10", "设备报废数量top10"]
        for i in 0..<titles.count {
            let button = UIButton(type: .custom)
            let butH = 45
            button.frame = CGRect(x: CGFloat(15), y: CGFloat(Int(78 + 15 + kNavBarHeight) + Int(i * butH) + Int(i * 10)), width: CGFloat(kScreenW-30), height: CGFloat(butH))
            button.backgroundColor = HexColor(0xB4CCF5)
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(Normal_000000_Color, for: .normal)
            button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            button.tag = 1000+i
            button.fc_corner(byRoundingCorners: .allCorners, radii: 3)
            button.addTarget(self, action: #selector(buttonAction(but:)), for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    @objc func buttonAction(but: UIButton) {
        switch but.tag {
        case 1000:
            let vc = FC_AssetStatisticsViewController()
            vc.title = "资产统计"
            navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1001:
            let vc = FC_RiskLevelViewController()
            vc.title = "风险等级"
            navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1002:
            let vc = FC_RepairViewController()
            vc.title = "维修排行榜"
            vc.type = .vcType_repair
            navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1003:
            let vc = FC_RepairViewController()
            vc.title = "保养排行榜"
            vc.type = .vcType_maintenance
            navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1004:
            let vc = FC_RepairViewController()
            vc.title = "巡检排行榜"
            vc.type = .vcType_check
            navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1005:
            let vc = FC_EquipmentProblemViewController()
            vc.title = "设备故障Top10"
            vc.isProblemVc = true
            navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1006:
            let vc = FC_EquipmentProblemViewController()
            vc.title = "设备报废Top10"
            vc.isProblemVc = false
            navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
}
