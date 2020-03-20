//
//  FC_RepairCell.swift
//  JKB_EquipmentManage
//
//  Created by 方存 on 2019/5/24.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class FC_RepairCell: UITableViewCell, RegisterCellFromNib {

    /// 排名
    @IBOutlet weak var numLb: UILabel!
    /// 科室名称
    @IBOutlet weak var ksLb: UILabel!
    /// 占比率
    @IBOutlet weak var valueLb: UILabel!
    /// 项目
    @IBOutlet weak var nameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
