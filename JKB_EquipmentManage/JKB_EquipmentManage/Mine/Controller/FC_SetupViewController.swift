//
//  FC_SetupViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/29.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_SetupViewController: UIViewController {

    
    @IBOutlet weak var phoneLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func clickButs(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            let changeVc = FC_ChangePhoneViewController()
            changeVc.title = "更换手机"
            navigationController?.pushViewController(changeVc, animated: true)
            
            break
        case 20:
            let changeVc = FC_ChangePswdViewController()
            changeVc.title = "修改密码"
            navigationController?.pushViewController(changeVc, animated: true)
            break
        case 30:
            
            break
        case 40:
            
            break
        default:
            break
        }
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        FC_NetProvider.shared.logOut(success: { (results) in
            
            let isSuc:Int = results["data"] as! Int
            if isSuc == 1 {
                FC_HUD.fc_showSuccess("退出成功")
            }
            
        }) { (_) in
            
        }
    }
    
}

extension FC_SetupViewController {
    
    fileprivate func setupUI() {
        
    }
    
}
