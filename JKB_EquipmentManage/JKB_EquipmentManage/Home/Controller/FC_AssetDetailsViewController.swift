//
//  FC_AssetDetailsViewController.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/6/12.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_AssetDetailsViewController: UIViewController {

    var code: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
}

extension FC_AssetDetailsViewController {
    
    fileprivate func getData(){
        FC_NetProvider.shared.assetDetail(codeOrId: code!, success: { (res) in
            
            DLog(res)
            
        }) { (_) in
            
        }
    }
    
}
