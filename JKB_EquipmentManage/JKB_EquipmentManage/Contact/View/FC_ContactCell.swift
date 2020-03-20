//
//  FC_ContactCell.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/16.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_ContactCell: UITableViewCell, RegisterCellFromNib {

    /// 头像
    @IBOutlet weak var headImg: UIImageView!
    /// 名字
    @IBOutlet weak var nameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
