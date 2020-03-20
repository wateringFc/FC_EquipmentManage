//
//  FC_MineHeadView.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/27.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_MineHeadView: UIView, NibLoadable {

    
    var pushInfoBut: (()->())?
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var companyLb: UILabel!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var nextBut: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImg.fc_corner(byRoundingCorners: .allCorners, radii: 5)
    }
    
    @IBAction func pushSetup(_ sender: UIButton) {
            pushInfoBut?()
    }
}
